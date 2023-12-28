import 'dart:io';
import 'dart:math';

import 'block.dart';
import 'game.dart';

void main(List<String> args) {
  print('--- Day 17: Pyroclastic Flow ---');

  final filename = args.isNotEmpty ? args[0] : './lib/day17/input.txt';
  final moves = File(filename).readAsStringSync().split('');

  List<Block> blocks = [
    // @@@@
    Block([
      Point(0, 0),
      Point(1, 0),
      Point(2, 0),
      Point(3, 0),
    ]),
    //  @
    // @@@
    //  @
    Block([
      Point(1, 0),
      Point(0, 1),
      Point(1, 1),
      Point(2, 1),
      Point(1, 2),
    ]),
    //   @
    //   @
    // @@@
    Block([Point(0, 0), Point(1, 0), Point(2, 0), Point(2, 1), Point(2, 2)]),
    // @
    // @
    // @
    // @
    Block([Point(0, 0), Point(0, 1), Point(0, 2), Point(0, 3)]),
    // @@
    // @@
    Block([Point(0, 0), Point(1, 0), Point(0, 1), Point(1, 1)]),
  ];

  final part1 = runGame(moves, blocks, 2022);
  print('    Part 1: $part1');

  final part2 = runGame(moves, blocks, 1000000000000);
  print('    Part 2: $part2');
}

runGame(List<String> moves, List<Block> blocks, int targetBlockCount) {

  var extraBlockCount = 0;
  var extraTopCount = 0;

  var blockCount = 0;
  var stepCount = 0;
  var repeatPatternFound = false;
  var blockPatterns = <int, List<int>>{};
  Game game = Game();
  while(true) {
    if (game.block == null) {
      game.addBlock(blocks[blockCount++ % 5]);
    }
    var nextIndex = stepCount++ % moves.length;
    var nextMove = moves[nextIndex];
    if (nextMove == '<' && game.canMoveLeft()) {
      game.moveLeft();
    } else if (nextMove == '>' && game.canMoveRight()) {
      game.moveRight();
    }
    if (game.canMoveDown()) {
      game.moveDown();
    } else {
      game.freezeBlock();
    }

    if (!repeatPatternFound && game.top > 200 && game.block == null) {
      var key = game.key();
      if (blockPatterns.containsKey(key)) {
        var latestBlockCount = game.blocksAdded;
        var latestTop = game.top;
        var storedInfo = blockPatterns[key]!;
        var previousBlockCount = storedInfo[0];
        var previousTop = storedInfo[1];

        var topDiff = latestTop - previousTop;
        var blockCountDiff = latestBlockCount - previousBlockCount;

        var remainingBlockCount = targetBlockCount - latestBlockCount;
        var multiplier = remainingBlockCount ~/ blockCountDiff;

        extraBlockCount = blockCountDiff * multiplier;
        extraTopCount += topDiff * multiplier;

        repeatPatternFound = true;
      } else {
        blockPatterns[game.key()] = [game.blocksAdded, game.top];
      }
    }

    if (game.blocksAdded + extraBlockCount == targetBlockCount) break;
  }

  return game.top + extraTopCount - 2;

}

