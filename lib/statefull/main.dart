import 'package:flutter/material.dart';

import '../puzzle_class.dart';

void main() {
  runApp(const FifteenPuzzleApp());
}

class FifteenPuzzleApp extends StatelessWidget {
  const FifteenPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PuzzlePage(),
    );
  }
}

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({super.key});

  @override
  PuzzlePageState createState() => PuzzlePageState();
}

class PuzzlePageState extends State<PuzzlePage> {
  late Puzzle _puzzle;

  @override
  void initState() {
    super.initState();
    _puzzle = Puzzle(size: 4);
  }

  void _onTileTap(int index) {
    setState(() {
      _puzzle.moveTile(index);
    });
  }

  void _restartGame() {
    setState(() {
      _puzzle = Puzzle(size: 4);
    });
  }

  @override
  Widget build(BuildContext context) {
    double tileSize = MediaQuery.of(context).size.width / _puzzle.size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('15 Puzzle statefull'),
      ),
      body: Center(
        child: _puzzle.isSolved()
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'You Win!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _restartGame,
                    child: const Text('Restart'),
                  ),
                ],
              )
            : SizedBox(
                width: tileSize * _puzzle.size,
                height: tileSize * _puzzle.size,
                child: Stack(
                  children: List.generate(_puzzle.size * _puzzle.size, (index) {
                    int tileValue = _puzzle.tiles[index];
                    if (tileValue == 0) return Container();

                    int currentPos = _puzzle.currentPositions[tileValue];
                    bool isCorrectPosition = tileValue ==
                        (index + 1) % (_puzzle.size * _puzzle.size);

                    return AnimatedPositioned(
                      key: ValueKey(tileValue),
                      duration: const Duration(milliseconds: 300),
                      left: (currentPos % _puzzle.size) * tileSize,
                      top: (currentPos ~/ _puzzle.size) * tileSize,
                      width: tileSize,
                      height: tileSize,
                      child: GestureDetector(
                        onTap: () => _onTileTap(index),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          color: isCorrectPosition ? Colors.green : Colors.blue,
                          child: Center(
                            child: Text(
                              '$tileValue',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
      ),
    );
  }
}
