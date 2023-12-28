markDraw(List<List<int>> matrix, int draw) {
  for (int i = 0; i < matrix.length; i++) {
    for (int j = 0; j < matrix[i].length; j++) {
      if (matrix[i][j] == draw) {
        matrix[i][j] = -1;
        return;
      }
    }
  }
}

int calculateSum(List<List<int>> matrix) => matrix.fold(
    0,
        (previousValue, row) =>
    previousValue +
        row.fold(
            0,
                (previousValue, element) =>
            previousValue + (element == -1 ? 0 : element)));

List<List<int>>? checkMatrix(List<List<int>> matrix) {
  for (int i = 0; i < matrix.length; i++) {
    final bingoOnRow = matrix[i].fold<int>(0, (p, e) => p + e) == -5;
    final bingoOnColumn = matrix[0][i] == -1 &&
        matrix[1][i] == -1 &&
        matrix[2][i] == -1 &&
        matrix[3][i] == -1 &&
        matrix[4][i] == -1;
    if (bingoOnRow || bingoOnColumn) {
      return matrix;
    }
  }
  return null;
}
