import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:news_app/src/mvp/auth/gooogle_login/provider/google_login_provider.dart';
import 'package:news_app/src/widgets/widgets.dart';
import 'package:news_app/utils/utils.dart';
import 'package:provider/provider.dart';

class GoogleLoginScreen extends StatefulWidget {
  const GoogleLoginScreen({Key? key}) : super(key: key);

  @override
  State<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends State<GoogleLoginScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      GoogleLoginProvider googleLoginProvider =
          Provider.of(context, listen: false);
      googleLoginProvider.isCircular = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    VariableUtilities.screenSize = MediaQuery.of(context).size;
    return Consumer<GoogleLoginProvider>(
        builder: (_, GoogleLoginProvider googleLoginProvider, __) {
      return Scaffold(
          body: Container(
        color: ColorUtils.whiteColor,
        height: VariableUtilities.screenSize.height,
        width: VariableUtilities.screenSize.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CustomImageView(
                            imageUrl: AssetUtilities.newsAppLogo,
                            height: 200,
                          ),
                        ]),
                  ),
                  PrimaryButton(
                      onTap: () {
                        googleLoginProvider.signInWithGoogle(context);
                      },
                      title: 'Continue With Google',
                      color: ColorUtils.blackColor,
                      titleColor: ColorUtils.whiteColor,
                      suffixIcon: const CustomImageView(
                        imageUrl: AssetUtilities.googleLogo,
                        height: 20,
                      )),
                  const SizedBox(height: 30)
                ],
              ),
            ),
            googleLoginProvider.isCircular
                ? const CustomCircularProgress()
                : const SizedBox()
          ],
        ),
      ));
    });
  }
}
