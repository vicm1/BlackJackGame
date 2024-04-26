import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'audio_util.dart';
import 'package:vibration/vibration.dart';
class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {

  bool isMusicEnabled = true;
  bool isVibrationEnabled = true;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Options",
          style: TextStyle(fontSize: 22.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blackjackbackground3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              const SizedBox(
                height: 200.0,
              ),
              Container(
                width: 120.0,
                height: 50.0,
                color: Colors.black,
                alignment: Alignment.center,
                child: const Text(
                  "Music",
                  style: TextStyle(fontSize: 30.0, color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              FlutterSwitch(
                  showOnOff: true,
                  width: 100,
                  height: 40,
                  valueFontSize: 25.0,
                  toggleSize: 30.0,
                  value: isMusicEnabled,
                  onToggle: (bool value){
                setState(() {
                  isMusicEnabled = value;
                  if(isMusicEnabled){
                    AudioUtil.playBackgroundMusic();
                  }else{
                    AudioUtil.stopBackgroundMusic();
                  }
                });
              }
              ),
              const SizedBox(
                height: 25.0,
              ),
              Container(
                width: 150.0,
                height: 50,
                color: Colors.black,
                alignment: Alignment.center,
                child: const Text(
                  "Vibration",
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              FlutterSwitch(
                  showOnOff: true,
                  width: 100,
                  height: 40,
                  valueFontSize: 25.0,
                  toggleSize: 30.0,
                  value: isVibrationEnabled ,
                  onToggle: (bool value2){
                    setState(() {
                      isVibrationEnabled = value2;
                      if(isVibrationEnabled){
                        Vibration.vibrate(duration: 1000);
                      }else{
                        Vibration.cancel();
                      }
                    });
                  }
              ),
              const SizedBox(
                height: 25.0,
              ),
              SizedBox(
                width: 120,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    aboutPopUp(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Rules'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
