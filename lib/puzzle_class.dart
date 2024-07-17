class Puzzle {
  List<int> tiles;
  List<int> currentPositions;
  final int size;

  Puzzle({
    required this.size,
    List<int>? tiles,
    List<int>? currentPositions,
  })  : tiles = tiles ??
            List.generate(size * size, (index) => (index + 1) % (size * size)),
        currentPositions =
            currentPositions ?? List.generate(size * size, (index) => index) {
    if (tiles == null || currentPositions == null) {
      shuffle();
    }
  }

  void shuffle() {
    tiles.shuffle();
    for (int i = 0; i < tiles.length; i++) {
      currentPositions[tiles[i]] = i;
    }
  }

  bool isSolved() {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != (i + 1) % (size * size)) return false;
    }
    return tiles.last == 0;
  }

  bool moveTile(int index) {
    int blankIndex = tiles.indexOf(0);
    if (_isAdjacent(index, blankIndex)) {
      // Swap tiles
      tiles[blankIndex] = tiles[index];
      tiles[index] = 0;

      // Update positions
      currentPositions[tiles[blankIndex]] = blankIndex;
      currentPositions[0] = index;

      return true;
    }
    return false;
  }

  bool _isAdjacent(int index1, int index2) {
    int row1 = index1 ~/ size;
    int col1 = index1 % size;
    int row2 = index2 ~/ size;
    int col2 = index2 % size;

    return (row1 == row2 && (col1 - col2).abs() == 1) ||
        (col1 == col2 && (row1 - row2).abs() == 1);
  }
}
