import 'package:flutter/material.dart';
import 'package:greenhouse/models/signup.dart';
import 'package:greenhouse/screens/menu/login.dart';
import 'package:greenhouse/services/auth_service.dart';
import 'package:greenhouse/widgets/navigation_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscureText = true;
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _tinController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _termsAccepted = false;
  final AuthService _authService = AuthService();

  void _signUp() async {
    if (_termsAccepted) {
      final signUp = SignUp(
        businessName: _businessNameController.text,
        tin: _tinController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text,
        password: _passwordController.text,
      );

      try {
        String businessName = await _authService.signUp(signUp);
        // Navigate to the login screen after successful signup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Successfully signed up and created company: $businessName')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign up: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please accept the terms and conditions')),
      );
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
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Stack(children: [
                    Positioned(
                        top: 80, right: 50, left: 50, child: _buildTop()),
                    Positioned(bottom: 0, child: _buildBottom(context)),
                  ]),
                ))));
  }

  Widget _buildTop() {
    return Center(
        child: SvgPicture.asset(
      'assets/logo/logo_white.svg',
      width: 200,
      height: 200,
    ));
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
        child: _signUpForm(context),
      ),
    );
  }

  Widget _signUpForm(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          _loginSignUpButton(context),
          SizedBox(height: 20),
          _inputField("Business Name", Icons.business, _businessNameController),
          SizedBox(height: 15),
          _inputField("TIN", Icons.business, _tinController),
          SizedBox(height: 15),
          _inputField("First name of the registrant", Icons.person,
              _firstNameController),
          SizedBox(height: 15),
          _inputField(
              "Last name of the registrant", Icons.person, _lastNameController),
          SizedBox(height: 15),
          _inputField("Username", Icons.person, _usernameController),
          SizedBox(height: 15),
          _inputField("Password", Icons.lock, _passwordController),
          SizedBox(height: 10),
          _termsAndConditions(),
          SizedBox(height: 10),
          NavigationButton(
              buttonText: "Sign up", route: '/login', onPressed: _signUp),
        ],
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
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text("LOG IN",
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
            SizedBox(height: 5),
            Container(
              width: containerWidth,
              margin: EdgeInsets.only(left: 10),
              height: 2,
              color: Colors.grey,
            ),
          ],
        ),
        Column(
          children: [
            TextButton(
              onPressed: () {},
              child: Text("SIGN UP",
                  style: TextStyle(
                      color: Color(0xFF7DA257),
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 5),
            Container(
              width: containerWidth,
              margin: EdgeInsets.only(right: 10),
              height: 2,
              color: Color(0xFF7DA257),
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

  Widget _termsAndConditions() {
    return Row(
      children: [
        Checkbox(
          value: _termsAccepted,
          onChanged: (value) {
            setState(() {
              _termsAccepted = value!;
            });
          },
        ),
        Text.rich(
          TextSpan(
            text: "I've read and accept the ",
            style: TextStyle(fontSize: 12),
            children: [
              TextSpan(
                text: "Terms and \n Conditions",
                style: TextStyle(color: Color(0xFF67864A)),
              ),
              TextSpan(text: " and "),
              TextSpan(
                text: "Privacy Policy",
                style: TextStyle(color: Color(0xFF67864A)),
              ),
            ],
          ),
        )
      ],
    );
  }
}
