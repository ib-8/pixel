class Event {
  Event({
    required this.id,
    required this.assetId,
    this.expense,
    this.note,
    required this.type,
    required this.employee,
    this.vendor,
  });

  String id;
  String assetId;
  String type;
  String? employee;
  String? expense;
  String? note;
  String? vendor;

  factory Event.from(Map data) {
    return Event(
      id: data['id'].toString(),
      assetId: data['assetId'].toString(),
      expense: data['expense'],
      note: data['note'] ?? '',
      type: data['type'],
      employee: data['employee'] ?? '',
      vendor: data['vendor'] ?? '',
    );
  }

  Map toMap() {
    return {
      'assetId': assetId,
      'expense': expense,
      'note': note,
      'type': type,
      'employee': employee,
      'vendor': vendor,
    };
  }
}
