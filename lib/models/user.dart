Map<int, String> rolesInt = {
  0: "SUPER ADMIN",
  1: "STATION MASTER",
  2: "CHECKER",
  3: "PASSENGER",
};

class Role {
  static const SUPER_ADMIN = 0;
  static const STATION_MASTER = 1;
  static const CHECKER = 2;
  static const PASSENGER = 3;
}

Map<int, String> approvalStatuses = {
  0: "PENDING",
  1: "APPROVED",
  2: "DECLINE",
};

class User {
  String? id;
  String? title;
  String firstName;
  String? lastName;
  String email;
  int role;
  int? approvalStatus;

  User({
    this.id,
    required this.title,
    required this.firstName,
    this.lastName,
    required this.email,
    required this.role,
    this.approvalStatus,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String,
        title = json['title'] as String?,
        firstName = json['firstName'] as String,
        lastName = json['lastName'] as String,
        email = json['email'] as String,
        role = json['role'] as int,
        approvalStatus = json['approvalStatus'] as int?;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'role': role,
        'approvalStatus': role,
      };

  String getApprovalStatus() {
    return getApprovalStatusFromNumber(approvalStatus);
  }

  String getRole() {
    return getRoleStringFromNumber(role);
  }

  static String getApprovalStatusFromNumber(int? status) {
    return status != null ? approvalStatuses[status] ?? "none" : "none";
  }

  static String getRoleStringFromNumber(int role) {
    return rolesInt[role] ?? "none";
  }

  static int getRoleNumberFromString(String role) {
    return rolesInt.keys.firstWhere((k) => rolesInt[k] == role, orElse: () => 3);
  }
  
  static int getApprovalStatusNumberFromString(String approvalStatus) {
    return approvalStatuses.keys.firstWhere((k) => approvalStatuses[k] == approvalStatus, orElse: () => 0);
  }

}
