import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../puzzle_class.dart';

final puzzleProvider = StateNotifierProvider<PuzzleNotifier, Puzzle>((ref) {
  return PuzzleNotifier();
});

class PuzzleNotifier extends StateNotifier<Puzzle> {
  PuzzleNotifier() : super(Puzzle(size: 4));

  void moveTile(int index) {
    if (state.moveTile(index)) {
      // Create a new instance of Puzzle to trigger the state change
      state = Puzzle(
        size: state.size,
        tiles: List.from(state.tiles),
        currentPositions: List.from(state.currentPositions),
      );
    }
  }

  void restartGame() {
    state = Puzzle(size: state.size);
  }
}
