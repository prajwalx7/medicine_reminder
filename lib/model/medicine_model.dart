class PillModel {
  final int id;
  final String name;
  final String dosage;
  final String time;
  final String type;
  final bool? isNotificationEnabled;

  // Constructor
  PillModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.type,
    this.isNotificationEnabled,
  });
}
