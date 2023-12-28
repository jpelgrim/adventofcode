// https://adventofcode.com/2021/day/21
import 'dart:math';

void main() {
  final sw = Stopwatch()..start();
  final game = Game(Player(2, 0), Player(5, 0), 0);

  final gamesInProgress = <Game, int>{};
  gamesInProgress[game] = 1;
  var p1Winners = 0;
  var p2Winners = 0;
  do {
    final games = Map<Game, int>.from(gamesInProgress);
    gamesInProgress.clear();
    games.entries.forEach((entry) {
      final previousNrOfGames = entry.value;
      var newGames = entry.key.rollDice();
      newGames.forEach((newGame) {
        if (newGame.winnerP1()) {
          p1Winners += previousNrOfGames;
        } else if (newGame.winnerP2()) {
          p2Winners += previousNrOfGames;
        } else {
          gamesInProgress[newGame] = (gamesInProgress[newGame] ?? 0) + previousNrOfGames;
        }
      });
    });
  } while (gamesInProgress.isNotEmpty);

  print('    Part 2: ${max(p1Winners, p2Winners)}');
}

class Player {
  Player(this.position, this.score);

  final int position;
  final int score;

  @override
  operator ==(o) => o is Player && o.position == position && o.score == score;

  @override
  int get hashCode => Object.hash(position, score);


  Player move(int steps) {
    var _position = (position + steps) % 10;
    if (_position == 0) _position = 10;
    return Player(_position, score + _position);
  }

  @override
  String toString() => '$position-$score';
}

class Game {
  Game(this.p1, this.p2, this.turn);

  final int turn;
  final Player p1;
  final Player p2;

  List<Game> rollDice() {
    if (turn == 0) {
      return [
        Game(p1.move(3), p2, 1),
        ...List.generate(3, (index) => Game(p1.move(4), p2, 1)),
        ...List.generate(6, (index) => Game(p1.move(5), p2, 1)),
        ...List.generate(7, (index) => Game(p1.move(6), p2, 1)),
        ...List.generate(6, (index) => Game(p1.move(7), p2, 1)),
        ...List.generate(3, (index) => Game(p1.move(8), p2, 1)),
        Game(p1.move(9), p2, 1),
      ];
    } else {
      return [
        Game(p1, p2.move(3), 0),
        ...List.generate(3, (index) => Game(p1, p2.move(4), 0)),
        ...List.generate(6, (index) => Game(p1, p2.move(5), 0)),
        ...List.generate(7, (index) => Game(p1, p2.move(6), 0)),
        ...List.generate(6, (index) => Game(p1, p2.move(7), 0)),
        ...List.generate(3, (index) => Game(p1, p2.move(8), 0)),
        Game(p1, p2.move(9), 0),
      ];
    }
  }

  @override
  operator ==(o) => o is Game && o.p1 == p1 && o.p2 == p2 && o.turn == turn;

  @override
  int get hashCode => Object.hash(p1, p2, turn);

  @override
  String toString() => '$p1-$p2-$turn}';

  bool hasWinner() => winnerP1() || winnerP2();

  bool winnerP1() => p1.score >= 21 && p2.score < 21;

  bool winnerP2() => p2.score >= 21 && p1.score < 21;
}
