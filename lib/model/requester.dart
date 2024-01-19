class Requester {
  Requester({
    required this.id,
    required this.type,
    required this.employee,
    required this.notes,
    required this.status,
    required this.assetType,
    required this.model,
  });

  String id;
  String type;
  String employee;
  String notes;
  String status;
  String assetType;
  String model; 

  factory Requester.from(Map<String, dynamic> data) {
    return Requester(
      id: data['id'].toString(),
      type: data['type'],
      employee: data['employee'],
      notes: data['notes'],
      status: data['status']??'',
      assetType: data['assetType']??'',
      model: data['model'],
    );
  }

  Map toMap() {
    return {
      'id': id,
      'type': type,
      'employee': employee,
      'notes': notes,
      'status': status,
      'assetType': assetType,
      'model':model
    };
  }
}
