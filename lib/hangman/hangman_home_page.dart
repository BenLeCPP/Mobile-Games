import 'package:flutter/material.dart';
import 'hangman_game.dart';

class HangmanHomePage extends StatefulWidget {
  const HangmanHomePage({Key? key}) : super(key: key);

  @override
  _HangmanHomePageState createState() => _HangmanHomePageState();
}

class _HangmanHomePageState extends State<HangmanHomePage> {
  late HangmanGame _game;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _game = HangmanGame();
  }

  void _guessLetter(String letter) {
    setState(() {
      _game.guessLetter(letter);
      if (_game.hasWon) {
        _score++; // Increase score on correct guess
        _showResultDialog('You Win!', _game.selectedWord);
      } else if (_game.hasLost) {
        _showResultDialog('The word is:', _game.selectedWord);
      }
    });
  }

  void _startNewGame() {
    setState(() {
      _game = HangmanGame();
    });
  }

  void _navigateToHome() {
    Navigator.pop(context);
  }

  Widget _buildWordDisplay() {
    if (_game.hasLost) {
      return Column(
        children: [
          const Text(
            'The word is:',
            style: TextStyle(fontSize: 30, color: Colors.red, fontWeight: FontWeight.bold),
          ),
          Text(
            _game.selectedWord.toUpperCase(),
            style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      );
    } else {
      String guessedWordUpperCase = _game.selectedWord.toUpperCase();

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: guessedWordUpperCase.split('').map((char) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              _game.guessedLetters.contains(char) ? char : '_',
              style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildScoreDisplay() {
    return Text(
      'Score: $_score',
      style: const TextStyle(fontSize: 25, color: Colors.white),
    );
  }

  Widget _buildKeyboard() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return GridView.count(
      crossAxisCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      childAspectRatio: 1.3,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: letters.split('').map((letter) {
        return ElevatedButton(
          onPressed: (_game.hasWon || _game.hasLost) ? null : () => _guessLetter(letter.toUpperCase()),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: _game.guessedLetters.contains(letter.toUpperCase()) ? Colors.grey : Colors.blue,
            minimumSize: const Size(50, 50),
            padding: EdgeInsets.zero,
          ),
          child: Center(
            child: Text(
              letter,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHangmanImage() {
    int incorrectGuesses = _game.incorrectGuesses;
    String imageName = incorrectGuesses > 6 ? '6.png' : '$incorrectGuesses.png';
    return Image.asset(
      'assets/images/$imageName',
      height: 180,
    );
  }

  void _showResultDialog(String message, String? correctWord) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 26),
              ),
              if (correctWord != null && message == 'The word is:')
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      correctWord.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 26),
                    ),
                  ],
                ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _startNewGame();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text(
                      'Continue',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text(
                      'Exit',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Hangman Game',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: SizedBox(
          width: 48,
          height: 48,
          child: IconButton(
            icon: const Icon(Icons.home, color: Colors.white, size: 36),
            onPressed: _navigateToHome,
          ),
        ),
        actions: [
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white, size: 36),
              onPressed: _startNewGame,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildScoreDisplay(),
            ],
          ),
          const SizedBox(height: 30),
          _buildHangmanImage(),
          const SizedBox(height: 30),
          _buildWordDisplay(),
          const SizedBox(height: 30),
          _buildKeyboard(),
          const SizedBox(height: 10),
          if (!_game.hasWon && !_game.hasLost)
            Text(
              'Incorrect Guesses: ${_game.incorrectGuesses}/${HangmanGame.maxIncorrectGuesses}',
              style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
