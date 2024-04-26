import 'dart:io';

import 'package:blackjackv1/play.dart';

import 'chipbet.dart';
import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import 'options.dart';
import 'package:just_audio/just_audio.dart';
import 'audio_util.dart';

void main() => runApp(const MyApp());



class MyApp extends StatelessWidget //myApp
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // loadAssetAudio();
    // playBackgroundMusic();

    AudioUtil.loadAssetAudio();
    AudioUtil.playBackgroundMusic();
    return MaterialApp(
      routes: {
        'FirstPage':(context) => const FirstPage(),
        // 'SecondPage':(context) => SecondPage(),
        'ThirdPage':(context) =>  ThirdPage(),
        'HomeChip':(context) => const HomeChip(),
      }, initialRoute: 'FirstPage',
    );
  }
  // Future<void> loadAssetAudio() async {
  //   await audioPlayer.setAsset('assets/music/bg.mp3');
  // }
  // void playBackgroundMusic() async {
  //   await audioPlayer.play();
  // }
  //
  // void stopBackgroundMusic() async {
  //   await audioPlayer.stop();
  // }
}

class FirstPage extends StatelessWidget //first page
{
  const FirstPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        // BoxDecoration takes the image
        decoration: const BoxDecoration(
          // Image set to background of the body
          image: DecorationImage(
              image: AssetImage("assets/images/blackjackbackground3.png"),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            // decoration: const InputDecoration(labelText: 'Title'),
            //onChanged: (value) => value
            children: [
              const SizedBox(height: 80),
            Transform.scale(
              scale: 1.4, // change the scale factor as needed
              child: Image.asset('assets/images/blackjack4.png'),
            ),
              const SizedBox(height: 40),
              SizedBox(
                width: 135,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeChip()), //inputs string into constructor
                      ); //push as SecondPage on top of stack
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Play')),
              ),
              //Button
              const SizedBox(height: 23),
              SizedBox(
                width: 132,
                height: 47,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                 ThirdPage()), //inputs string into constructor
                      ); //push as SecondPage on top of stack
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Options')),
              ),
              const SizedBox(height: 23),
              SizedBox(
                width: 88,
                height: 40,
                child: ElevatedButton(
                    onPressed: () => exit(0),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Quit')),
              ),
            ],
          ),
        ),
      ),
    ); //Column)
    //Center
  } //scaffold
} //first page


  aboutPopUp(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.only(
              top: 10.0,
            ),
            title: const Text(
              "What is Blackjack?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.black,
            content: Container(
              decoration: const BoxDecoration(color: Colors.black),
              height: 540,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Blackjack, also known as twenty-one, is a popular casino card game that involves a player trying to beat the dealer by having a hand value of 21 or as close to 21 as possible without going over. Each card has a value of either its number or 10 for face cards and an Ace can be worth 1 or 11 depending on the player's choice."
                        "The game typically involves one or more decks of standard playing cards and can be played with a single player or a group of players competing against the dealer. Each player is dealt two cards face up and the dealer is dealt one card face up and one card face down."
                        "Players can choose to 'hit' or receive another card to try and improve their hand value, or 'stand' if they are satisfied with their current hand. Players can also choose to 'double down' by doubling their bet and receiving one more card or 'split' by separating their initial two cards into two separate hands."
                        "If a player's hand exceeds 21, they 'bust' and automatically lose the round. The dealer must follow specific rules for hitting or standing, usually requiring the dealer to hit until they have a hand value of 17 or greater. The player with the highest hand value without busting or the dealer going over 21 wins the round.",
                        style: TextStyle(
                            fontSize: 14.8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  } //scaffold
 //second page
