import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_me/app/service_locator.dart';
import 'package:todo_me/app/common/loading_overly.dart';
import 'package:todo_me/features/auth/application/bloc/auth_bloc.dart';

import '../../../../app/routers/router_manager.dart';
import '../../../../assets/assets_manager.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // vars
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final ValueNotifier<bool> _obscureText = ValueNotifier(true);
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _nameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        leading: SizedBox.shrink(),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
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
            // name
            TextFormField(
              controller: _nameController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                return Validators.name(value)
                    .fold((l) => null, (r) => r);
              },
              decoration: const InputDecoration(hintText: 'Full Name'),
            ),
            const SizedBox(height: 20),

            // email
            TextFormField(
              controller: _emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                return Validators.email(value)
                    .fold((l) => null, (r) => r);
              },
              decoration: const InputDecoration(hintText: 'Email Address'),
            ),
            const SizedBox(height: 20),

            /// password
            ValueListenableBuilder(
              valueListenable: _obscureText,
              builder:
                  (_, obTextVal, __) => TextFormField(
                    controller: _passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return Validators.password(value)
                          .fold((l) => null, (r) => r);
                    },
                    obscureText: obTextVal,

                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          _obscureText.value = !_obscureText.value;
                        },
                        icon: Icon(
                          !_obscureText.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ServiceLocator.I.getIt<AuthBloc>().add(
                    AuthSignUpEvent(
                      _emailController.text,
                      _passwordController.text,
                      _nameController.text,
                      onCompleted: (p0) {
                        LoadingOverlay().show(context);
                        if (p0 is AuthRegisterSuccessState){
                          LoadingOverlay().hide();
                        Navigator.of(context).pushReplacementNamed(
                          ServiceLocator.I.getIt<RouterManager>().home,
                        );}
                      },
                    ),
                  );
                }
              },
              child: const Text('Register'),
            ),
            const SizedBox(height: 40),
            Center(child: Text('or Signup with')),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  ServiceLocator.I.getIt<AuthBloc>().add(
                    AuthSignUpWithGoogleEvent((state) {
                      LoadingOverlay().show(context);
                      if (state is AuthRegisterSuccessState) {
                        LoadingOverlay().hide();
                        Navigator.of(context).pushReplacementNamed(
                          ServiceLocator.I.getIt<RouterManager>().home,
                        );
                      }
                    }),
                  );
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
      ),
    );
  }
}
