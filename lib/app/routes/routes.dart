import 'package:semesta/core/mixins/router_mixin.dart';
import 'package:semesta/app/utils/params.dart';

class Routes with RouterMixin, UserRoutes, PostRoutes {
  // root (absolute)
  RouteNode get home => const RouteNode('/home', 'home');
  RouteNode get explore => const RouteNode('/explore', 'explore');
  RouteNode get reel => const RouteNode('/reel', 'reel');
  RouteNode get notify => const RouteNode('/notify', 'notify');
  RouteNode get messsage => const RouteNode('/messsage', 'messsage');

  //Outside
  RouteNode get splash => const RouteNode('/splash', 'splash');
  RouteNode get auth => const RouteNode('/auth', 'auth');

  //path menu
  List<String> get paths => [
    explore.path,
    reel.path,
    home.path,
    notify.path,
    messsage.path,
  ];

  List<String> get titles => [
    'Semesta',
    reel.name,
    explore.name,
    notify.name,
    messsage.name,
  ];

  int getIndexFromLocation(String location) {
    return paths.indexWhere((p) => location.startsWith(p));
  }
}
