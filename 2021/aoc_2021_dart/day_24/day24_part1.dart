// https://adventofcode.com/2021/day/24
import 'dart:io';

void main() {
  print('--- Day 24: Arithmetic Logic Unit ---');

  final operations = File('input.txt')
      .readAsLinesSync();
  final optimizedOperations = File('input-optimized.txt')
      .readAsLinesSync();

  // m[2]  == m[3] + 7
  // m[6]  == m[7] + 5
  // m[9]  == m[8] + 7
  // m[5]  == m[10] + 6
  // m[11] == m[1] + 3
  // m[12] == m[1] + 3
  //               01234567890123
  final modelNo = '96929994293996';
  var m = modelNo.split('').map(int.parse).toList();
  var z = pureCalculation(m, true);
  print('part 1 z-calculated:${z}');
  print('');

  //                       01234567890123
  final smallestModelNo = '41811761181141';
  m = smallestModelNo.split('').map(int.parse).toList();
  z = pureCalculation(m, true);
  print('part 2 z-calculated:${z}');

//  for (int i = 11111111111111; i < 99999999999999; i += 1442968193) {
//   for (int i = 99999999999999; i > 11111111111111; i--) {
//     final modelNo = i.toString();
//     if (isValidMonad(modelNo)) {
//       // var alu = ALU()..execute(operations, modelNo, false);
//       // var aluOptimized = ALU()..execute(optimizedOperations, modelNo, false);
//       var m = modelNo.split('').map(int.parse).toList();
//       if (m[2] != m[3] + 7 || m[6] != m[7] + 5 || m[8] + 7 != m[9] || m[5] != m[10] + 6 || m[11] != m[1] + 3) continue;
//       var zPureCalculation = pureCalculation(m, false);
//       // assert(alu.z == aluOptimized.z);
//       // assert(alu.z == zPureCalculation);
//       print('Z at $i is $zPureCalculation');
//       if (zPureCalculation == 0) {
//         print('The answer is $modelNo');
//         break;
//       }
//     }
//   }

  // Part 2
  final sw = Stopwatch()..start();
  for (int i = 11111111111111; i < 99999999999999; i++) {
    final modelNo = i.toString();
    if (isValidMonad(modelNo)) {
      var m = modelNo.split('').map(int.parse).toList();
      if (m[2] != m[3] + 7 || m[6] != m[7] + 5 || m[8] + 7 != m[9] || m[5] != m[10] + 6 || m[11] != m[1] + 3) continue;
      var zPureCalculation = pureCalculation(m, false);
      if (zPureCalculation == 0) {
        print('The answer to part 2 is $modelNo');
        break;
      }
    }
  }
  print('processing took ${(sw..stop()).elapsedMilliseconds}ms');
}

int pureCalculation(List<int> m, bool debug) {
  var z = 0;
  // --part1--positive:z=m[0]+8
  var z1 = m[0] + 8;
  z = z1;
  if (debug) print('part1 z1=$z');

  // --part2--positive:z=z*26+m[1]+16
  var z2 = z * 26 + m[1] + 16;
  z = z2;
  if (debug) print('part2 z2=$z');

  // --part3--positive:z=z*26+m[2]+4
  var z3 = z * 26 + m[2] + 4;
  z = z3;
  if (debug) print('part3 z3=$z');

  // --part4--complex:z=z~/26*((((z%26)-11) == m[3] ? 0 : 1) * 25 + 1)+((((z%26)-11) == m[3] ? 0 : 1) * (m[3] + 1))
  // z%26 is the remainder of z3: m[2] + 4
  // Found criteria: m[2] + 4 - 11 == m[3]
  // Found criteria: m[2] - 7 == m[3]
  // Found criteria: m[2] == m[3] + 7
  var x = m[2] + 4 - 11 == m[3] ? 0 : 1;
  var z4 = x == 0 ? z2 : z2 * 26 + m[3] + 1;
  // z4 optimized is equal to z2 (z * 26 + m[1] + 16)
  z = z4;
  if (debug) print('part4 z4=$z');

  // --part5--positive:z=z*26+m[4]+13
  var z5 = z * 26 + m[4] + 13;
  z = z5;
  if (debug) print('part5 z5=$z');

  // --part6--positive:z=z*26+m[5]+5
  var z6 = z * 26 + m[5] + 5;
  z = z6;
  if (debug) print('part6 z6=$z');

  // --part7--positive:z=z*26+m[6]
  var z7 = z * 26 + m[6];
  z = z7;
  if (debug) print('part7 z7=$z');

  // --part8--complex:z=z~/26*((((z%26)-5) == m[7] ? 0 : 1) * 25 + 1)+((((z%26)-5) == m[7] ? 0 : 1) * (m[3] + 10))
  // Found criteria: m[6] - 5 == m[7]
  x = m[6] - 5 == m[7] ? 0 : 1;
  var z8 = x == 0 ? z6 : z6 * 26 + m[7] + 10;
  // z8 optimized is z6 (z * 26 + m[5] + 5)
  z = z8;
  if (debug) print('part8 z8=$z');

  // --part9--positive:z=z*26+m[8]+7
  var z9 = z * 26 + m[8] + 7;
  z = z9;
  if (debug) print('part9 z9=$z');

  // --part10--complex: z = z ~/ 26 * ((z%26 == m[9] ? 0 : 1) * 25 + 1)+((z % 26 == m[9] ? 0 : 1) * (m[9] + 2))
  // x = z % 26 == m[9] ? 0 : 1;
  // z % 26 => (z * 26 + m[8] + 7) % 26 => m[8] + 7
  // New criteria: m[8] + 7 == m[9]
  x = m[8] + 7 == m[9] ? 0 : 1;
  // z ~/ 26 = z8
  var z10 = x == 0 ? z8 : z8 * 26 + m[9] + 2;
  // z10 optimized is z8, which, optimized is z6 (z * 26 + m[5] + 5)
  z = z10;
  if (debug) print('part10 z10=$z');

  // --part11--complex:z=z~/26*(((z%26 - 11) == m[10] ? 0 : 1)*25 + 1)+(((z%26 - 11) == m[10] ? 0 : 1) * (m[10] + 13))
  // try criteria
  // m[5] + 5 - 11 = m[10]
  // m[5] - 6 = m[10]
  // m[5] == m[10] + 6
  x = ((z % 26) - 11) == m[10] ? 0 : 1;
  var z11 = x == 0 ? (z ~/ 26)  : (z ~/ 26) * 26 + m[10] + 13;
  z = z11;
  if (debug) print('part11 z11=$z');

  // --part12--complex:z=z~/26*(((z%26 - 13) == m[11] ? 0 : 1)*25 + 1)+(((z%26 - 13) == m[11] ? 0 : 1) * (m[11] + 15))
  // try criteria
  // m[1] + 16 - 13 = m[11]
  // m[1] + 3 = m[11]
  x = (z % 26) - 13 == m[11] ? 0 : 1;
  // z ~/ 26 optimized is z2 (z * 26 + m[1] + 16)
  var z12 = x == 0 ? (z ~/ 26) : (z ~/ 26) * 26 + m[11] + 15;
  z = z12;
  if (debug) print('part12 z12=$z');

  // --part13--complex:z=z~/26*(((z%26 - 13) == m[12] ? 0 : 1)*25 + 1)+(((z%26 - 13) == m[12] ? 0 : 1) * (m[12] + 14))
  x = (z % 26) - 13 == m[12] ? 0 : 1;
  var z13 = x == 0 ? (z ~/ 26) : (z ~/ 26) * 26 + m[12] + 14;
  z = z13;
  if (debug) print('part13 z13=$z');

  // --part14--complex:z=z~/26*(((z%26 - 11) == m[13] ? 0 : 1)*25 + 1)+(((z%26 - 13) == m[13] ? 0 : 1) * (m[13] + 9))
  // m[0] = m[13] + 3
  x = (z % 26) - 11 == m[13] ? 0 : 1;
  var z14 = x == 0 ? (z ~/ 26) : (z ~/ 26) * 26 + m[13] + 9;
  z = z14;
  if (debug) print('part14 z14=$z');
  return z;
}

bool isValidMonad(String modelNo) => RegExp(r'[1-9]{14}').hasMatch(modelNo);

typedef Operation = Function(Function(int), int Function(), int Function());

// inp a - Read an input value and write it to variable a.
final input = (Function(int) result, int Function() read) => result(read());

// add a b - Add the value of a to the value of b, then store the result in variable a.
final add = (Function(int) result, int Function() op1, int Function() op2) =>
    result(op1() + op2());

// mul a b - Multiply the value of a by the value of b, then store the result in variable a.
final mul = (Function(int) result, int Function() op1, int Function() op2) =>
    result(op1() * op2());

// div a b - Divide the value of a by the value of b, truncate the result to an integer, then store the result in variable a. (Here, "truncate" means to round the value toward zero.)
final div = (Function(int) result, int Function() op1, int Function() op2) =>
    result(op1() ~/ op2());

// mod a b - Divide the value of a by the value of b, then store the remainder in variable a. (This is also called the modulo operation.)
final mod = (Function(int) result, int Function() op1, int Function() op2) =>
    result(op1() % op2());

// eql a b - If the value of a and b are equal, then store the value 1 in variable a. Otherwise, store the value 0 in variable a.
final eql = (Function(int) result, int Function() op1, int Function() op2) =>
    result(op1() == op2() ? 1 : 0);

typedef Program = List<Operation>;

enum Command { inp, add, mul, div, mod, eql }

class ALU {
  var w = 0;
  var x = 0;
  var y = 0;
  var z = 0;

  int Function() readW() => () => w;

  int Function() readX() => () => x;

  int Function() readY() => () => y;

  int Function() readZ() => () => z;

  Function(int) writeW() => (int value) => w = value;

  Function(int) writeX() => (int value) => x = value;

  Function(int) writeY() => (int value) => y = value;

  Function(int) writeZ() => (int value) => z = value;

  void execute(List<String> operations, String monad, bool debug) {
    var monadIndex = 0;
    operations.forEach((line) {
      if (!line.startsWith('--')) {
        final parts = line.split(' ');
        if (parts[0] == 'inp') {
          input(writeFn(parts[1]), () => int.parse(monad[monadIndex++]));
        } else if (parts[0] == 'add') {
          add(writeFn(parts[1]), readFn(parts[1]), readFn(parts[2]));
        } else if (parts[0] == 'mul') {
          mul(writeFn(parts[1]), readFn(parts[1]), readFn(parts[2]));
        } else if (parts[0] == 'div') {
          div(writeFn(parts[1]), readFn(parts[1]), readFn(parts[2]));
        } else if (parts[0] == 'mod') {
          mod(writeFn(parts[1]), readFn(parts[1]), readFn(parts[2]));
        } else if (parts[0] == 'eql') {
          eql(writeFn(parts[1]), readFn(parts[1]), readFn(parts[2]));
        }
        if (debug) print('${parts.join(' ')} -> $this');
      } else {
        if (debug) print(line);
      }
    });
  }

  int Function() readFn(String s) {
    switch (s) {
      case 'w':
        return readW();
      case 'x':
        return readX();
      case 'y':
        return readY();
      case 'z':
        return readZ();
    }
    return () => int.parse(s);
  }

  Function(int) writeFn(String s) {
    switch (s) {
      case 'w':
        return writeW();
      case 'x':
        return writeX();
      case 'y':
        return writeY();
    }
    return writeZ();
  }

  @override
  String toString() => '[w:$w, x:$x, y:$y, z:$z]';
}
