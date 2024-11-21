class PillModel {
  final int id;
  final String name;
  final String dosage;
  final String time;
  final String type;
  final bool? isNotificationEnabled;
  bool isTaken;

  PillModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.type,
    this.isNotificationEnabled,
    this.isTaken = false,
  });
}
