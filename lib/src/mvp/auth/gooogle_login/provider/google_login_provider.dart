import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app/utils/route/route_utils.dart';
import 'package:news_app/utils/utils.dart';

class GoogleLoginProvider extends ChangeNotifier {
  bool _isCircular = false;
  bool get isCircular => _isCircular;
  set isCircular(bool value) {
    _isCircular = value;
    notifyListeners();
  }

  signInWithGoogle(BuildContext context) async {
    isCircular = true;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((user) async {
        if (user.user != null) {
          VariableUtilities.preferences
              .setBool(LocalCacheKey.applicationLoginState, true);
          VariableUtilities.preferences.setString(
              LocalCacheKey.applicationUserResponse, user.user!.displayName!);
          await Navigator.of(context)
              .pushReplacementNamed(RouteUtilities.dashboardScreen);
        } else {
          Fluttertoast.showToast(msg: 'User Does not Exists');
        }
      });
      isCircular = false;
    } catch (e) {
      isCircular = false;
      // print
    }
  }

  signOutFromGoogle() async {
    await GoogleSignIn().signOut();
    await VariableUtilities.preferences
        .setBool(LocalCacheKey.applicationLoginState, false);
  }
}
