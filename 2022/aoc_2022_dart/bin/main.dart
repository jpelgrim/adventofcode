import 'package:aoc2022/day1/main.dart' as day1;
import 'package:aoc2022/day2/main.dart' as day2;
import 'package:aoc2022/day3/main.dart' as day3;
import 'package:aoc2022/day4/main.dart' as day4;
import 'package:aoc2022/day5/main.dart' as day5;
import 'package:aoc2022/day6/main.dart' as day6;
import 'package:aoc2022/day7/main.dart' as day7;
import 'package:aoc2022/day8/main.dart' as day8;
import 'package:aoc2022/day9/main.dart' as day9;
import 'package:aoc2022/day10/main.dart' as day10;
import 'package:aoc2022/day11/main.dart' as day11;
import 'package:aoc2022/day12/main.dart' as day12;
import 'package:aoc2022/day13/main.dart' as day13;
import 'package:aoc2022/day14/main.dart' as day14;
import 'package:aoc2022/day15/main.dart' as day15;
import 'package:aoc2022/day16/main.dart' as day16;
import 'package:aoc2022/day17/main.dart' as day17;
import 'package:aoc2022/day18/main.dart' as day18;
import 'package:aoc2022/day19/main.dart' as day19;
import 'package:aoc2022/day20/main.dart' as day20;
import 'package:aoc2022/day21/main.dart' as day21;
import 'package:aoc2022/day22/main.dart' as day22;
import 'package:aoc2022/day23/main.dart' as day23;
import 'package:aoc2022/day24/main.dart' as day24;

final allDaysMainMethods = [
  day1.main,
  day2.main,
  day3.main,
  day4.main,
  day5.main,
  day6.main,
  day7.main,
  day8.main,
  day9.main,
  day10.main,
  day11.main,
  day12.main,
  day13.main,
  day14.main,
  day15.main,
  day16.main,
  day17.main,
  day18.main,
  day19.main,
  day20.main,
  day21.main,
  day22.main,
  day23.main,
  day24.main,
];

void main(List<String> args) {
  final sw = Stopwatch();
  sw.start();
  for (var i = 1; i <= allDaysMainMethods.length; i++) {
    final start = sw.elapsedMicroseconds;
    allDaysMainMethods[i-1](['./lib/day$i/input.txt']);
    final end = sw.elapsedMicroseconds;
    if (end - start > 3000000) {
      var seconds = (end - start) ~/ 1000000;
      if (seconds > 60) {
        var minutes = seconds ~/ 60;
        seconds = seconds - minutes * 60;
        print('    Time  : ${minutes}m${seconds}s\n');
      } else {
        print('    Time  : ${seconds}s\n');
      }
    } else if (end - start > 1000) {
      print('    Time  : ${(end - start) / 1000}ms\n');
    } else {
      print('    Time  : ${end - start}μs\n');
    }
  }
  var totalTime = sw.elapsedMilliseconds;
  var minutes = totalTime ~/ 60000;
  print('Total processing time: ${minutes}m${(totalTime ~/ 1000) - 60 * minutes}s');
  print('Average processing time: ${totalTime ~/ (allDaysMainMethods.length * 1000)}s');
}