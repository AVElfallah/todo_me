import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_me/app/service_locator.dart';
import 'package:todo_me/app/common/loading_overly.dart';
import 'package:todo_me/features/auth/application/bloc/auth_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../app/routers/router_manager.dart';
import '../../../../assets/assets_manager.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // vars
  late final GlobalKey<FormState> _formKey;
  late final ValueNotifier<bool> _obscureText;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _obscureText = ValueNotifier(true);
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                // name validator function
                return Validators.name(value).fold((l) => null, (r) => r);
              },
              decoration: const InputDecoration(hintText: 'Full Name'),
            ),
            const SizedBox(height: 20),

            // email
            TextFormField(
              controller: _emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                // email validator function
                return Validators.email(value).fold((l) => null, (r) => r);
              },
              decoration: const InputDecoration(hintText: 'Email Address'),
            ),
            const SizedBox(height: 20),

            /// password
            ValueListenableBuilder(
              // listenable builder to change password state
              valueListenable: _obscureText,
              builder:
                  (_, obTextVal, __) => TextFormField(
                    controller: _passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      // validate password
                      return Validators.password(
                        value,
                      ).fold((l) => null, (r) => r);
                    },
                    obscureText: obTextVal,

                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          // toggle password obscure hide or show
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
                /// Shows a loading overlay and attempts to validate the form.
                /// If the form is valid, it triggers the `AuthSignUpEvent` with the provided
                /// email, password, and name. Upon completion, hides the loading overlay.
                /// If the registration is successful, navigates to the home screen.

                // Validate the form
                if (_formKey.currentState!.validate()) {
                  // Show loading overlay
                  LoadingOverlay().show(context);
                  // Trigger the AuthSignUpEvent with email, password, and name
                  ServiceLocator.I.getIt<AuthBloc>().add(
                    AuthSignUpEvent(
                      _emailController.text,
                      _passwordController.text,
                      _nameController.text,
                      onCompleted: (p0) {
                        // Hide loading overlay
                        LoadingOverlay().hide();

                        // If registration is successful, navigate to home screen
                        if (p0 is AuthRegisterSuccessState) {
                          Navigator.of(context).pushReplacementNamed(
                            ServiceLocator.I.getIt<RouterManager>().home,
                          );
                        } else {
                          // Show error snackbar if registration fails
                          showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.error(
                              message:
                                  "Something went wrong\nError on Registering",
                            ),
                          );
                        }
                      },
                    ),
                  );
                } else {
                  // hide loader
                  LoadingOverlay().hide();
                  // Show error snackbar if form is invalid
                  showTopSnackBar(
                    Overlay.of(context),
                    CustomSnackBar.error(
                      message:
                          "Please fill the information\nError on Registering",
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
                    // Show loading overlay
                    LoadingOverlay().show(context);
                    // Trigger the AuthSignUpWithGoogleEvent
                    ServiceLocator.I.getIt<AuthBloc>().add(
                    AuthSignUpWithGoogleEvent((state) {
                      // Hide loading overlay
                      LoadingOverlay().hide();
                      // If registration is successful, navigate to home screen
                      if (state is AuthRegisterSuccessState) {
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
