class Employee {
  Employee({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.reportingTo,
  });
  String id;
  String employeeId;
  String name;
  String reportingTo;

  factory Employee.from(Map data) {
    return Employee(
      id: data['id'].toString(),
      employeeId: data['employeeId'],
      name: data['name'],
      reportingTo: data['reportingTo'],
    );
  }

  Map toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'name': name,
      'reportingTo': reportingTo,
    };
  }
}
