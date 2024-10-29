import 'package:flutter/material.dart';

import '../utils.dart';

ThemeData themeData = ThemeData(
  // Basic color properties
  primaryColor: Colors.blue,
  primaryColorLight: Colors.lightBlue,
  primaryColorDark: Colors.blue[800],
  hintColor: Colors.orange,
  scaffoldBackgroundColor: Colors.white,
  canvasColor: Colors.grey[50],
  cardColor: Colors.white,
  dividerColor: Colors.grey,
  highlightColor: Colors.white70,
  splashColor: Colors.green.shade200,
  // selectedRowColor: Colors.blue[100],
  unselectedWidgetColor: Colors.grey,
  disabledColor: Colors.grey[300],
  // buttonColor: Colors.blue,
  secondaryHeaderColor: Colors.blue[100],
  dialogBackgroundColor: Colors.white,
  indicatorColor: Colors.white60,
  // hintColor: Colors.grey,

  // Typography
  fontFamily: 'Georgia',
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
    bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
  ),
  // primaryTextTheme: const TextTheme(
  //   titleLarge: TextStyle(color: Colors.white),
  // ),

  // Icon themes
  iconTheme: const IconThemeData(
    color: m,
    size: 24.0,
  ),
  primaryIconTheme: const IconThemeData(
    color: Colors.orange,
    size: 24.0,
  ),

  // Button themes
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: sec,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        minimumSize: const Size(double.maxFinite, 40)),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.blue,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.blue,
      side: const BorderSide(color: Colors.blue),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
    ),
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    fillColor: Colors.blue[100],
    selectedColor: Colors.blue,
    color: Colors.blue[700],
    borderColor: Colors.blue,
  ),

  // AppBar theme
  appBarTheme: AppBarTheme(
    centerTitle: true,
    // color: m,
    // iconTheme: const IconThemeData(color: Colors.white70),
    // actionsIconTheme: const IconThemeData(color: Colors.white70),
    toolbarTextStyle: const TextTheme(
      titleLarge: TextStyle(fontSize: 20, color: m),
    ).bodyMedium,
    titleTextStyle: const TextTheme(
      titleLarge: TextStyle(fontSize: 30, color: m),
    ).titleLarge,
  ),

  // BottomAppBar theme
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Colors.white70,
    shape: CircularNotchedRectangle(),
  ),

  // BottomNavigationBar theme
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white70,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey[300],
  ),

  // TabBar theme
  tabBarTheme: const TabBarTheme(
    labelColor: m,
    unselectedLabelColor: Colors.grey,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: m, width: 2.0),
    ),
  ),

  // FloatingActionButton theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),

  // Card theme
  cardTheme: CardTheme(
    color: Colors.white,
    shadowColor: Colors.grey,
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),

  // Chip theme
  chipTheme: ChipThemeData(
    backgroundColor: Colors.grey[300],
    disabledColor: Colors.grey[100],
    selectedColor: Colors.blue[300],
    secondarySelectedColor: Colors.blue[100],
    padding: const EdgeInsets.all(4.0),
    labelStyle: const TextStyle(color: Colors.black),
    secondaryLabelStyle: const TextStyle(color: Colors.white),
    brightness: Brightness.light,
  ),

  // Dialog theme
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    contentTextStyle: const TextStyle(fontSize: 16),
  ),

  // InputDecoration theme
  inputDecorationTheme: const InputDecorationTheme(
    // iconColor: Colors.white70,
    // suffixIconColor: Colors.white70,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(5))),
    disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(5))),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(color: Colors.red)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(5))),
    labelStyle: TextStyle(color: Colors.black),
  ),

  // Slider theme
  sliderTheme: SliderThemeData(
    activeTrackColor: Colors.blue,
    inactiveTrackColor: Colors.blue[100],
    thumbColor: Colors.blue,
    overlayColor: Colors.blue.withAlpha(32),
    valueIndicatorColor: Colors.blue,
  ),

  // SnackBar theme
  snackBarTheme: SnackBarThemeData(
    // width: MediaQuery.of(context as BuildContext).size.width*8,
    dismissDirection: DismissDirection.down,
    backgroundColor: m,
    insetPadding: const EdgeInsets.all(30),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    contentTextStyle: const TextStyle(color: Colors.white),
  ),

  // Tooltip theme
  tooltipTheme: TooltipThemeData(
    decoration: BoxDecoration(
      color: Colors.blue.withOpacity(0.9),
      borderRadius: BorderRadius.circular(10),
    ),
    textStyle: const TextStyle(color: Colors.white),
  ),

  // PopupMenu theme
  popupMenuTheme: const PopupMenuThemeData(
    color: Colors.white,
    textStyle: TextStyle(color: Colors.black),
  ),

  // PageTransitions theme
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),

  // BottomSheet theme
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  ),

  // Divider theme
  dividerTheme: const DividerThemeData(
    color: Colors.black,
    space: 1,
    thickness: 1,
  ),
  checkboxTheme: CheckboxThemeData(
    // shape:OutlinedBorder(side: ),
    checkColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return Colors.blue;
      }
      return null;
    }),
    // fillColor:
    //     WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
    //   if (states.contains(WidgetState.disabled)) {
    //     return null;
    //   }
    //   if (states.contains(WidgetState.selected)) {
    //     return Colors.grey;
    //   }
    //   return null;
    // }),
  ),
  radioTheme: RadioThemeData(
    fillColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return Colors.blueAccent;
      }
      return null;
    }),
  ),
  switchTheme: SwitchThemeData(
    thumbColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return Colors.blue;
      }
      return null;
    }),
    trackColor:
        WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.selected)) {
        return Colors.blue;
      }
      return null;
    }),
  ),
  colorScheme: ColorScheme.light(
    primary: Colors.grey.shade100,
    secondary: Colors.grey.shade100,
    surface: Colors.grey.shade100,
    error: Colors.red,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onError: Colors.black,
  ).copyWith(),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.grey,
    selectionColor: Colors.blue[200],
    selectionHandleColor: Colors.blue[700],
  ),
);
