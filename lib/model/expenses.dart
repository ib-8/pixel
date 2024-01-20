class Expenses {
  Expenses({
    required this.type,
    required this.assetId,
    required this.amount,
    required this.vendor,
    required this.note,
    required this.date,
  });

  String type;
  String assetId;
  String amount;
  String vendor;
  String note;
  DateTime? date;

  factory Expenses.from(Map data) {
    print('fff $data');
    return Expenses(
        type: data['type'],
        assetId: data['assetId'],
        amount: data['amount'],
        vendor: data['vendor'],
        note: data['note'] ?? '',
        date: DateTime.tryParse(
          data['date'],
        ));
  }

  Map toMap() {
    return {
      'type': type,
      'assetId': assetId,
      'amount': amount,
      'vendor': vendor,
      'note': note,
      'date': date
    };
  }
}
