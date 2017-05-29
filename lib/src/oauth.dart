library gitter.oauth;

import 'dart:async';

import 'package:gitter/gitter.dart';
import 'package:gitter/src/oauth/oauth.dart';

abstract class GitterOAuth extends OAuth {
  GitterOAuth(AppInformations appInformations, {bool force: false})
      : super(appInformations, new GitterCodeInformations(appInformations));

  @override
  void generateTokenInformations() {
    tokenInformations = new GitterTokenInformations(appInformations, code);
  }

  Future<GitterToken> signIn() async {
    String resultCode = await requestCode();
    if (resultCode != null) {
      generateTokenInformations();
      return new GitterToken.fromJson(await getToken());
    }
    return null;
  }
}
