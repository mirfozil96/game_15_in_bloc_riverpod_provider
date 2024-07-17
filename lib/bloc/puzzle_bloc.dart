import 'package:flutter_bloc/flutter_bloc.dart';
import '../puzzle_class.dart';
import 'puzzle_event.dart';
import 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc() : super(PuzzleState(Puzzle(size: 4))) {
    on<MoveTileEvent>(_onMoveTile);
    on<RestartGameEvent>(_onRestartGame);
  }

  void _onMoveTile(MoveTileEvent event, Emitter<PuzzleState> emit) {
    final puzzle = state.puzzle;
    if (puzzle.moveTile(event.index)) {
      emit(PuzzleState(Puzzle(
        size: puzzle.size,
        tiles: List.from(puzzle.tiles),
        currentPositions: List.from(puzzle.currentPositions),
      )));
    }
  }

  void _onRestartGame(RestartGameEvent event, Emitter<PuzzleState> emit) {
    emit(PuzzleState(Puzzle(size: 4)));
  }
}
