import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../../Function/Firebase/upload_data.dart';
import '../../Utils/Global/global.dart';
import '../../Utils/utils.dart';
import '../../Widgets/widgets.dart';

class AddUsers extends StatefulWidget {
  const AddUsers({super.key});

  @override
  State<AddUsers> createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
  String _selectedProfile = '';
  final TextEditingController _profileController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false, _isValidNumber = false;
  final _formKey = GlobalKey<FormState>();
  static final List<dynamic> _profiles = ['Add Profile'];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _getProfiles() async {
    final adminsRef = _firestore.collection('Admins').doc(adminNumber);
    final adminsSnapshot = await adminsRef.get();

    if (adminsSnapshot.exists) {
      final profiles = adminsSnapshot.data()?['profiles'];
      return profiles;
    }
  }

  final Map<String, bool> _checkboxValues = {
    '%': true,
    'Open drawer': true,
    'E.C.': true,
    'Stock': false,
    'Report': false,
    'Customer': false,
    'R.M.': false,
    '(+)': true,
    'AMOUNT': true,
    '(-)': true,
    'T.VOID': true,
    'TNPrt': true,
    'PROMOTER': true,
    'COPY RECEIPT': true,
    'QTY': true,
    'Create PLU': false,
    'REFUND': false,
    'Delivery boy': false,
    'Tax shift and exempt': false,
    'Checkout in client': false,
  };

  double _completionPercentage = 0.0;

  @override
  void initState() {
    _getProfiles();

    super.initState();
  }

  void _updateCompletionPercentage() {
    double filledFields = 0;
    final controllers = [
      // _profileController,
      _nameController,
      _mobileController,
      _emailController,
      _profileController

      // _addressController,
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        filledFields += 1 / controllers.length;
      }
    }

    setState(() {
      _completionPercentage = filledFields;
    });
  }

  void _validatePhoneNumber(String value) {
    setState(() {
      _isValidNumber = value.length == 10 && RegExp(r'^[6789]').hasMatch(value);
      // if (value.length == 10) _focusNode.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Form(
          onChanged: _updateCompletionPercentage,
          key: _formKey,
          child: Column(
            children: [
              Gap.h(20),
              Lottie.asset('assets/animations/addUser.json'),
              Gap.h(20),
              // Display the progress indicator
              AnimatedProgressIndicator(value: _completionPercentage),
              Gap.h(20),
              buildTextFormField(
                labelText: 'Select Profile',
                readOnly: true,
                onTap: () => _showProfileList(),
                controller: _profileController,
                validator: (value) =>
                    value!.isEmpty ? 'Please Select a Profile' : null,
                sIcon: IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onPressed: () async {
                    final result = await showSearch(
                      context: context,
                      delegate: ProfileSearchDelegate(),
                    );
                    if (result != null) {
                      setState(() {
                        _selectedProfile = result;
                        _profileController.text = _selectedProfile;
                      });
                    }
                  },
                ),
              ),
              Gap.h(20),
              buildTextFormField(
                type: TextInputType.name,
                labelText: 'Name',
                controller: _nameController,
                validator: (value) {
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value!)) {
                    return 'Please enter a valid name';
                  }
                  return value.isEmpty ? 'Please Enter Your Name' : null;
                },
              ),
              Gap.h(20),
              buildTextFormField(
                prefix: const Text('+91 '),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                type: TextInputType.phone,
                labelText: 'Mobile Number',
                controller: _mobileController,
                validator: (value) {
                  if (!_isValidNumber) {
                    return 'Please Enter Valid Mobile Number';
                  }
                  return value!.isEmpty ? 'Please Enter Mobile Number' : null;
                },
                onChanged: (value) => _validatePhoneNumber(value),
              ),
              Gap.h(20),
              buildTextFormField(
                obscureText: true,
                type: TextInputType.emailAddress,
                labelText: 'Email',
                controller: _emailController,
                validator: (value) {
                  if (!RegExp(r'^[\w-]+@([\w-]+\.)+[\w-]{2,4}$',
                          caseSensitive: false)
                      .hasMatch(value!)) {
                    return 'Please enter a valid email address';
                  }
                  return value.isEmpty ? 'Please Enter Email' : null;
                },
              ),
              // Gap.h(20),
              // buildTextFormField(
              //   type: TextInputType.streetAddress,
              //   labelText: 'Address',
              //   controller: _addressController,
              //   validator: (value) =>
              //       value!.isEmpty ? 'Please Enter Address' : null,
              // ),
              Gap.h(20),

              Gap.h(20),
              ..._checkboxListTiles,
              Gap.h(50),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          buildBottomButton(context, textTheme, 'Add User', _isLoading, () {
        if (_formKey.currentState!.validate()) {
          setState(() {
            _isLoading = true;
          });
          uploadUserData(
                  context,
                  _nameController.text,
                  '+91${_mobileController.text}',
                  // _addressController.text,
                  _emailController.text,
                  _selectedProfile,
                  _checkboxValues)
              .then((_) {
            setState(() {
              _isLoading = false;
            });
            context.mounted ? Navigator.pop(context) : null;
          });
        }
      }),
    );
  }

  void _showProfileList() {
    showModalBottomSheet(
      useSafeArea: true,
      sheetAnimationStyle: AnimationStyle(curve: Curves.easeInCubic),
      context: context,
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _profiles.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_profiles[index]),
              onTap: () {
                if (_profiles[index] == 'Add Profile') {
                  // Open a new dialog to add a new profile
                  _showAddNewProfileDialog();
                } else {
                  setState(() {
                    _selectedProfile = _profiles[index];
                    _profileController.text = _selectedProfile;
                  });
                  Navigator.pop(context);
                }
              },
            );
          },
        );
      },
    );
  }

  void _showAddNewProfileDialog() {
    String newProfile = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add New Profile',
            style: textTheme.headlineMedium,
          ),
          content: TextField(
            onChanged: (value) {
              newProfile = value;
            },
          ),
          actions: [
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                // Add the new profile to the list
                setState(() {
                  _profiles.add(newProfile);
                  _selectedProfile = newProfile;
                  _profileController.text = _selectedProfile;
                });
                Navigator.pop(
                  context,
                  _selectedProfile,
                );
                // // Show the profile list again
                // _showProfileList();
              },
            ),
          ],
        );
      },
    );
  }

  Center buildDropdown() {
    return Center(
      child: PopupMenuButton(
        child: const Text('Select Profile'),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'Cashier',
            child: Text('Cashier'),
          ),
          const PopupMenuItem(
            value: 'Promoter',
            child: Text('Promoter'),
          ),
          const PopupMenuItem(
            value: 'Merchant',
            child: Text('Merchant'),
          ),
          const PopupMenuItem(
            value: 'Other',
            child: Text('Other'),
          ),
        ],
        onSelected: (value) {
          setState(() {
            _selectedProfile = value;
          });
        },
      ),
    );
  }

  List<Widget> get _checkboxListTiles {
    return _checkboxValues.keys
        .map((title) => CheckboxListTile(
              title: Text(title),
              value: _checkboxValues[title],
              onChanged: (bool? value) {
                setState(() {
                  _checkboxValues[title] = value!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ))
        .toList();
  }
}

class ProfileSearchDelegate extends SearchDelegate<String> {
  final profiles = ['Cashier', 'Promoter', 'Merchant', 'Other'];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView.builder(
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(profiles[index]),
          onTap: () {
            close(context, profiles[index]);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredProfiles = profiles
        .where((profile) => profile.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: filteredProfiles.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredProfiles[index]),
          onTap: () {
            close(context, filteredProfiles[index]);
          },
        );
      },
    );
  }
}

class ProfileSelector extends StatefulWidget {
  const ProfileSelector({super.key});

  @override
  ProfileSelectorState createState() => ProfileSelectorState();
}

class ProfileSelectorState extends State<ProfileSelector> {
  final _profileController = TextEditingController();
  final profiles = ['Cashier', 'Promoter', 'Merchant', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Profile'),
      ),
      body: Column(
        children: [
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              }
              return profiles.where((String option) {
                return option.contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selection) {
              setState(() {
                _profileController.text = selection;
              });
            },
            fieldViewBuilder: (BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
              return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  labelText: 'Select profile',
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Future<void> uploadUserData(BuildContext context, name, number, email, profile,
    Map<String, bool> checkboxValues) async {
  String? adminNumber = SharedPreferencesHelper.getString('adminNumber');
// String? userNumber = SharedPreferencesHelper.getString('userNumber');
  try {
    Map<String, dynamic> userData = {
      'uId': number,
      'name': name,
      'email': email,
      'profile': profile,
      'isVerified': false,
      'createdAt': Timestamp.now(),
      ...checkboxValues
    };

    await uploadDataToFirebase(
      collectionName: 'Admins',
      adminNumber: adminNumber!,
      name: 'Users',
      userNumber: number,
      data: userData,
    );

    (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Added will be added')));
    };
  } catch (e) {
    print('Error uploading user data: $e');
  }
}

class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  const AnimatedProgressIndicator({
    super.key,
    required this.value,
  });

  @override
  State<AnimatedProgressIndicator> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    final colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value?.withOpacity(0.4),
      ),
    );
  }
}
