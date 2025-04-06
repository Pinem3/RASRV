class User {
  final int? userId;
  final String username;
  final String password;
  final String position;
  final DateTime systemEntry;
  final DateTime systemExit;

  User({
    this.userId,
    required this.username,
    required this.password,
    required this.position,
    required this.systemEntry,
    required this.systemExit,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      username: json['username'],
      password: json['password'],
      position: json['position'],
      systemEntry: DateTime.parse(json['systemEntry']),
      systemExit: DateTime.parse(json['systemExit']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'password': password,
      'position': position,
      'systemEntry': systemEntry.toIso8601String(),
      'systemExit': systemExit.toIso8601String(),
    };
  }
}

class Equipment {
  final int? equipmentId;
  final String status;
  final String name;
  final String equipmentClass;

  Equipment({
    this.equipmentId,
    required this.status,
    required this.name,
    required this.equipmentClass,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      equipmentId: json['equipmentId'],
      status: json['status'],
      name: json['name'],
      equipmentClass: json['class'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'equipmentId': equipmentId,
      'status': status,
      'name': name,
      'class': equipmentClass,
    };
  }
}

class Production {
  final int productionId;
  final int materialId;
  final String name;
  final int equipmentId;
  final int processId;
  final int userId;

  Production({
    required this.productionId,
    required this.materialId,
    required this.name,
    required this.equipmentId,
    required this.processId,
    required this.userId,
  });

  factory Production.fromJson(Map<String, dynamic> json) {
    return Production(
      productionId: json['productionId'],
      materialId: json['materialId'],
      name: json['name'],
      equipmentId: json['equipmentId'],
      processId: json['processId'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productionId': productionId,
      'materialId': materialId,
      'name': name,
      'equipmentId': equipmentId,
      'processId': processId,
      'userId': userId,
    };
  }
}

class Log {
  final int logId;
  final DateTime timestamp;
  final String content;
  final String type;
  final int productionId;

  Log({
    required this.logId,
    required this.timestamp,
    required this.content,
    required this.type,
    required this.productionId,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      logId: json['logId'],
      timestamp: DateTime.parse(json['timestamp']),
      content: json['content'],
      type: json['type'],
      productionId: json['productionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logId': logId,
      'timestamp': timestamp.toIso8601String(),
      'content': content,
      'type': type,
      'productionId': productionId,
    };
  }
}
