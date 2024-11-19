class Membership {
  final String membershipLevelName;
  final String companyId;
  final String startDate;
  final String endDate;

  Membership({
    required this.membershipLevelName,
    required this.companyId,
    required this.startDate,
    required this.endDate,
  });

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      membershipLevelName: json['membershipLevelName'],
      companyId: json['companyId'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'membershipLevelName': membershipLevelName,
      'companyId': companyId,
      'startDate': startDate,
      'endDate': endDate
    };
  }
}
