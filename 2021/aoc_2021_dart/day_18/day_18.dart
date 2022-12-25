// https://adventofcode.com/2021/day/18
import 'dart:io';

void main() {
  print('--- Day 18: Snailfish ---');

  runTests();

  var lines = File('input.txt').readAsLinesSync();

  var answerPart1 = lines.calculateMagnitude();
  var answerPart2 = lines.findBiggestMagnitudeSum();
  print('    Part 1: ${answerPart1}');
  print('    Part 2: ${answerPart2}');
}

void runTests() {
  // Add snailfish numbers
  assert('[[[[4,3],4],4],[7,[[8,4],9]]]'.addSnailfish('[1,1]') ==
      '[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]');

  // Should explode
  assert('[[[[[9,8],1],2],3],4]'.findExplodingPairIndex() == 4);
  assert('[7,[6,[5,[4,[3,2]]]]]'.findExplodingPairIndex() == 12);
  assert('[[6,[5,[4,[3,2]]]],1]'.findExplodingPairIndex() == 10);
  assert(
      '[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]'.findExplodingPairIndex() == 10);
  assert('[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]'.findExplodingPairIndex() == 24);

  // Check if a snailfish has large numbers
  assert('[[[[0,7],4],[15,[0,13]]],[1,1]]'.findLargeNumber() == 15);
  assert('[[[[0,7],4],[[7,8],[0,13]]],[1,1]]'.findLargeNumber() == 13);
  assert('[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]'.findLargeNumber() == -1);
  assert('[[[[0,7],4],[[7,8],[6,0]]],[8,1]]'.findLargeNumber() == -1);
  assert('[[[[4,0],[5,4]],[[7,0],[15,5]]],[10,[[11,9],[11,0]]]]'
          .findLargeNumber() ==
      15);

  // Explode snailfish numbers
  assert('[[[[[9,18],1],2],3],4]'.explode(4) == '[[[[0,19],2],3],4]');
  assert('[7,[6,[5,[4,[33,2]]]]]'.explode(12) == '[7,[6,[5,[37,0]]]]');
  assert('[[6,[5,[4,[73,92]]]],1]'.explode(10) == '[[6,[5,[77,0]]],93]');
  assert('[[3,[2,[1,[17,33]]]],[6,[5,[4,[3,2]]]]]'.explode(10) ==
      '[[3,[2,[18,0]]],[39,[5,[4,[3,2]]]]]');
  assert('[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]'.explode(24) ==
      '[[3,[2,[8,0]]],[9,[5,[7,0]]]]');
  assert(
      '[[[[4,0],[5,4]],[[7,7],[0,[6,7]]]],[10,[[11,9],[11,0]]]]'.explode(26) ==
          '[[[[4,0],[5,4]],[[7,7],[6,0]]],[17,[[11,9],[11,0]]]]');
  assert('[[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]],[[[5,[2,8]],4],[5,[[9,9],0]]]]'
          .explode(6) ==
      '[[[[5,0],[[9,7],[9,6]]],[[4,[1,2]],[[1,4],2]]],[[[5,[2,8]],4],[5,[[9,9],0]]]]');

  // Split tests
  assert('[[[[4,0],[5,4]],[[7,0],[15,5]]],[10,[[11,9],[11,0]]]]'.zplit(15) ==
      '[[[[4,0],[5,4]],[[7,0],[[7,8],5]]],[10,[[11,9],[11,0]]]]');
  assert('[[[[4,0],[5,4]],[[7,0],[10,5]]],[10,[[11,9],[11,0]]]]'.zplit(10) ==
      '[[[[4,0],[5,4]],[[7,0],[[5,5],5]]],[10,[[11,9],[11,0]]]]');
  assert('[[[[4,0],[5,4]],[[7,0],[[5,5],5]]],[10,[[11,9],[11,0]]]]'.zplit(10) ==
      '[[[[4,0],[5,4]],[[7,0],[[5,5],5]]],[[5,5],[[11,9],[11,0]]]]');
  assert(
      '[[[[4,0],[5,4]],[[7,0],[[5,5],5]]],[[5,5],[[11,9],[11,0]]]]'.zplit(11) ==
          '[[[[4,0],[5,4]],[[7,0],[[5,5],5]]],[[5,5],[[[5,6],9],[11,0]]]]');

  // Check if a snailfish number is reduced
  assert('[[[[0,9],2],3],4]'.isReduced());
  assert('[7,[6,[5,[7,0]]]]'.isReduced());
  assert('[[6,[5,[7,0]]],3]'.isReduced());
  assert(!'[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]'.isReduced());
  assert('[[3,[2,[8,0]]],[9,[5,[7,0]]]]'.isReduced());

  // Magnitude tests
  assert('[[1,2],[[3,4],5]]'.magnitude() == 143);
  assert('[[[[0,7],4],[[7,8],[6,0]]],[8,1]]'.magnitude() == 1384);
  assert('[[[[1,1],[2,2]],[3,3]],[4,4]]'.magnitude() == 445);
  assert('[[[[3,0],[5,3]],[4,4]],[5,5]]'.magnitude() == 791);
  assert('[[[[5,0],[7,4]],[5,5]],[6,6]]'.magnitude() == 1137);
  assert('[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]'.magnitude() ==
      3488);
  assert('[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]'
          .magnitude() ==
      4140);

  // Doing a failing step manually to find the error 🙄
  assert('[[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]],[2,9]]'
          .findExplodingPairIndex() ==
      4);
  assert('[[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]],[2,9]]'
          .explode(4) ==
      '[[[[0,[12,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]],[2,9]]');
  assert('[[[[0,[12,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]],[2,9]]'
          .findExplodingPairIndex() ==
      6);
  assert('[[[[0,[12,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]],[2,9]]'
          .explode(6) ==
      '[[[[12,0],[[12,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]],[2,9]]');
  assert('[[[[12,0],[[12,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]],[2,9]]'
          .findExplodingPairIndex() ==
      11);
  assert('[[[[12,0],[[12,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]],[2,9]]'
          .explode(11) ==
      '[[[[12,12],[0,[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]],[2,9]]');
  assert('[[[[12,12],[0,[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]],[2,9]]'
          .findExplodingPairIndex() ==
      14);
  assert(
      '[[[[12,12],[0,[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]],[2,9]]'.explode(14) ==
          '[[[[12,12],[6,0]],[[[14,7],[8,9]],[8,[8,1]]]],[2,9]]');
  assert('[[[[12,12],[6,0]],[[[14,7],[8,9]],[8,[8,1]]]],[2,9]]'
          .findExplodingPairIndex() ==
      20);
  assert('[[[[12,12],[6,0]],[[[14,7],[8,9]],[8,[8,1]]]],[2,9]]'.explode(20) ==
      '[[[[12,12],[6,14]],[[0,[15,9]],[8,[8,1]]]],[2,9]]');
  assert('[[[[12,12],[6,14]],[[0,[15,9]],[8,[8,1]]]],[2,9]]'
          .findExplodingPairIndex() ==
      23);
  assert('[[[[12,12],[6,14]],[[0,[15,9]],[8,[8,1]]]],[2,9]]'.explode(23) ==
      '[[[[12,12],[6,14]],[[15,0],[17,[8,1]]]],[2,9]]');
  assert('[[[[12,12],[6,14]],[[15,0],[17,[8,1]]]],[2,9]]'
          .findExplodingPairIndex() ==
      31);
  assert('[[[[12,12],[6,14]],[[15,0],[17,[8,1]]]],[2,9]]'.explode(31) ==
      '[[[[12,12],[6,14]],[[15,0],[25,0]]],[3,9]]');

  assert('[[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]],[2,9]]'
          .reducto() ==
      '[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]');
}

extension on String {
  // To reduce a snailfish number, you must repeatedly do the first action in
  // this list that applies to the snailfish number:
  //
  // If any pair is nested inside four pairs, the leftmost such pair explodes.
  // If any regular number is 10 or greater, the leftmost such regular number
  // splits.
  // Once no action in the above list applies, the snailfish number is reduced.
  //
  // During reduction, at most one action applies, after which the process
  // returns to the top of the list of actions. For example, if split produces
  // a pair that meets the explode criteria, that pair explodes before other
  // splits occur.
  //
  //
  // Here is the process of finding the reduced result of
  // [[[[4,3],4],4],[7,[[8,4],9]]] + [1,1]:
  //
  // after addition: [[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]
  // after explode:  [[[[0,7],4],[7,[[8,4],9]]],[1,1]]
  // after explode:  [[[[0,7],4],[15,[0,13]]],[1,1]]
  // after split:    [[[[0,7],4],[[7,8],[0,13]]],[1,1]]
  // after split:    [[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]
  // after explode:  [[[[0,7],4],[[7,8],[6,0]]],[8,1]]
  // Once no reduce actions apply, the snailfish number that remains is the
  // actual result of the addition operation: [[[[0,7],4],[[7,8],[6,0]]],[8,1]].
  String reducto() {
    if (isReduced()) {
      return this;
    }
    String result = this;
    do {
      var explodingPairIndex = result.findExplodingPairIndex();
      if (explodingPairIndex > 0) {
        result = result.explode(explodingPairIndex);
        //print('after explode:  $result');
      } else {
        var largeNumber = result.findLargeNumber();
        result = result.zplit(largeNumber);
        //print('after split:    $result');
      }
    } while (!result.isReduced());
    //print('reduced to:     $result');
    return result;
  }

  // To explode a pair, the pair's left value is added to the first regular
  // number to the left of the exploding pair (if any), and the pair's right
  // value is added to the first regular number to the right of the exploding
  // pair (if any). Exploding pairs will always consist of two regular numbers.
  // Then, the entire exploding pair is replaced with the regular number 0.
  //
  // Here are some examples of a single explode action:
  //
  // [[[[[9,8],1],2],3],4] becomes [[[[0,9],2],3],4] (the 9 has no regular
  // number to its left, so it is not added to any regular number).
  //
  // [7,[6,[5,[4,[3,2]]]]] becomes [7,[6,[5,[7,0]]]] (the 2 has no regular
  // number to its right, and so it is not added to any regular number).
  //
  // [[6,[5,[4,[3,2]]]],1] becomes [[6,[5,[7,0]]],3].
  //
  // [[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]] becomes
  // [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]] (the pair [3,2] is unaffected because
  // the pair [7,3] is further to the left; [3,2] would explode on the next
  // action).
  //
  // [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]] becomes [[3,[2,[8,0]]],[9,[5,[7,0]]]].
  String explode(int leftIndex) {
    final explodingInfo = findExplodingInfo(leftIndex);
    var firstHalf =
        substring(0, explodingInfo[0]).addToLastNumber(explodingInfo[2]);
    var lastHalf =
        substring(explodingInfo[1] + 1).addToFirstNumber(explodingInfo[3]);
    return '${firstHalf}0${lastHalf}';
  }

  // [[[[12,12],[6,14]],[[15,0],[17,
  String addToLastNumber(int number) {
    var lastNumberIndex = this.lastIndexOf(RegExp(r'[^\d](\d+)'));
    if (lastNumberIndex > -1) {
      lastNumberIndex++;
      var lastNotNumberIndex =
          this.substring(lastNumberIndex).indexOf(RegExp(r'[^\d]')) +
              lastNumberIndex;
      return '${substring(0, lastNumberIndex)}${int.parse(substring(lastNumberIndex, lastNotNumberIndex)) + number}${substring(lastNotNumberIndex)}';
    }
    return this;
  }

  String addToFirstNumber(int number) {
    var firstNumberIndex = this.indexOf(RegExp(r'[^\d](\d+)'));
    if (firstNumberIndex > -1) {
      firstNumberIndex++;
      var firstNotNumberIndex =
          this.substring(firstNumberIndex).indexOf(RegExp(r'[^\d]')) +
              firstNumberIndex;
      return '${substring(0, firstNumberIndex)}${int.parse(substring(firstNumberIndex, firstNotNumberIndex)) + number}${substring(firstNotNumberIndex)}';
    }
    return this;
  }

  // Returns the following information in a list of ints
  // 0: The index of the exploding pairs open character '['
  // 1: The index of the exploding pairs closing character ']'
  // 2: The first number of the pair
  // 3: The second number of the exploding pair
  List<int> findExplodingInfo(int leftIndex) {
    int rightIndex = -1;
    var numberPair = <int>[];
    for (int j = leftIndex; j < length; j++) {
      if (']' == this[j]) {
        rightIndex = j;
        break;
      }
    }
    numberPair = substring(leftIndex + 1, rightIndex)
        .split(',')
        .map((e) => int.parse(e))
        .toList();
    if (rightIndex == -1 || numberPair.isEmpty) {
      throw Exception('Sumtin unexpected happened');
    }
    return [leftIndex, rightIndex, ...numberPair];
  }

  // Checks if a snailfish number has an exploding pair and returns the index of
  // the open bracket
  int findExplodingPairIndex() {
    int openBracketCount = 0;
    for (int i = 0; i < length; i++) {
      if ('[' == this[i]) openBracketCount++;
      if (']' == this[i]) openBracketCount--;
      if (openBracketCount == 5) {
        return i;
      }
    }
    return -1;
  }

  // To split a regular number, replace it with a pair; the left element of the
  // pair should be the regular number divided by two and rounded down, while
  // the right element of the pair should be the regular number divided by two
  // and rounded up. For example, 10 becomes [5,5], 11 becomes [5,6], 12 becomes
  // [6,6], and so on.
  String zplit(int largeNumber) {
    int left = largeNumber ~/ 2;
    int right = largeNumber - left;
    return replaceFirst('$largeNumber', '[$left,$right]');
  }

  // If there are any numbers > 10 the snailfish number should be split
  int findLargeNumber() => replaceAll('[', '')
      .replaceAll(']', '')
      .split(',')
      .map((e) => int.parse(e))
      .firstWhere((e) => e > 9, orElse: () => -1);

  bool isReduced() => findExplodingPairIndex() == -1 && findLargeNumber() == -1;

  // The magnitude of a pair is 3 times the magnitude of its left element plus 2
  // times the magnitude of its right element. The magnitude of a regular number
  // is just that number.
  //
  // For example,
  // the magnitude of [9,1] is 3*9 + 2*1 = 29;
  // the magnitude of [1,9] is 3*1 + 2*9 = 21.
  //
  // Magnitude calculations are recursive:
  // the magnitude of [[9,1],[1,9]] is 3*29 + 2*21 = 129.
  int magnitude() {
    var noOuterBrackets = substring(1, length - 1);
    final separatorIndex =
        noOuterBrackets.findIndexOfFirstCommaOutsideBrackets();
    final left = noOuterBrackets.substring(0, separatorIndex);
    final right = noOuterBrackets.substring(separatorIndex + 1);
    final leftMagnitude = left.length == 1 ? int.parse(left) : left.magnitude();
    final rightMagnitude =
        right.length == 1 ? int.parse(right) : right.magnitude();
    return leftMagnitude * 3 + rightMagnitude * 2;
  }

  int findIndexOfFirstCommaOutsideBrackets() {
    int bracketCount = 0;
    for (int i = 0; i < length; i++) {
      if ('[' == this[i]) bracketCount++;
      if (']' == this[i]) bracketCount--;
      if (',' == this[i] && bracketCount == 0) return i;
    }
    throw Exception('Hmm... something fishy happened');
  }

  String addSnailfish(String snailfishNumber) => '[$this,$snailfishNumber]';
}

extension on List<String> {
  int calculateMagnitude() {
    String result = '';
    for (int i = 0; i < length; i++) {
      if (result.isEmpty) {
        result = this[i];
        continue;
      }
      //print('  $result');
      //print('+ ${this[i]}');

      result = result.addSnailfish(this[i]);
      //print('after addition: $result');
      result = result.reducto();

      //print('= $result');
      //print('');
    }
    return result.magnitude();
  }

  int findBiggestMagnitudeSum() {
    var maxMagnitude = 0;
    for (int i = 0; i < length; i++) {
      final op1 = this[i];
      for (int j = 0; j < length; j++) {
        if (i == j) continue;
        var op2 = op1.addSnailfish(this[j]);
        op2 = op2.reducto();
        final magnitude = op2.magnitude();
        if (magnitude > maxMagnitude) {
          maxMagnitude = magnitude;
        }
      }
    }
    return maxMagnitude;
  }
}
