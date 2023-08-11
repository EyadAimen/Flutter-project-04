// this shows a loading spinner
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todo/pages%20from%20the%20drawer/change_theme_screen.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ChangeThemeScreen.isDarkTheme? Colors.black : Colors.white,
      child: Center(
        child: SpinKitDualRing(
          color: ChangeThemeScreen.isDarkTheme? Colors.white : Colors.blue,
          size: 50,
          ),
      ),
    );
  }
}