import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_me/assets/assets_manager.dart';
import 'package:todo_me/core/theme/app_colors.dart';

class HomeCustomDrawer extends StatelessWidget {
  const HomeCustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO - this widget needs [user name] and [Connection Status]
    //TODO - this widget needs [logout function], [tasks completed] and [tasks count] 
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width * .55,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          DrawerHeader(child: Image.asset(AssetsManager.astronautManPng)),
          Text(
            'Hi, Abdulrahman',
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
            trailing: Text(
              'online',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.customGreenColor,
              ),
            ),
            onTap: () {},
            
          ),
          ListTile(
            leading: Image.asset(
              AssetsManager.abacusPng,
              width: 30,
              height: 30,
            ),
            title: const Text('All Tasks'),
            trailing: Text(
              '10',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.mainTextColor,
              ),
            ),

            onTap: () {},
          ),
          ListTile(
            leading: Image.asset(
              AssetsManager.checkPng,
              width: 30,
              height: 30,
            ),
            title: const Text('Completed Tasks'),
            trailing: Text(
              '5',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColors.customGreenColor,
              ),
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
                //TODO - implement logout
              },
            ),
          ),

SizedBox(height: 40,),
        ],
      ),
    );
  }
}
