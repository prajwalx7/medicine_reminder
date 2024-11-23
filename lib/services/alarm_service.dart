import 'dart:math';
import 'package:alarm/alarm.dart';

class AlarmService {
  static final Random _random = Random();

  static Future<void> scheduleAlarm({
    required DateTime alarmTime,
    required String medicineName,
  }) async {
    final int alarmId = _random.nextInt(2147483647);

    final alarmSettings = AlarmSettings(
      id: alarmId,
      dateTime: alarmTime,
      assetAudioPath: 'assets/audio/ring.mp3',
      loopAudio: true,
      vibrate: true,
      fadeDuration: 3.0,
      notificationSettings: NotificationSettings(
        title: 'Medicine Reminder',
        body: 'It\'s time to take your $medicineName!',
        stopButton: 'Dismiss',
      ),
    );

    await Alarm.set(alarmSettings: alarmSettings);
  }
}
