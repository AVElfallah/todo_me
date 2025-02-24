
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_me/app/service_locator.dart';
import 'package:todo_me/assets/assets_manager.dart';
import 'package:todo_me/core/theme/app_colors.dart';

import '../../../../app/routers/router_manager.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        leading: SizedBox.shrink(),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),
          Text(
            'Welcome Back',
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: AppColors.mainTextColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Please Inter your email address\nand password for Login',
            textAlign: TextAlign.justify,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 40),
          TextFormField(
            decoration: const InputDecoration(hintText: 'Email Address'),
          ),
          const SizedBox(height: 40),
          TextFormField(
            decoration: const InputDecoration(hintText: 'Password'),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement Login Logic
            },
            child: const Text('Sign In'),
          ),
          const SizedBox(height: 40),
          Center(child: Text('or Signin with')),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                // TODO: Implement Google SignIn
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.secondaryTextColor),
                ),
                padding: const EdgeInsets.all(20),
                width: 80,
                child: SvgPicture.asset(AssetsManager.googleIconSVG),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Not Registrar Yet? ',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    ServiceLocator.I.getIt<RouterManager>().register,
                  );
                },
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mainTextColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
