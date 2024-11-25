class PillModel {
  final int id;
  final String name;
  final String dosage;
  final String time;
  final String type;
  bool isTaken;

  PillModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.type,
    this.isTaken = false, required List<bool> selectedDays,
  });
}
