import 'package:playing_cards/playing_cards.dart';

abstract class DealerService {
  void newDeck();
  void shuffleDeck(List<PlayingCard> deck);
  PlayingCard drawCard();
  List<PlayingCard> drawCards(int amount);
  void discardCard(PlayingCard card);
  void discardDeck(List<PlayingCard> cards);
  // void getScore()

}
