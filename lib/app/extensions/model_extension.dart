import 'package:semesta/core/models/feed.dart';

extension FeedX on Feed {
  bool get posted => type == Create.post;
  bool get hasQuote => type == Create.quote && pid.isNotEmpty;
  bool get hasComment => type == Create.comment && pid.isNotEmpty;
}
