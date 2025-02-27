import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:todo_me/assets/assets_manager.dart';
import 'package:todo_me/core/theme/app_colors.dart';

import '../../../../app/routers/router_manager.dart';
import '../../../../app/service_locator.dart';
import '../../../auth/application/bloc/auth_bloc.dart';

class HomeCustomDrawer extends StatelessWidget {
  const HomeCustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width * .55,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          DrawerHeader(child: Image.asset(AssetsManager.astronautManPng)),
          Text(
            'Hi, ${FirebaseAuth.instance.currentUser?.displayName??'Google User'}',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.mainTextColor,
            ),
          ),
          const Divider(),
          ListTile(
            leading: Image.asset(
              AssetsManager.signalPng,
              width: 30,
              height: 30,
            ),
            title: const Text('Status'),
            trailing: StreamBuilder<InternetStatus>(
              stream: InternetConnection().onStatusChange,
              builder: (context, snapshot) {
                return Text(
                  snapshot.data == InternetStatus.connected ? 'online' : 'offline'
                  ,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color:snapshot.data == InternetStatus.connected ? AppColors.customGreenColor :Colors.red
                  ),
                );
              }
            ),
            onTap: () {},
            
          ),
         
          Spacer(),

          ColoredBox(
            color: Colors.redAccent.withAlpha((255*.25).toInt()),
            child: ListTile(
              leading: Image.asset(
                AssetsManager.logoutPng,
                width: 30,
                height: 30,
              ),
              title: const Text('Logout'),
              onTap: () {
              ServiceLocator.I.getIt<AuthBloc>().add(AuthSignOutEvent(
                (state){
                  //Todo crate best practice to clear all data if  user logout
                  // this is bad practice but time is limited
                  
                  Navigator.of(context).pushReplacementNamed(
                    ServiceLocator.I.getIt<RouterManager>().login,
                  );
                }
              ));
              
              },
            ),
          ),

SizedBox(height: 40,),
        ],
      ),
    );
  }
}
