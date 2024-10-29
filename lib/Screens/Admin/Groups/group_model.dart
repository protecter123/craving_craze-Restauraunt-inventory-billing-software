class Group {
  final int id;
  final String description;
  final bool flag;

  Group({required this.description, this.id = 0, this.flag = true});

  factory Group.fromFireStore(Map<String, dynamic> data) {
    return Group(
      id: data['id'] ?? _getNextId(),
      description: data['description'],
      flag: data['flag'] ?? 1,
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'description': description,
      'flag': flag,
    };
  }

  static int _nextId = 1;
  static int _getNextId() {
    return _nextId++;
  }

  Group copyWith({int? id, String? description, bool? flag}) {
    return Group(
      id: id ?? this.id,
      description: description ?? this.description,
      flag: flag ?? this.flag,
    );
  }
}
