class Event {
  Event({
    required this.id,
    required this.assetId,
    required this.expense,
    required this.note,
    required this.type,
    required this.user,
    required this.vendor,
  });

  String id;
  String assetId;
  String type;
  String user;
  String expense;
  String note;
  String vendor;

  factory Event.from(Map data) {
    return Event(
      id: data['id'].toString(),
      assetId: data['assetId'],
      expense: data['expense'],
      note: data['note'],
      type: data['type'],
      user: data['user'],
      vendor: data['vendor'],
    );
  }

  Map toMap() {
    return {
      'id': id,
      'assetId': assetId,
      'expense': expense,
      'note': note,
      'type': type,
      'user': user,
      'vendor': vendor,
    };
  }
}
