import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'puzzle_bloc.dart';
import 'puzzle_event.dart';
import 'puzzle_state.dart';

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
      home: BlocProvider(
        create: (context) => PuzzleBloc(),
        child: const PuzzlePage(),
      ),
    );
  }
}

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({super.key});

  @override
  Widget build(BuildContext context) {
    double tileSize = MediaQuery.of(context).size.width / 4;

    return Scaffold(
      appBar: AppBar(
        title: const Text('15 Puzzle in Bloc'),
      ),
      body: BlocBuilder<PuzzleBloc, PuzzleState>(
        builder: (context, state) {
          final puzzle = state.puzzle;

          return Center(
            child: puzzle.isSolved()
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
                        onPressed: () {
                          context.read<PuzzleBloc>().add(RestartGameEvent());
                        },
                        child: const Text('Restart'),
                      ),
                    ],
                  )
                : SizedBox(
                    width: tileSize * puzzle.size,
                    height: tileSize * puzzle.size,
                    child: Stack(
                      children:
                          List.generate(puzzle.size * puzzle.size, (index) {
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
                            onTap: () {
                              context
                                  .read<PuzzleBloc>()
                                  .add(MoveTileEvent(index));
                            },
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
          );
        },
      ),
    );
  }
}
