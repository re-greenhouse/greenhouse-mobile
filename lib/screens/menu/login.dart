import 'package:flutter/material.dart';
import 'package:greenhouse/screens/menu/sign_up.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenhouse/widgets/navigation_button.dart';
import 'package:greenhouse/services/auth_service.dart';
import 'package:greenhouse/models/signin.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    if (username.isNotEmpty && password.isNotEmpty) {
      try {
        String profileId = await _authService
            .signIn(SignIn(username: username, password: password));
        Navigator.pushNamedAndRemoveUntil(
            context, '/dashboard', (route) => false);
      } catch (e) {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to sign in: $e'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter both username and password'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/mushroom_images/champis.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black12,
                Colors.black87,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 80,
                right: 50,
                left: 50,
                child: _buildTop(),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildBottom(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTop() {
    return Center(
      child: SvgPicture.asset(
        'assets/logo/logo_white.svg',
        width: 200,
        height: 200,
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          color: Colors.white,
        ),
        padding: const EdgeInsets.only(
          left: 32,
          right: 32,
          bottom: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 32),
            _loginSignUpButton(context),
            SizedBox(height: 20),
            _inputField("Username", Icons.person, _usernameController),
            SizedBox(height: 20),
            _inputField("Password", Icons.lock, _passwordController),
            SizedBox(height: 315),
            NavigationButton(
              buttonText: "Login",
              route: '/dashboard',
              onPressed: _login,
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginSignUpButton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = (screenWidth - 100) / 2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            TextButton(
              onPressed: () {},
              child: Text("LOG IN",
                  style: TextStyle(
                      color: Color(0xFF7DA257),
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 5),
            Container(
              width: containerWidth,
              margin: EdgeInsets.only(left: 10),
              height: 2,
              color: Color(0xFF7DA257),
            ),
          ],
        ),
        Column(
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              child: Text("SIGN UP",
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
            SizedBox(height: 5),
            Container(
              width: containerWidth,
              margin: EdgeInsets.only(right: 10),
              height: 2,
              color: Colors.grey,
            ),
          ],
        ),
      ],
    );
  }

  Widget _inputField(
      String hintText, IconData icon, TextEditingController controller) {
    bool isPassword = hintText == "Password";

    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscureText : false,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(color: Color(0xFF727272), fontSize: 14),
        hintText: 'Enter $hintText',
        hintStyle: TextStyle(color: Color(0xFF727272), fontSize: 14),
        fillColor: Color(0xFFECECEC),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF67864A)),
        ),
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
    );
  }
}
