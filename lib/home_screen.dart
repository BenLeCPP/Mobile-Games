import 'package:flutter/material.dart';
import 'hangman/hangman_home_page.dart';
import 'tic_tac_toe/tic_tac_toe_game.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Collection', style: TextStyle(fontSize: 30)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.black,
            height: 4.0,
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HangmanHomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/images/hangman_logo.png',
                    height: 300,
                    width: 310,
                    fit: BoxFit.cover
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TicTacToeGame()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/images/tic_tac_toe_logo.jpg',
                    height: 300,
                    width: 310,
                    fit: BoxFit.cover
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
