import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService{
  final supabase = Supabase.instance.client;

  Future<AuthResponse> logIn(String email, String password) async {
    return await supabase.auth.signInWithPassword(email: email ,password: password);
  }

  Future<AuthResponse> signUp(String email, String password) async {
    return await supabase.auth.signUp(email:email, password: password);
  }

  Future<void> logOut() async {
    await supabase.auth.signOut();
  }
}