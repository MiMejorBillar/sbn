import 'package:flutter/material.dart';
import '../auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  final AuthService _authService = AuthService();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                autofillHints: [AutofillHints.email],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(_passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_passwordVisible,
                autofillHints: [AutofillHints.password],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              SizedBox(height: 20),
              if (_isLoading)
                CircularProgressIndicator()
              else
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: _handleSignUp,
                      child: Text('Sign Up'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text('Already have an account? Login'),
                    ),
                  ],
                ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      try {
        final response = await _authService.signUp(
          _emailController.text,
          _passwordController.text,
        );
        if (response.user == null) {
          throw Exception('Sign-up failed: No user returned');
        }
        // Log the user ID to verify
        print('Signed-up user ID: ${response.user!.id}');
        // Verify the session is active
        final currentUser = Supabase.instance.client.auth.currentUser;
        if (currentUser == null) {
          throw Exception('No active session after sign-up');
        }
        print('Current user ID: ${currentUser.id}');
        // Add a small delay to ensure the session is set
        await Future.delayed(Duration(milliseconds: 500));
        // Insert the user into the public.users table
        try {
          final insertResponse =
              await Supabase.instance.client.from('users').insert({
            'id': response.user!.id,
            'email': _emailController.text,
            'first_name': _firstNameController.text,
            'last_name': _lastNameController.text ?? '',
            'is_local': false,
            'created_at': DateTime.now().toIso8601String(),
          });
          print('Insert response: $insertResponse');
        } catch (insertError) {
          print('Insert error: $insertError');
          throw Exception('Failed to create user profile: $insertError');
        }
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        print('General error: $e');
        setState(() {
          _errorMessage = _getFriendlyErrorMessage(e);
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getFriendlyErrorMessage(dynamic error) {
    if (error is AuthException) {
      switch (error.message) {
        case 'Invalid login credentials':
          return 'Invalid email or password. Please try again';
        case 'User already registered':
          return 'This email is already registered. Please log in instead.';
        default:
          return 'An error occurred. Please try again later.';
      }
    } else {
      return 'Something went wrong. Please check your connection and try again.';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
