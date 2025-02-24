import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_me/app/service_locator.dart';

import '../../../../app/routers/router_manager.dart';
import '../../../../assets/assets_manager.dart';
import '../../../../core/theme/app_colors.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
            'Create Account',
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: AppColors.mainTextColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Please Inter your Information and\ncreate your account',
            textAlign: TextAlign.justify,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 40),
          TextFormField(
            decoration: const InputDecoration(hintText: 'Full Name'),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(hintText: 'Email Address'),
          ),
          const SizedBox(height: 20),
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
                'Have an Account? ',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.secondaryTextColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  // replace current page with LoginScreen
                 Navigator.of(context).pushReplacementNamed(
                  ServiceLocator.I.getIt<RouterManager>().login,

                 );
                },
                child: Text(
                  'Sign In',
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
