class HangmanGame {
  final List<String> words = [
    'apple', 'banana', 'orange', 'computer', 'music', 'math',
    'keyboard', 'mouse', 'phone', 'watermelon', 'soccer', 'basketball',
    'tennis', 'swimming', 'game', 'baseball', 'speaker', 'headphone'
  ];

  late String selectedWord;
  List<String> guessedLetters = [];
  int incorrectGuesses = 0;
  static const int maxIncorrectGuesses = 6;

  HangmanGame() {
    _startNewGame();
  }

  void _startNewGame() {
    selectedWord = (words..shuffle()).first;
    guessedLetters = [];
    incorrectGuesses = 0;
  }

  void guessLetter(String letter) {
    letter = letter.toUpperCase();
    if (guessedLetters.contains(letter)) return;

    guessedLetters.add(letter);

    if (!selectedWord.toUpperCase().contains(letter)) {
      incorrectGuesses++;
    }
  }

  bool get hasWon {
    return selectedWord.split('').every((char) => guessedLetters.contains(char.toUpperCase()));
  }

  bool get hasLost {
    return incorrectGuesses >= maxIncorrectGuesses;
  }
}

