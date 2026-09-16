import 'package:bill_splitter/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';

import '../screens/Home.dart';
import '../screens/groups/groups.dart';
import '../screens/invitation/invite_list.dart';
import '../services/auth.dart';
import 'confirmation_dialog.dart';
class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 120,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            decoration: const BoxDecoration(
              color: Color(0xFF0D0D0D),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white12,
                ),
              ),
            ),
            child: const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Bill Splitter",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 2,
            ),
            leading: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.home_outlined,
                color: Colors.amber,
                size: 20,
              ),
            ),
            title: const Text(
              "Home",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.white30,
              size: 20,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
                    (route) => false,
              );
            },
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 2,
            ),
            leading: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.group,
                color: Colors.amber,
                size: 20,
              ),
            ),
            title: const Text(
              "Groups",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.white30,
              size: 20,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Groups(),
                ),
              );
            },
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 2,
            ),
            leading: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mail_outlined,
                color: Colors.amber,
                size: 20,
              ),
            ),
            title: const Text(
              "Invites",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.white30,
              size: 20,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InviteList(),
                ),
              );
            },
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 2,
            ),
            leading: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.amber,
                size: 20,
              ),
            ),
            title: const Text(
              "Edit Profile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.white30,
              size: 20,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> EditProfileScreen()));
            },
          ),

          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Divider(
              color: Colors.white12,
              height: 1,
            ),
          ),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 2,
            ),
            leading: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout,
                color: Colors.redAccent,
                size: 20,
              ),
            ),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () async {
              Navigator.pop(context);
              ConfirmationDialog().showConfirmationDialog(
                context,
                "Logout?",
                "Are you sure you want to logout",
                "Cancel",
                "Logout",
                    () => AuthService().signOut(),
                Icons.logout,
              );
            },
          ),
        ],
      ),
    );
  }
}
