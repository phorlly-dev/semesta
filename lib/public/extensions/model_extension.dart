import 'package:semesta/app/models/feed.dart';

extension FeedX on Feed {
  bool get posted => type == Create.post;
  bool get hasQuote => type == Create.quote && pid.isNotEmpty;
  bool get hasComment => type == Create.reply && pid.isNotEmpty;
}
