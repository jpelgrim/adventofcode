// https://adventofcode.com/2021/day/10
import 'dart:collection';
import 'dart:io';

void main() {
  print('--- Day 10: Syntax Scoring ---');

  var answer = 0;
  File('input.txt').readAsLinesSync().forEach((line) {
    final closeChar = line.firstOffendingCloseChar();
    if (closeChar != null) {
      answer += closeChar.value();
    }
  });

  print('    Part 1: $answer');
}

extension on String {
  String? firstOffendingCloseChar() {
    final stack = Queue<String>();
    var chars = split('');
    for (int i = 0; i < chars.length; i++) {
      if (chars[i].isOpenChar()) {
        stack.add(chars[i]);
      } else if (chars[i].matchesOpenChar(stack.last)) {
        stack.removeLast();
      } else {
        return chars[i];
      }
    }
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
    throw Exception('Illegal open character $openChar found');
  }

  // ): 3 points.
  // ]: 57 points.
  // }: 1197 points.
  // >: 25137 points.
  int value() {
    switch (this) {
      case ')':
        return 3;
      case ']':
        return 57;
      case '}':
        return 1197;
      case '>':
        return 25137;
    }
    throw Exception('Illegal close character $this found');
  }
}
