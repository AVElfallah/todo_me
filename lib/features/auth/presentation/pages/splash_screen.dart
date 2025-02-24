import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_me/app/service_locator.dart';

import '../../../../app/routers/router_manager.dart';
import '../../../../assets/assets_manager.dart';
import '../../../../core/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,

            child: Center(
              child: Image.asset(
                height: height * .4,
                AssetsManager.astronautManPng,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Text(
              'Welcome In ToDoMe',
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: AppColors.mainTextColor,
              ),
            ),
          ),
          SizedBox(
            height: height * .05,
          ),
          Flexible(
            flex: 1,
            child: Text(
              'keep it simple , do it faster',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.secondaryTextColor,
              ),
            ),
          ),
          Spacer(),
          Flexible(
            flex: 1,
            child: SizedBox(
              width: width * .8,
              child: ElevatedButton(
                onPressed: () {
                  // Navigator to navigate to login screen
                  Navigator.of(context).pushReplacementNamed(
                    ServiceLocator.I.getIt<RouterManager>().login,
                  );
                },

                child: Text('Get Started'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
