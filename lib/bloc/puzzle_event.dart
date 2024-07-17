import 'package:equatable/equatable.dart';

abstract class PuzzleEvent extends Equatable {
  const PuzzleEvent();

  @override
  List<Object> get props => [];
}

class MoveTileEvent extends PuzzleEvent {
  final int index;

  const MoveTileEvent(this.index);

  @override
  List<Object> get props => [index];
}

class RestartGameEvent extends PuzzleEvent {}
