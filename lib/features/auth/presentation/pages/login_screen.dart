
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_me/app/service_locator.dart';
import 'package:todo_me/assets/assets_manager.dart';
import 'package:todo_me/core/theme/app_colors.dart';
import 'package:todo_me/app/common/loading_overly.dart';
import 'package:todo_me/core/utils/validators.dart';
import 'package:todo_me/features/auth/application/bloc/auth_bloc.dart';

import '../../../../app/routers/router_manager.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});


  @override
  Widget build(BuildContext context) {
    // vars
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
      final ValueNotifier<bool> _obscureText = ValueNotifier(true);
      final TextEditingController _emailController = TextEditingController();
      final TextEditingController _passwordController = TextEditingController();

    return BlocConsumer<AuthBloc, AuthState>(
   
      listener: (context, state) {
        
      },
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Sign In'),
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

                // email section
                TextFormField(
                  controller: _emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return Validators.email(value).fold((l) => null, (r) => r);
                  },
                  decoration: const InputDecoration(hintText: 'Email Address'),
                ),
                const SizedBox(height: 40),
                // password section

                ValueListenableBuilder(
                  valueListenable: _obscureText,
                  builder: (_, obTextVal, _) =>  TextFormField(
                    controller: _passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return Validators.password(value).fold((l) => null, (r) => r);
                    },
                    obscureText: obTextVal,
                    decoration: InputDecoration(hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(!obTextVal ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => _obscureText.value = !_obscureText.value,
                      color: AppColors.secondaryTextColor,
                    ),
                    
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    LoadingOverlay().show(context);
                    if (_formKey.currentState!.validate()) {
                      ServiceLocator.I.getIt<AuthBloc>().add(AuthLoginEvent(
                        _emailController.text,
                        _passwordController.text,
                        onCompleted: (p0) {
                          if (p0 is AuthLoginSuccessState) {
                            Navigator.of(context).pushReplacementNamed(
                              ServiceLocator.I.getIt<RouterManager>().home
                            );
                          }
                          LoadingOverlay().hide();
                        },
                      ));
                    }
                    else {
                      LoadingOverlay().hide();
                    }
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
                      LoadingOverlay().show(context);
                      ServiceLocator.I.getIt<AuthBloc>().add(AuthLoginWithGoogleEvent(
                        (state){
                            if (state is AuthLoginSuccessState) {
                          LoadingOverlay().hide();
                          Navigator.of(context).pushReplacementNamed(
ServiceLocator.I.getIt<RouterManager>().home
                          );
                        }
                        }
                      ));
                      
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.secondaryTextColor),
                      ),
                      padding: const EdgeInsets.all(20),
                      width: 70,
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
          ),
        );
      }
    );
  }
}
