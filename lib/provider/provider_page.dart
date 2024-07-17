import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'puzzle_provider.dart';

void main() {
  runApp(const FifteenPuzzleApp());
}

class FifteenPuzzleApp extends StatelessWidget {
  const FifteenPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner : false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PuzzlePage(),
    );
  }
}

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PuzzleProvider(size: 4),
      child: Consumer<PuzzleProvider>(
        builder: (context, puzzleProvider, child) {
          double tileSize =
              MediaQuery.of(context).size.width / puzzleProvider.size;

          return Scaffold(
            appBar: AppBar(
              title: const Text('15 Puzzle in provider'),
            ),
            body: Center(
              child: puzzleProvider.isSolved()
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
                          onPressed: () => puzzleProvider.restartGame(),
                          child: const Text('Restart'),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: tileSize * puzzleProvider.size,
                      height: tileSize * puzzleProvider.size,
                      child: Stack(
                        children: List.generate(
                            puzzleProvider.size * puzzleProvider.size, (index) {
                          int tileValue = puzzleProvider.tiles[index];
                          if (tileValue == 0) return Container();

                          int currentPos =
                              puzzleProvider.currentPositions[tileValue];
                          bool isCorrectPosition = tileValue ==
                              (index + 1) %
                                  (puzzleProvider.size * puzzleProvider.size);

                          return AnimatedPositioned(
                            key: ValueKey(tileValue),
                            duration: const Duration(milliseconds: 300),
                            left: (currentPos % puzzleProvider.size) * tileSize,
                            top: (currentPos ~/ puzzleProvider.size) * tileSize,
                            width: tileSize,
                            height: tileSize,
                            child: GestureDetector(
                              onTap: () => puzzleProvider.moveTile(index),
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                color: isCorrectPosition
                                    ? Colors.green
                                    : Colors.blue,
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
        },
      ),
    );
  }
}
