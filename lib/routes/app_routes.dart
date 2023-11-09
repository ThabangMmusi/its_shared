part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();

  static const unknownRoute = _Paths.unknownRoute;
  static const uploads = _Paths.uploads;
  static const home = _Paths.home;
  static const search = _Paths.search;
  static const profile = _Paths.profile;
  static const auth = _Paths.auth;
  static const signIn = auth + _Paths.signIn;
  static const webAuth = auth + _Paths.webAuth;
  static const awaitingWebAuth = auth + _Paths.awaitingWebAuth;
  static const webAuthSuccessful = auth + _Paths.webAuthSuccessful;
  static const verification = auth + _Paths.verification;

  static const setup = _Paths.setup;
  static const welcome = _Paths.welcome;
  // static const insuranceView = _Paths.insuranceView;
  static const loading = _Paths.loading;
  static const splash = _Paths.splash;
  static const landingPage = _Paths.landingPage;
}

abstract class _Paths {
  static const loading = '/loading';
  static const splash = '/splash';
  static const home = '/home';
  static const search = "/search";
  static const uploads = '/uploads';
  static const auth = '/auth';
  static const signIn = '/signin';
  static const webAuth = '/web-auth';
  static const awaitingWebAuth = "/awaiting_auth";
  static const webAuthSuccessful = '/web-auth-successful';
  static const profile = '/profile';
  static const setup = '/setup';
  static const welcome = '/welcome';
  static const verification = "/verification";

  static const unknownRoute = "/404";

  static const landingPage = "/landingPage";
}
