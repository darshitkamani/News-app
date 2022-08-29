import 'package:flutter/material.dart';

///CutomCircularProgress
class CustomCircularProgress extends StatelessWidget {
  ///CustomCircularProgress
  const CustomCircularProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(
              color: Colors.black,
            ),
            SizedBox(height: 10),
            Text(
              'Loading...',
              style: TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
