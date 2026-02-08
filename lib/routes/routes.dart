import 'package:semesta/public/helpers/params_helper.dart';
import 'package:semesta/public/mixins/router_mixin.dart';

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

  int getIndex(String location) {
    return paths.indexWhere((p) => location.startsWith(p));
  }
}
