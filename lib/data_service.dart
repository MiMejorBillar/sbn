import 'package:supabase_flutter/supabase_flutter.dart';

class DataService {
  final supabase = Supabase.instance.client;

  Future<void> saveScore(int score) async {
    final userId = supabase.auth.currentUser?.id;
    if(userId == null) {
      throw Exception('User is not logged in');
    }
    await supabase
        .from('scores')
        .insert({'user_id': supabase.auth.currentUser?.id, 'score': score});
  }

  Future<List<dynamic>> getScores() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User is not logged in');
    }
    final response = await supabase
        .from('scores')
        .select()
        .eq('user_id', userId);
    return response;
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    final userId = supabase.auth.currentUser?.id;
    if(userId == null){
      throw Exception('User is not logged in');
    }
    final response = await supabase
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .single();
    return response;
  }

  Future<List<Map<String, dynamic>>> getUserScores() async {
    final userId = supabase.auth.currentUser?.id;
    if(userId == null) {
      throw Exception('User is not logged in');
    }
    final response = await supabase
        .from('scores')
        .select()
        .eq('user_id', userId);
    return response;
  }
}