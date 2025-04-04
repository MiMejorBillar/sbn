import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nsb/screens/player_selection.dart';
import 'package:nsb/screens/screen_game.dart';
import 'package:nsb/screens/players_list.dart';
import 'package:nsb/main.dart';
import 'package:nsb/data_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  final DataService _dataService = DataService();
  Map<String, dynamic>? _userProfile;
  List<Map<String,dynamic>>? _userScores;
  bool _isLoading = true;
  String? _errorMessage;

  String userData = 'Loading ...';

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try{
      final profile = await _dataService.getUserProfile();
      final scores = await _dataService.getUserScores();
      setState(() {
        _userProfile = profile;
        _userScores = scores;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final ModalRoute? route = ModalRoute.of(context);
    if(route != null){
      routeObserver.subscribe(this,route);
    }
  }

  @override
  void didPopNext() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      side: const BorderSide(color: Color.fromARGB(255, 85, 85, 85), width: 2),
    );
    final buttonTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

    if(_isLoading){
      return Scaffold(
        body: Center(child: CircularProgressIndicator(),),
      );
    } else if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: fetchUserData,
                child: const Text('Retry'),
              ),
            ],
          )),
      );
    } else {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Mi Billar', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                const Color.fromARGB(255, 0, 61, 110),         
                Colors.black,                       
              ]
            )
          ),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome, ${_userProfile?['username'] ?? 'User'}!",
                style: const TextStyle(fontSize: 24),
                ),
                if(_userScores != null && _userScores!.isNotEmpty)
                  Text(
                    'Your top score: ${_userScores![0]['score']}',
                    style: const TextStyle(fontSize: 18),
                  ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PlayersList()));
                  },
                  style: buttonStyle,
                  child: Text('Players List', style: buttonTextStyle)),
              ElevatedButton(
                onPressed: () {
                  showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const PlayersSelectionDialog(),
                  ).then((result) {
                    if (result == true) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ScreenGame()));
                    }
                  });
                },
                style: buttonStyle,
                child: Text('Match', style: buttonTextStyle,),
              )
            ],
          )),
        ));
    }
  }
}
