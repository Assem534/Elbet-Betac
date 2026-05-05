import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../Widget/buildField.dart';
import '../Widget/buildSocialButton.dart';

class LoginFormPage extends StatefulWidget {
  @override
  _LoginFormPageState createState() => _LoginFormPageState();
}

class _LoginFormPageState extends State<LoginFormPage> {
  bool isHidden = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password.')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(email, password);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, '/Home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Login failed.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double scale = (width / 375).clamp(0.85, 1.3);
    double r(double size) => size * scale;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: height * 0.18,
              child: Image.asset(
                'assets/images/undraw_city_life_gnpr1.png',
                fit: BoxFit.contain,
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(r(20)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(r(25)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign In',
                    style: TextStyle(
                        fontSize: r(24), fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: r(10)),
                  Text(
                    "Welcome back, you've been missed!",
                    style: TextStyle(color: Colors.grey, fontSize: r(16)),
                  ),
                  SizedBox(height: r(25)),

                  // Email
                  buildField(
                    r,
                    hint: 'Email',
                    prefixIcon: Icons.person_outline,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: r(15)),

                  // Password
                  TextField(
                    controller: _passwordController,
                    obscureText: isHidden,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: r(16), horizontal: r(12)),
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock, size: r(20)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: r(20),
                        ),
                        onPressed: () =>
                            setState(() => isHidden = !isHidden),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(r(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: r(10)),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot password?',
                      style:
                      TextStyle(color: Colors.grey, fontSize: r(13)),
                    ),
                  ),
                  SizedBox(height: r(20)),

                  // Sign In Button
                  ElevatedButton(
                    onPressed:
                    authProvider.isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, r(50)),
                      backgroundColor: const Color(0xFF8BC83F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(r(12)),
                      ),
                    ),
                    child: authProvider.isLoading
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                        : Text(
                      'Sign In',
                      style: TextStyle(
                          color: Colors.white, fontSize: r(16)),
                    ),
                  ),

                  SizedBox(height: r(25)),

                  Row(
                    children: [
                      Expanded(
                          child: Divider(color: Colors.grey, thickness: 1.5)),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: r(10)),
                        child: Text('or',
                            style: TextStyle(
                                color: Colors.grey, fontSize: r(14))),
                      ),
                      Expanded(
                          child: Divider(color: Colors.grey, thickness: 1.5)),
                    ],
                  ),
                  SizedBox(height: r(15)),

                  Row(
                    children: [
                      buildSocialButton('assets/images/google.png', r),
                      SizedBox(width: r(10)),
                      buildSocialButton('assets/images/facebook.png', r),
                    ],
                  ),
                  SizedBox(height: r(15)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ",
                          style: TextStyle(fontSize: r(14))),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/Register'),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: r(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}