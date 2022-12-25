// https://adventofcode.com/2021/day/21
import 'dart:math';

void main() {
  print('--- Day 21: Dirac Dice ---');

  final player1 = Player(2, 0);
  final player2 = Player(5, 0);
  final players = [player1, player2];
  final dice = DeterministicDice();

  int turn = 0;
  do {
    final player = players[turn];
    player.add(dice.rollTimes(3));
    turn = (turn + 1) % 2;
  } while (player1.score < 1000 && player2.score < 1000);

  final answer = dice.nrOfRolls * min(player1.score, player2.score);

  print('    Part 1: $answer');
}

class Player {
  Player(this.position, this.score);

  int position;
  int score;

  void add(int moves) {
    position = (position + moves) % 10;
    if (position == 0) position = 10;
    score += position;
  }
}

class DeterministicDice {
  int side = 100;
  int nrOfRolls = 0;

  int roll() {
    nrOfRolls++;
    side = (side + 1) % 100;
    if (side == 0) side = 100;
    return side;
  }

  int rollTimes(int nrOfRolls) {
    var sum = 0;
    for (int i = 0; i < nrOfRolls; i++) {
      sum += roll();
    }
    return sum;
  }
}
