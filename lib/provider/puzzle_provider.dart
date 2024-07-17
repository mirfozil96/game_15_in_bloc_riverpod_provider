import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../puzzle_class.dart';

class PuzzleProvider with ChangeNotifier {
  late Puzzle _puzzle;
  int get size => _puzzle.size;
  List<int> get tiles => _puzzle.tiles;
  List<int> get currentPositions => _puzzle.currentPositions;

  PuzzleProvider({required int size}) {
    _puzzle = Puzzle(size: size);
  }

  void moveTile(int index) {
    if (_puzzle.moveTile(index)) {
      notifyListeners();
    }
  }

  void restartGame() {
    _puzzle = Puzzle(size: _puzzle.size);
    notifyListeners();
  }

  bool isSolved() {
    return _puzzle.isSolved();
  }
}