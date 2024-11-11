import 'package:flutter/material.dart';

import '../puzzle_class.dart';

void main() {
  runApp(const FifteenPuzzleApp());
}

class FifteenPuzzleApp extends StatelessWidget {
  const FifteenPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PuzzlePage(),
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
  int _puzzleSize = 4; // Default puzzle size
  final List<int> _availableSizes = [
    2,
    3,
    4,
    5
  ]; // List of sizes to choose from

  @override
  void initState() {
    super.initState();
    _puzzle = Puzzle(size: _puzzleSize);
  }

  void _onTileTap(int index) {
    setState(() {
      _puzzle.moveTile(index);
    });
  }

  void _restartGame() {
    setState(() {
      _puzzle = Puzzle(size: _puzzleSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    double tileSize = MediaQuery.of(context).size.width / _puzzle.size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('15 Puzzle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restartGame,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dropdown to select puzzle size
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<int>(
                value: _puzzleSize,
                items: _availableSizes.map((int size) {
                  return DropdownMenuItem<int>(
                    value: size,
                    child: Text('${size}x$size Puzzle'),
                  );
                }).toList(),
                onChanged: (int? newSize) {
                  if (newSize != null) {
                    setState(() {
                      _puzzleSize = newSize;
                      _puzzle = Puzzle(size: _puzzleSize);
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            _puzzle.isSolved()
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'You Win!',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
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
                      children:
                          List.generate(_puzzle.size * _puzzle.size, (index) {
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
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: isCorrectPosition
                                    ? Colors.green
                                    : Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
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
          ],
        ),
      ),
    );
  }
}
