import 'dart:math';

class User {
  final String name;

  User(this.name);

  final List<String> randomPhrases = [
    "Kto zdes?",
    "Ya Woopsen!",
    "A ya Poopsen!",
    "Ya rodilsa!",
    "Oh i narkomanu..."
  ];

  final Random _phrasesRamdomizer = Random();

  factory User.Woopsen() => User("Woopsen");

  factory User.Poopsen() => User("Poopsen");

  factory User.Luntik() => User("Luntik");

  String randomPhrase() =>
      randomPhrases[_phrasesRamdomizer.nextInt(randomPhrases.length)];
}

abstract class ListData {}

class Message extends ListData {
  final User user;
  final String text;
  final DateTime time = DateTime.now();
  static const String _notAvailableText = "N/A";

  Message(this.user, this.text);

  factory Message.notAvailable(User user) => Message(user, _notAvailableText);

  factory Message.randomFrom(User user) => Message(user, user.randomPhrase());
}

class SummaryMessage extends ListData {
  final List<Message> messages;

  SummaryMessage(this.messages);
}
