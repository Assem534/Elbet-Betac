import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';
import '../Widget/buildField.dart';
import '../Widget/buildSocialButton.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isHidden = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success =
    await authProvider.register(name, email, password);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, '/Home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text(authProvider.errorMessage ?? 'Registration failed.'),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(r(16)),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: r(45),
                  height: r(45),
                  decoration: BoxDecoration(
                    color: const Color(0xffF0F1F6),
                    borderRadius: BorderRadius.circular(r(12)),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_ios_new, size: r(16)),
                  ),
                ),
                SizedBox(height: r(20)),

                Text(
                  'Create your account',
                  style: TextStyle(
                      fontSize: r(22), fontWeight: FontWeight.bold),
                ),
                SizedBox(height: r(8)),
                Text(
                  'Join us and find your perfect property.',
                  style: TextStyle(color: Colors.grey, fontSize: r(13)),
                ),
                SizedBox(height: r(20)),

                buildField(
                  r,
                  hint: 'Enter your name',
                  prefixIcon: Icons.person_outline,
                  controller: _nameController,
                ),
                SizedBox(height: height * 0.02),

                buildField(
                  r,
                  hint: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: r(12)),

                TextField(
                  controller: _passwordController,
                  obscureText: isHidden,
                  decoration: InputDecoration(
                    fillColor: const Color(0xffF0F1F6),
                    filled: true,
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
                    hintText: 'Enter password',
                    hintStyle: TextStyle(fontSize: r(13)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(r(12)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: r(12)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Terms of service',
                        style:
                        TextStyle(color: Colors.grey, fontSize: r(12))),
                    Text('Help password',
                        style:
                        TextStyle(color: Colors.grey, fontSize: r(12))),
                  ],
                ),
                SizedBox(height: r(20)),

                SizedBox(
                  width: double.infinity,
                  height: r(50),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8BC83F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(r(12)),
                      ),
                    ),
                    onPressed: authProvider.isLoading
                        ? null
                        : _handleRegister,
                    child: authProvider.isLoading
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                        : Text(
                      'Register',
                      style: TextStyle(
                          fontSize: r(16), color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: r(25)),

                Row(
                  children: [
                    Expanded(
                        child:
                        Divider(color: Colors.grey, thickness: 1.5)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: r(10)),
                      child: Text('or',
                          style: TextStyle(
                              color: Colors.grey, fontSize: r(14))),
                    ),
                    Expanded(
                        child:
                        Divider(color: Colors.grey, thickness: 1.5)),
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
                    Text('Already have account? ',
                        style: TextStyle(fontSize: r(14))),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/Login'),
                      child: Text(
                        'Login',
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
        ),
      ),
    );
  }
}