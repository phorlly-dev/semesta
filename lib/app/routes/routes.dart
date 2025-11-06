import 'package:semesta/app/routes/custom_route.dart';
import 'package:semesta/app/routes/route_params.dart';

class Routes extends CustomRoute {
  RouteParams get home => RouteParams(path: _convert('home'), name: 'home');
  RouteParams get splash =>
      RouteParams(path: _convert('splash'), name: 'splash');
  RouteParams get auth => RouteParams(path: _convert('auth'), name: 'auth');
  RouteParams get feed => RouteParams(path: _convert('feed'), name: 'feed');

  String _convert(String params) => '/$params-page';
}
