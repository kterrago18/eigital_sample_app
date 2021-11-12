import 'package:jiffy/jiffy.dart';

class TimeAgo {
  var toUtc;
  TimeAgo() {
    toUtc = Jiffy(DateTime.now()).format("yyyy-MM-dd HH:mm:ss");
  }
  String getTimeAgo(DateTime date) {
    String timeago;

    Duration diff = DateTime.now().difference(date);

    if (diff.inDays > 1) {
      timeago = Jiffy(date).yMMMEdjm;
    } else {
      timeago = Jiffy(date).from(toUtc);
    }

    return timeago;
  }
}
