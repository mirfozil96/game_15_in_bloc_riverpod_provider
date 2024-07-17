import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'puzzle_provider.dart';

void main() {
  runApp(const ProviderScope(child: FifteenPuzzleApp()));
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

class PuzzlePage extends ConsumerWidget {
  const PuzzlePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzle = ref.watch(puzzleProvider);
    final puzzleNotifier = ref.watch(puzzleProvider.notifier);
    double tileSize = MediaQuery.of(context).size.width / puzzle.size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('15 Puzzle riverpod'),
      ),
      body: Center(
        child: puzzle.isSolved()
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'You Win!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => puzzleNotifier.restartGame(),
                    child: const Text('Restart'),
                  ),
                ],
              )
            : SizedBox(
                width: tileSize * puzzle.size,
                height: tileSize * puzzle.size,
                child: Stack(
                  children: List.generate(puzzle.size * puzzle.size, (index) {
                    int tileValue = puzzle.tiles[index];
                    if (tileValue == 0) return Container();

                    int currentPos = puzzle.currentPositions[tileValue];
                    bool isCorrectPosition = tileValue ==
                        (index + 1) % (puzzle.size * puzzle.size);

                    return AnimatedPositioned(
                      key: ValueKey(tileValue),
                      duration: const Duration(milliseconds: 300),
                      left: (currentPos % puzzle.size) * tileSize,
                      top: (currentPos ~/ puzzle.size) * tileSize,
                      width: tileSize,
                      height: tileSize,
                      child: GestureDetector(
                        onTap: () => puzzleNotifier.moveTile(index),
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
