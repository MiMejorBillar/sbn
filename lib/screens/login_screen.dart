import 'package:flutter/material.dart';
import '../auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  final AuthService _authService = AuthService();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
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
                  if(value == null || value.isEmpty) {
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
                    icon: Icon( _passwordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  )
                ),
                obscureText: !_passwordVisible,
                autofillHints: [AutofillHints.password],
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              if(_isLoading)
                CircularProgressIndicator()
              else
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => _handleLogin(),
                      child: Text('Login'),
                    ),
                    ElevatedButton(
                      onPressed: () => _handleSignUp() ,
                      child: Text('Sign Up'),
                    ),
                  ],
                ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top:20),
                  child: Text(
                    _errorMessage!,
                    style : TextStyle(color: Colors.red),
                  )
                )
            ],
          ),
        )
      )
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      try {
        await _authService.logIn(
          _emailController.text,
          _passwordController.text,
        );
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
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
        await Supabase.instance.client.from('users').insert({
          'id' : response.user!.id,
          'email': _emailController.text,
          'first_name': 'User',
          'last_name' : '',
          'is_local' : false,
          'created_at' : DateTime.now().toIso8601String(),
        });
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e){
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
    if (error is AuthException){
      switch (error.message) {
        case 'Invalid login credentials':
          return 'Invalid email or password. Please try again';
        case 'User already registered':
          return 'This email is already registered. Please log in instead.';
        default:
          return 'An error occurred. Please try again later.';
      }
    } else{
      return 'Something went wrong. Please check your connection and try again.';
    }
  }

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}