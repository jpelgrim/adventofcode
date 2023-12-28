// https://adventofcode.com/2021/day/10
import 'dart:collection';
import 'dart:io';

void main() {
  List<int> scores = List.empty(growable: true);
  File('input.txt').readAsLinesSync().forEach((line) {
    try {
      final stack = line.openStack();
      List<String> incompleteSequence = stack.findCompleteSequence();
      scores.add(incompleteSequence.value());
    } catch (ignore) {
      // ignore
    }
  });

  scores.sort();

  print('    Part 2: ${scores[scores.length ~/ 2]}');
}

extension on List<String> {
  int value() =>
      fold(0, (previousValue, char) => previousValue * 5 + char.value());
}

extension on Queue<String> {
  List<String> findCompleteSequence() {
    final completeSequence = List<String>.empty(growable: true);
    do {
      completeSequence.add(removeLast().matchingCloseChar());
    } while (!isEmpty);
    return completeSequence;
  }
}

extension on String {
  Queue<String> openStack() {
    final stack = Queue<String>();
    var chars = split('');
    for (int i = 0; i < chars.length; i++) {
      if (chars[i].isOpenChar()) {
        stack.add(chars[i]);
      } else if (chars[i].matchesOpenChar(stack.last)) {
        stack.removeLast();
      } else {
        throw Exception('Offending char found');
      }
    }
    return stack;
  }

  bool isOpenChar() => ['(', '{', '[', '<'].contains(this);

  bool matchesOpenChar(String openChar) {
    switch (openChar) {
      case '(':
        return this == ')';
      case '[':
        return this == ']';
      case '{':
        return this == '}';
      case '<':
        return this == '>';
    }
    return false;
  }

  String matchingCloseChar() {
    switch (this) {
      case '(':
        return ')';
      case '[':
        return ']';
      case '{':
        return '}';
      case '<':
        return '>';
    }
    throw Exception('Illegal open char $this found');
  }

  // ): 1 point.
  // ]: 2 points.
  // }: 3 points.
  // >: 4 points.
  int value() {
    switch (this) {
      case ')':
        return 1;
      case ']':
        return 2;
      case '}':
        return 3;
      case '>':
        return 4;
    }
    throw Exception('Illegal open char $this found');
  }
}
