import 'package:flutter/material.dart';
import 'dart:math';

class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  int _scoreX = 0;
  int _scoreO = 0;
  bool _turnOfO = true;
  int _filledBoxes = 0;
  final List<String> _xOrOList = List.filled(9, '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            iconSize: 30.0,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              iconSize: 30.0,
              onPressed: _clearBoard,
            ),
          ),
        ],
        title: const Text(
          'Tic Tac Toe',
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          _buildPointsBox(),
          _buildGrid(),
          _buildTurn(),
        ],
      ),
    );
  }

  Widget _buildPointsBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildScore('Player X', _scoreX),
        const SizedBox(width: 40),
        _buildScore('Player O', _scoreO),
      ],
    );
  }

  Widget _buildScore(String player, int score) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(player,
            style: const TextStyle(
              fontSize: 25.0,
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          Text(score.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Expanded(
      flex: 3,
      child: GridView.builder(
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => _tapped(index),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.yellow,
                  width: 2.0,
                ),
              ),
              child: Center(
                child: Text(
                  _xOrOList[index],
                  style: TextStyle(
                    color: _xOrOList[index] == 'x' ? Colors.white : Colors.blue,
                    fontSize: 40,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTurn() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          _turnOfO ? 'Turn of X' : 'Turn of O',
          style: const TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
    );
  }

  void _tapped(int index) {
    if (_xOrOList[index] == '') {
      setState(() {
        _xOrOList[index] = 'x';
        _filledBoxes++;
        _turnOfO = !_turnOfO;
        _checkTheWinner();

        if (!_turnOfO && _filledBoxes < 9) {
          _botMove();
        }
      });
    }
  }

  void _botMove() {
    setState(() {
      _turnOfO = false;
    });

    Future.delayed(const Duration(seconds: 1), () {
      int bestScore = -1000;
      int bestMove = -1;

      for (int i = 0; i < 9; i++) {
        if (_xOrOList[i] == '') {
          _xOrOList[i] = 'o';
          int score = _minimax(_xOrOList, 0, false);
          _xOrOList[i] = '';
          if (score > bestScore) {
            bestScore = score;
            bestMove = i;
          }
        }
      }

      setState(() {
        _xOrOList[bestMove] = 'o';
        _filledBoxes++;
        _turnOfO = true;
        _checkTheWinner();
      });
    });
  }

  int _minimax(List<String> board, int depth, bool isMaximizing) {
    String winner = _checkWinner(board);
    if (winner != '') {
      return winner == 'o' ? 10 - depth : depth - 10;
    }
    if (_isBoardFull(board)) {
      return 0;
    }

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = 'o';
          int score = _minimax(board, depth + 1, false);
          board[i] = '';
          bestScore = max(score, bestScore);
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = 'x';
          int score = _minimax(board, depth + 1, true);
          board[i] = '';
          bestScore = min(score, bestScore);
        }
      }
      return bestScore;
    }
  }

  bool _isBoardFull(List<String> board) {
    for (String cell in board) {
      if (cell == '') {
        return false;
      }
    }
    return true;
  }

  String _checkWinner(List<String> board) {
    const List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combo in winningCombinations) {
      if (board[combo[0]] == board[combo[1]] &&
          board[combo[0]] == board[combo[2]] &&
          board[combo[0]] != '') {
        return board[combo[0]];
      }
    }
    return '';
  }

  void _checkTheWinner() {
    String winner = _checkWinner(_xOrOList);
    if (winner != '') {
      _showResultDialog(winner == 'x' ? 'You win!' : 'You lose');
      return;
    }

    if (_filledBoxes == 9) {
      _showResultDialog('Draw!');
    }
  }

  void _showResultDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 26),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _clearBoard();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 25),),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Exit', style: TextStyle(color: Colors.white, fontSize: 25),),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (message == 'You win!') {
      _scoreX++;
    } else if (message == 'You lose') {
      _scoreO++;
    }
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        _xOrOList[i] = '';
      }
      _filledBoxes = 0;
      _turnOfO = true;
    });
  }
}
