import 'package:equatable/equatable.dart';
import '../puzzle_class.dart';

class PuzzleState extends Equatable {
  final Puzzle puzzle;

  const PuzzleState(this.puzzle);

  @override
  List<Object> get props => [puzzle];
}
