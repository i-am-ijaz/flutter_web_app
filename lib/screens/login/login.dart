import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pulsator/pulsator.dart';

class LoginScreen extends StatelessWidget {
  // TODO: Modify this screen to be more clearly
  // TODO: Modify, to show only email field, and if the user exists, then we show email
  // TODO: Create a screen to see all projects by invited user
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Film Planner',
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: Utils.getGradientBoxDecoration(),
            child: Center(
              child: _buildLoginContainer(),
            ),
          ),
          floatingActionButton: const PulseIcon(
            icon: Icons.message,
            pulseColor: ThemeColors.primaryColor,
            iconColor: ThemeColors.iconColor,
            iconSize: 32,
            innerSize: 34,
            pulseSize: 100,
            pulseCount: 4,
            pulseDuration: Duration(seconds: 4),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginContainer() {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(16),
      decoration: Utils.formContainer(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Text(TextString.loginText, style: CustomTextStyles.mainlogintext),
          const SizedBox(height: 20),
          _buildTextFieldWithIcon(
            TextString.emailtopText,
            Icons.email,
            TextString.emailText,
          ),
          const SizedBox(height: 20),
          _buildTextFieldWithIcon(
            TextString.passwordtopText,
            Icons.lock,
            TextString.passwordText,
            obscureText: true,
          ),
          const SizedBox(height: 20),
          _buildLoginButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithIcon(
      String labelText, IconData icon, String hintText,
      {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: CustomTextStyles.emailAndPasswordtext),
        const SizedBox(height: 10),
        TextFieldWithIcon(
          hintText: hintText,
          icon: icon,
          obscureText: obscureText,
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: 45,
        alignment: Alignment.center,
        decoration: Utils.loginButton(),
        child: Text(
          TextString.loginText,
          style: CustomTextStyles.loginButtonText,
        ),
      ),
    );
  }
}

class TextString {
  static const String loginText = 'LOGIN';
  static const String emailText = 'email@gmail.com';
  static const String passwordText = '*******';
  static const String emailtopText = 'Email';
  static const String passwordtopText = 'Password';
}

class CustomTextStyles {
  static TextStyle loginButtonText = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static TextStyle emailAndPasswordtext = GoogleFonts.inter(
      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600);
  static TextStyle mainlogintext = GoogleFonts.inter(
      color: Colors.white, fontSize: 36, fontWeight: FontWeight.w600);
}

class TextFieldWithIcon extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final Color iconColor;
  final Color textColor;
  final Function(String) onChanged;

  const TextFieldWithIcon({
    super.key,
    required this.hintText,
    required this.icon,
    required this.onChanged,
    this.obscureText = false,
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      style: TextStyle(color: textColor),
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          color: ThemeColors.hinttextColor,
          fontSize: 15,
        ),
        prefixIcon: Icon(icon, color: iconColor),
        contentPadding: const EdgeInsets.only(
          top: 5,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ThemeColors.primaryColor),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ThemeColors.primaryColor),
        ),
      ),
    );
  }
}

class ThemeColors {
  static const primaryColor = Color(0xFF2365e8);
  static const backgroundColor1 = Color(0xFF01050e);
  static const backgroundColor2 = Color(0xFF010e1b);
  static const backgroundColor3 = Color(0xFF020710);
  static const loginContainerColor = Color(0xFF01050b);
  static const loginBoxColor = Color(0xFF153b84);
  static const iconColor = Color(0xFFFFFFFF);
  static const hinttextColor = Color(0xFFcccccc);
}

class Utils {
  static BoxDecoration getGradientBoxDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          ThemeColors.backgroundColor1,
          ThemeColors.backgroundColor2,
          ThemeColors.backgroundColor3,
        ],
      ),
    );
  }

  static BoxDecoration loginButton() {
    return BoxDecoration(
      color: ThemeColors.primaryColor,
      borderRadius: BorderRadius.circular(5),
    );
  }

  static BoxDecoration formContainer() {
    return BoxDecoration(
      color: ThemeColors.loginContainerColor,
      border: Border.all(
        color: ThemeColors.loginBoxColor,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(5),
    );
  }
}
