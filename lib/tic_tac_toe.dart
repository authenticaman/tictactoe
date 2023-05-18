import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'welcome_screen.dart';

class TicTacToe extends StatefulWidget {
  @override
  String firstPlayer;
  String secondPlayer;

  TicTacToe({required this.firstPlayer, required this.secondPlayer});

  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  late List<List<String>> _board;
  late String _currentPlayer;
  late String _winner;
  late bool _gameOver;

  @override
  void initState() {
    super.initState();
    _board = List.generate(3, (_) => List.generate(3, (_) => ""));
    _currentPlayer = "X";
    _winner = "";
    _gameOver = false;
  }

  void _resetGame() {
    setState(() {
      _board = List.generate(3, (_) => List.generate(3, (_) => ""));
      _currentPlayer = "X";
      _winner = "";
      _gameOver = false;
    });
  }

  void _makeMove(int row, int col) {
    if (_board[row][col] != "" || _gameOver) {
      return;
    }
    setState(() {
      _board[row][col] = _currentPlayer;
      // check for winner
      if (_board[row][0] == _currentPlayer &&
          _board[row][1] == _currentPlayer &&
          _board[row][2] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][col] == _currentPlayer &&
          _board[1][col] == _currentPlayer &&
          _board[2][col] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][0] == _currentPlayer &&
          _board[1][1] == _currentPlayer &&
          _board[2][2] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      } else if (_board[0][2] == _currentPlayer &&
          _board[1][1] == _currentPlayer &&
          _board[2][0] == _currentPlayer) {
        _winner = _currentPlayer;
        _gameOver = true;
      }
      // switch players
      _currentPlayer = _currentPlayer == "X" ? "O" : "X";

      // check for a tie
      if (!_board.any((row) => row.any((cell) => cell == ""))) {
        _gameOver = true;
        _winner = "It's a Tie";
      }
      if (_winner != "") {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          btnOkText: "Play Again",
          title: _winner == "X"
              ? widget.firstPlayer + "Won!"
              : _winner == "O"
                  ? widget.secondPlayer + "Won!"
                  : "Its a tie",
          btnOkOnPress: () {
            _resetGame();
          },
        ).show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black12,
          elevation: 0,
          title: const Text(
            "TIC TAC TOE",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.green,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 70),
              SizedBox(
                height: 580,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Turn : ",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _currentPlayer == "X"
                              ? widget.firstPlayer + "($_currentPlayer)"
                              : widget.secondPlayer + "($_currentPlayer)",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _currentPlayer == "X"
                                ? Color(0xFFE25041)
                                : Color(0xFF1CBD9E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.all(8),
                      // child: SingleChildScrollView(
                      child: GridView.builder(
                        itemCount: 9,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) {
                          int row = index ~/ 3;
                          int col = index % 3;
                          return GestureDetector(
                            onTap: () => _makeMove(row, col),
                            child: Container(
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.lightGreen,
                                ),
                                child: Center(
                                  child: Text(
                                    _board[row][col],
                                    style: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      color: _board[row][col] == "X"
                                          ? Color(0xFFE25041)
                                          : Color(0xFF1CBD9E),
                                    ),
                                  ),
                                )),
                          );
                        },
                      ),
                      //),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(0),
                          color: Colors.lightGreen,
                          child: MaterialButton(
                              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              //minWidth: MediaQuery.of(context).size.width,
                              onPressed: _resetGame,
                              child: const Text(
                                "RESET",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),

                        const SizedBox(width: 20),
                        Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(0),
                          color: Colors.lightGreen,
                          child: MaterialButton(
                              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const WelcomeScreen(),
                                    ));
                                widget.firstPlayer = "";
                                widget.secondPlayer = "";
                              },
                              child: const Text(
                                "RESTART",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
