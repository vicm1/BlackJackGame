import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dealer.dart';
import 'service.dart';
import 'chipbet.dart';
import 'package:playing_cards/playing_cards.dart';
import 'card.dart';

const HIGHES_SCORE_VALUE = 21;
class SecondPage extends StatefulWidget {
  final int totalBetAmount;
  final int balance;
  final Function(int) onWin;
  final Function() onResetTotalBetAmount;
  final Function(int) onBalanceUpdate;


  const SecondPage({
    Key? key,
    required this.totalBetAmount,
    required this.balance,
    required this.onWin,
    required this.onResetTotalBetAmount,
    required this.onBalanceUpdate,
  }) : super(key: key);

  @override
  SecondPageState createState() => SecondPageState();
}


class SecondPageState extends State<SecondPage> {
  int _balance = 0;
  int _totalBetAmount = 0;
  int _playerScore = 0;
  int _dealerScore = 0;
  int _dealerScore2 = 0;
  final dealerService = Dealer();
  List<PlayingCard> playerHand = [];
  List<PlayingCard> dealerHand= [];
  List<PlayingCard> dealerHand2= [];
  bool _cardsDealt = false;
  bool _result = true;
  bool _hitButtonEnabled = true;
  void _dealCards() {
    setState(() {
      playerHand.clear();
      dealerHand.clear();
      dealerHand2.clear();
      _dealerScore2 = 0;
      _balance = widget.balance; // Reset balance to initial value
      _totalBetAmount = widget.totalBetAmount; // Reset total bet amount to initial value
      playerHand = dealerService.drawCards(2);
      dealerHand = dealerService.drawCards(2);
      dealerService.newDeck();
      _cardsDealt = true; // Set _cardsDealt to true after dealing the cards
      dealerHand2.add(dealerHand[dealerHand.length -1]);
      print(dealerHand2[0]);
      int playerScore = mapCardValueRules(playerHand);
      // int dealerScore = mapCardValueRules(dealerHand);
      _playerScore = playerScore;
      _dealerScore2 = mapCardValueRules(dealerHand2);
      print("Player Score: $playerScore");
      print("Dealer Score: $_dealerScore");
    }
    );
  }


  int dealerAction(){
    int dealerScore = mapCardValueRules(dealerHand);
    int dealerCards = dealerHand.length;
    print("Dealer card in hand: $dealerCards");
    if(dealerScore <= 11) {
      print("Dealer card in hand: $dealerCards");
      dealerHand.addAll(dealerService.drawCards(1));
      dealerScore = mapCardValueRules(dealerHand);
    }
    if (dealerScore <= 15){
      print("Dealer card in hand: $dealerCards");
      dealerHand.addAll(dealerService.drawCards(1));
      dealerScore = mapCardValueRules(dealerHand);
    }

    return dealerScore;
  }

  void _showResultDialog(String title, String message, String buttonText, int playerScore, int dealerScore) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: TextStyle(fontSize: 22.0)),
              SizedBox(height: 10),
              Text('Player Score: $playerScore', style: const TextStyle(fontSize: 22.0)),
              Text('Dealer Score: $dealerScore', style: const TextStyle(fontSize: 22.0)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF1A4678)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Text(buttonText, style: TextStyle(fontSize: 20.0)),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Navigate back to the betting chip screen
              },
            ),
          ],
        );
      },
    );
  }


  void gameStatus(int playerScore, int dealerScore) {
    if (playerScore > 21) {
      setState(() {
        _result = false;
        _loseBetAmount();
      });
      Future.delayed(const Duration(milliseconds: 499), () {
        _showResultDialog('Better luck next time!', 'You lost!', 'Go Back', playerScore, dealerScore);
        print("You lose!");
      });
    } else if (dealerScore > 21 || playerScore > dealerScore) {
      setState(() {
        // Player wins
        widget.onWin(_totalBetAmount * 2); // Multiply the total bet amount by 2
        if (_totalBetAmount > 0) {
          _updateBalance(_totalBetAmount * 2); // Multiply the total bet amount by 2 to update balance
          _result = false;
          _resetTotalBetAmount();
        }
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        _showResultDialog('Congratulations!', 'You won!', 'Go Back', playerScore, dealerScore);
        print("You Win!");
      });
    } else if (playerScore < dealerScore) {
      setState(() {
        // Player loses
        _result = false;
        _loseBetAmount();
      });
      Future.delayed(const Duration(milliseconds: 499), () {
        _showResultDialog('Better luck next time!', 'You lost!', 'Go Back', playerScore, dealerScore);
        print("You lose!");
      });
    } else {
      setState(() {
        _result = false;
        _resetTotalBetAmount();
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        _showResultDialog('It\'s a draw!', 'Draw!', 'Go Back', playerScore, dealerScore);
        print("Draw!");
      });
    }
  }

  void _stand() {
    setState(() {
      int playerScore = mapCardValueRules(playerHand);
      int dealerScore = mapCardValueRules(dealerHand);

      print("Player Score: $playerScore");
      print("Dealer Score: $dealerScore");
      _result = false;
      _playerScore = playerScore;
      _dealerScore = dealerScore;

      while (dealerScore < 17) {
        dealerHand.addAll(dealerService.drawCards(1));
        dealerScore = mapCardValueRules(dealerHand);
        print("Dealer draws a card.");
        print("Dealer Score: $dealerScore");
      }

      gameStatus(playerScore, dealerScore);
    });
  }

  void _hit() async {
    if (_hitButtonEnabled) {
      setState(() {
        _hitButtonEnabled = false; // Disable the hit button
      });

      playerHand.addAll(dealerService.drawCards(1));

      int playerScore = mapCardValueRules(playerHand);
      int dealerScore = dealerAction();
      _result = false;

      print("Player Score: $playerScore");
      print("Dealer Score: $dealerScore");

      _playerScore = playerScore;
      _dealerScore = dealerScore;

      if (playerScore >= 21 || dealerScore >= 21) {
        gameStatus(playerScore, dealerScore);
      }

      await Future.delayed(const Duration(seconds: 2)); // Add a delay of 2 seconds
      setState(() {
        _hitButtonEnabled = true; // Enable the hit button after the delay
      });
    }
  }
  void _double(){
    setState(() {
      print("Double Hit");
      int playerScore = mapCardValueRules(playerHand);
      int lengthPlayerHand = playerHand.length;
      if( playerScore < 21 && lengthPlayerHand == 2){
          playerHand.addAll(dealerService.drawCards(1));
          _totalBetAmount = _totalBetAmount * 2;
          playerScore = mapCardValueRules(playerHand);
          int dealerScore = dealerAction();
          print("playerScore : $playerScore");
          print("DealerScore : $dealerScore");
          _playerScore = playerScore;
          _dealerScore = dealerScore;
          gameStatus(playerScore, dealerScore);
          _result = false;
          // if(playerScore > 21){
          //   print("lose");
          //
          // }
      }
    });
  }

  int mapStandardCardValue(int cardEnumIndex) {
    // ignore: constant_identifier_names
    const GAP_BETWEEN_INDEX_AND_VALUE = 2;

    // Card value 2-10 -> index between 0 and 8
    if (0 <= cardEnumIndex && cardEnumIndex <= 8) {
      return cardEnumIndex + GAP_BETWEEN_INDEX_AND_VALUE;
    }

    // Card is jack, queen, king -> index between90 and 11
    if (9 <= cardEnumIndex && cardEnumIndex <= 11) {
      return 10;
    }

    return 0;
  }

  int getSumOfStandardCards(List<PlayingCard> standardCards) {
    return standardCards.fold<int>(
        0, (sum, card) => sum + mapStandardCardValue(card.value.index));
  }
  int mapCardValueRules(List<PlayingCard> cards) {
    List<PlayingCard> standardCards = cards
        .where((card) => (0 <= card.value.index && card.value.index <= 11))
        .toList();

    final sumStandardCards = getSumOfStandardCards(standardCards);

    int acesAmount = cards.length - standardCards.length;
    if (acesAmount == 0) {
      return sumStandardCards;
    }

    // Special case: Ace could be value 1 or 11
    final pointsLeft = HIGHES_SCORE_VALUE - sumStandardCards;
    final oneAceIsEleven = 11 + (acesAmount - 1);

    // One Ace with value 11 fits
    if (pointsLeft >= oneAceIsEleven) {
      return sumStandardCards + oneAceIsEleven;
    }

    return sumStandardCards + acesAmount;
  }


  @override
  void initState() {
    super.initState();
    _balance = widget.balance;
    _totalBetAmount = widget.totalBetAmount;
  }

  void _updateBalance(int amount) {
    setState(() {
      _balance += amount;
    });
  }

  void _resetTotalBetAmount() {
    setState(() {
      _totalBetAmount = 0;
    });
  }


  void _loseBetAmount() {
    setState(() {
      _resetTotalBetAmount();
      if (_balance <= 0) {
        // Display game over dialog with a delay
        Future.delayed(const Duration(milliseconds: 500), () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Game Over!',style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold)),
                content: Container(
                  width: 300, // Set the desired width
                  height: 110, // Set the desired height
                  child: const Text(
                    'You have no more money left to bet! Click Play Again to try again.',
                      style: TextStyle(fontSize: 24)),
                ),
                actions: <Widget>[
                  SizedBox(
                    width: 125,
                    height: 50.0,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF1A4678)),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: const Text('Play Again', style: TextStyle(fontSize: 20.0)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const HomeChip()),
                        );
                        setState(() {
                          _balance = 1000;
                          _totalBetAmount = 0;
                        });
                        widget.onBalanceUpdate(_balance);
                        widget.onResetTotalBetAmount(); // reset the total bet amount to zero
                      },
                    ),
                  ),
                ],
              );
            },
          );
        });
      } else {
        widget.onBalanceUpdate(_balance);
        widget.onResetTotalBetAmount(); // reset the total bet amount to zero
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BlackJack",
          style: TextStyle(fontSize: 26),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A4678),
      ),
      body: DecoratedBox(
        // BoxDecoration takes the image
        decoration: const BoxDecoration(
          // Image set to background of the body
          image: DecorationImage(
            image: AssetImage("assets/images/blackjackbackground3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Bank: \$$_balance',
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 70),
                  Text('In: \$$_totalBetAmount',
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 130,
                height: 50,
                child: ElevatedButton(
                  onPressed: _dealCards,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A4678),
                    foregroundColor: Colors.white,
                    textStyle:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Deal'),
                ),
              ),
              SizedBox(
                  height: 200,
                  width: dealerHand.length * 85,
                  child: FlatCardFan(children: [
                    for (var card in dealerHand) ...[
                      if (_result)
                          if (card != dealerHand[dealerHand.length -1])
                            CardAnimatedWidget(card, true,3.0 )
                          else
                            CardAnimatedWidget(card, false,3.0 )
                      else
                        CardAnimatedWidget(card, false,3.0 )
                    ]
                  ],
                  ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(_result)
                    Text('Dealer Score: $_dealerScore2', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
                  else
                    Text('Dealer Score: $_dealerScore', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _cardsDealt ? _hit : null, // Disable the button if _cardsDealt is false
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A4678),
                        foregroundColor: Colors.white,
                        textStyle:
                        const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Hit'),
                    ),
                  ),
                  const SizedBox(width: 25),
                  SizedBox(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _cardsDealt ? _stand : null, // Disable the button if _cardsDealt is false
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A4678),
                        foregroundColor: Colors.white,
                        textStyle:
                        const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Stand'),
                    ),
                  ),
                  const SizedBox(width: 25),
                  SizedBox(
                    width: 110,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _cardsDealt ? _double : null, // Disable the button if _cardsDealt is false
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A4678),
                        foregroundColor: Colors.white,
                        textStyle:
                        const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Double'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Player Score: $_playerScore',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 200,
                width: playerHand.length * 90,
                child: FlatCardFan(children: [
                  for (var card in playerHand) ...[
                    CardAnimatedWidget(card, false,3.0 )
                  ]
                ],
                ),
              ),
            ],
          ),
        ), //Column)
      ),
    ); //Center
  } //scaffold
}
