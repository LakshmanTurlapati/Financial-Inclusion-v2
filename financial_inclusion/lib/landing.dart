import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final CognitoUserPool _userPool = CognitoUserPool(
    'us-west-2_uI4aGzwR4',
    '51r7jkaqdvbq9hrh9068jcr5i7',


  );

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showSnackBar('Please enter both username and password.');
      return;
    }

    setState(() => _isLoading = true);

    final cognitoUser = CognitoUser(username, _userPool);
    final authDetails = AuthenticationDetails(
      username: username,
      password: password,
    );

    try {
      final session = await cognitoUser.authenticateUser(authDetails);

      // session can be null, so we check it carefully:
      if (session != null && session.isValid()) {
        _showSnackBar('Sign in successful!');
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        _showSnackBar('Sign in failed. Invalid session or null session.');
      }
    } on CognitoUserException catch (e) {
      // Common for "User not confirmed" or "Incorrect username/password."
      _showSnackBar('Sign in failed: ${e.message}');
    } catch (e) {
      // Handle any other exceptions
      _showSnackBar('An unknown error occurred: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In - Cognito'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sign In',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                // Username
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),

                // Password
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Sign In Button or Loader
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _signIn,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text('Sign In'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
