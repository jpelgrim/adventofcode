// https://adventofcode.com/2021/day/20
import 'dart:io';
import 'dart:math';

void main() {
  print('--- Day 20: Trench Map ---');

  var lines = File('input.txt').readAsLinesSync();
  final algorithm = lines[0];
  var image = lines.skip(2).toList().map((e) => e.split('')).toList();

  var answerPart1 = 0;
  for (int i = 0; i<50; i++) {
    image = image.enhance(algorithm, i % 2 == 0 ? '.' : algorithm[0]);
    if (i == 1) answerPart1 = image.countLitPixels();
  }

  final answerPart2 = image.countLitPixels();

  print('    Part 1: $answerPart1');
  print('    Part 2: $answerPart2');

}

typedef Matrix = List<MatrixRow>;
typedef MatrixRow = List<String>;

extension MatrixExtensions on Matrix {
  void prettyPrint() {
    for (int y = 0; y < length; y++) {
      print(this[y].map((e) => (e == '.') ? '🌑' : '🌕').toList().join(''));
    }
    print('');
  }

  void simplePrint() {
    for (int y = 0; y < length; y++) {
      print(this[y].join(''));
    }
    print('');
  }

  void padWithRowsAndColumns(String padChar) {
    final padCharList = [padChar,padChar, padChar];
    for (int i = 0; i < length; i++) {
      this[i] = [...padCharList, ...this[i], ...padCharList];
    }
    insert(0, List.generate(this[0].length, (index) => padChar));
    insert(0, List.generate(this[0].length, (index) => padChar));
    insert(0, List.generate(this[0].length, (index) => padChar));
    add(List.generate(this[0].length, (index) => padChar));
    add(List.generate(this[0].length, (index) => padChar));
    add(List.generate(this[0].length, (index) => padChar));
  }

  int toAlgorithmIndex(int row, int column) {
    var result = '';
    result += this[row - 1].skip(column - 1).take(3).toList().join('');
    result += this[row].skip(column - 1).take(3).toList().join('');
    result += this[row + 1].skip(column - 1).take(3).toList().join('');
    result = result.replaceAll('.', '0').replaceAll('#', '1');
    return result.binaryToInt();
  }

  List<List<String>> copy() {
    final copy = List.generate(
        length, (index) => List.generate(this[0].length, (index) => '.'));
    for (int i = 0; i < length; i++) {
      for (int j = 0; j < this[0].length; j++) {
        copy[i][j] = this[i][j];
      }
    }
    return copy;
  }

  List<List<String>> enhance(String algorithm, String padChar) {
    final image = copy();
    image.padWithRowsAndColumns(padChar);
    final newImage = List.generate(image.length,
            (index) => List.generate(image[0].length, (index) => padChar));
    for (int i = 1; i < image.length - 1; i++) {
      for (int j = 1; j < image[0].length - 1; j++) {
        final binaryNumber = image.toAlgorithmIndex(i, j);
        if (algorithm[binaryNumber] == '#') {
          newImage[i][j] = '#';
        } else {
          newImage[i][j] = '.';
        }
      }
    }

    final strippedImage = newImage.skip(2).take(newImage.length-4).toList();
    for(int i=0; i < strippedImage.length; i++) {
      strippedImage[i] = strippedImage[i].skip(2).take(strippedImage[i].length-4).toList();
    }

    return strippedImage;
  }
  
  int countLitPixels() => fold<int>(
      0,
          (previousValue, row) =>
      previousValue +
          row.fold<int>(
              0,
                  (previousValue, element) =>
              previousValue + ((element == '#') ? 1 : 0)));
}

extension on String {
  int binaryToInt() {
    var result = 0;
    for (int i = 0; i < length; i++) {
      final bit = int.parse(substring(length - i - 1, length - i));
      result += (bit * pow(2, i)) as int;
    }
    return result;
  }
}

