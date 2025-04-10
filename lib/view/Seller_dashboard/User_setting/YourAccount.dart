import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Logout.dart';
// import '../../login/start_login.dart';
import 'FrequentlyAskedQuestions.dart';
import 'HelpDesk.dart';
import 'ManageAccounts.dart';
import 'MyAdresses.dart';
import 'Profile.dart';
import 'Settings.dart';

class YourAccount extends StatefulWidget {
  const YourAccount({super.key});

  @override
  State<YourAccount> createState() => _ManageYourAccountState();
}

class _ManageYourAccountState extends State<YourAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Color(0xFF605F5F),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Account",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Urbanist",
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50), // Space below title
            Container(
              decoration: BoxDecoration(
                  color: Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFD9D9D9), width: 1)),
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.person_outline,
                    title: "Profile",
                    subtitle: "",
                    navigateTo: Profile(),
                    context: context
                  ),
                  const Divider(
                    height: 1,
                  ),
                  _buildListTile(
                    icon: Icons.headset_mic_outlined,
                    title: "Help Desk",
                    subtitle: "Connect with us",
                    navigateTo: HelpDesk(),
                    context: context,
                  ),
                  const Divider(
                    height: 1,
                  ),
                  _buildListTile(
                    icon: Icons.location_on_outlined,
                    title: "My Addresses",
                    subtitle: "Add or edit your addresses",
                    navigateTo: AddressScreen(),
                    context: context,
                  ),
                  const Divider(
                    height: 1,
                  ),
                  _buildListTile(
                    icon: Icons.manage_accounts_outlined,
                    title: "Manage Accounts",
                    subtitle: "Your account and saved addresses",
                    navigateTo: ManageAccountScreen(),
                    context: context,
                  ),
                  const Divider(
                    height: 1,
                  ),
                  _buildListTile(
                    icon: Icons.help_outline,
                    title: "FAQs",
                    subtitle: "Frequently Asked Questions",
                    navigateTo: Frequentlyaskedquestions(),
                      context: context,
                  ),
                  const Divider(
                    height: 1,
                  ),
                  _buildListTile(
                    icon: Icons.settings_outlined,
                    title: "Settings",
                    subtitle: "Get notifications",
                    navigateTo: SettingsScreen(),
                    context: context,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                height: 50,
                width: MediaQuery.sizeOf(context).width,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Colors.red,
                          width: 1), // Border color & thickness
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(5), // Rounded corners
                      ),
                    ),
                    onPressed: () {
                      logoutUser(context);
                    },
                    child: const Text(
                      "Log out",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget navigateTo, // Added parameter
    required BuildContext context, // Needed for navigation
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontFamily: "Urbanist",
        ),
      ),
      subtitle: subtitle.isNotEmpty
          ? Text(subtitle,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: "Urbanist",
          ))
          : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => navigateTo),
        );
      },
    );
  }

}
