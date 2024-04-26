import 'package:blackjackv1/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:blackjackv1/dealer.dart';



class Dealer extends DealerService {
  List<PlayingCard> deck = [];
  List<PlayingCard> discard = [];

  Dealer() {
    newDeck();
  }

// start a new game
  @override
  void newDeck() {
    deck = shuffleDeck(standardFiftyTwoCardDeck());
    discard = [];
  }

  @override
  List<PlayingCard> shuffleDeck(List<PlayingCard> deck) {
    deck.shuffle();
    return deck;
  }

  int getDeckSize() {
    return deck.length - 1;
  }

  @override
  void discardCard(PlayingCard card) {
    discard.add(card);
  }

  @override
  void discardDeck(List<PlayingCard> cards) {
    discard.addAll(cards);
  }

  List<PlayingCard> _handleDrawCard(int amount) {
    int deckSize = getDeckSize();
    int cardsLeft = deckSize - amount;


    if (cardsLeft < 0) {
      deck = [...shuffleDeck(discard), ...deck];

      discard = [];
      deckSize = getDeckSize();
      cardsLeft = deckSize - amount;
    }

    List<PlayingCard> cardsDrawn = deck.getRange(cardsLeft, deckSize).toList();
    deck.removeRange(cardsLeft, deckSize);

    return cardsDrawn;
  }

  @override
  PlayingCard drawCard() {
    return _handleDrawCard(1).first;
  }

  @override
  List<PlayingCard> drawCards(int amount) {
    return _handleDrawCard(amount);
  }
}

