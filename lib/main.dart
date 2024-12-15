import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(JogodaVelha());
}

class JogodaVelha extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jogo da Velha',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: TicTacToePage(),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  @override
  _TicTacToePageState createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  List<String> board = List.filled(9, "");
  String currentPlayer = "X";
  String winner = "";
  bool isComputer = false;

  void resetGame() {
    setState(() {
      board = List.filled(9, "");
      currentPlayer = "X";
      winner = "";
    });
  }

  void handleTap(int index) {
    if (board[index] == "" && winner == "") {
      setState(() {
        board[index] = currentPlayer;
        if (checkWinner()) {
          winner = currentPlayer;
        } else {
          currentPlayer = currentPlayer == "X" ? "O" : "X";
          if (isComputer && currentPlayer == "O") {
            computerMove();
          }
        }
      });
    }
  }

  void computerMove() {
    Future.delayed(Duration(milliseconds: 500), () {
      int index = findBestMove();
      if (index != -1 && winner == "") {
        setState(() {
          board[index] = "O";
          if (checkWinner()) {
            winner = "O";
          } else {
            currentPlayer = "X";
          }
        });
      }
    });
  }

  int findBestMove() {
    List<int> availableMoves = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == "") {
        availableMoves.add(i);
      }
    }
    if (availableMoves.isNotEmpty) {
      return availableMoves[Random().nextInt(availableMoves.length)];
    }
    return -1;
  }

  bool checkWinner() {
    List<List<int>> winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var condition in winConditions) {
      if (board[condition[0]] == currentPlayer &&
          board[condition[1]] == currentPlayer &&
          board[condition[2]] == currentPlayer) {
        return true;
      }
    }
    return false;
  }

  Widget buildTile(int index) {
    return GestureDetector(
      onTap: () => handleTap(index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            board[index],
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Jogo da Velha'),
        backgroundColor: Colors.grey.shade700,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Opção de jogador (Humano ou Computador)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isComputer ? "Modo Computador" : "Modo Humano",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Switch(
                    value: isComputer,
                    onChanged: (value) {
                      setState(() {
                        isComputer = value;
                        resetGame();
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                ],
              ),
            ),
            // Tabuleiro do jogo
            Container(
              width: 300,
              height: 300,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                itemBuilder: (context, index) {
                  return buildTile(index);
                },
              ),
            ),
            SizedBox(height: 20),
            // Mensagens de vitória ou empate
            if (winner != "")
              Text(
                'Vencedor: $winner',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            if (winner == "" && !board.contains(""))
              Text(
                'Empate!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            SizedBox(height: 20),
            // Botão para reiniciar o jogo
            ElevatedButton(
              onPressed: resetGame,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.grey.shade700,
              ),
              child: Text(
                'Reiniciar Jogo',
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
