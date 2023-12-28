import 'dart:math';

final _binaryMap = <String, String>{
  '0': '0000',
  '1': '0001',
  '2': '0010',
  '3': '0011',
  '4': '0100',
  '5': '0101',
  '6': '0110',
  '7': '0111',
  '8': '1000',
  '9': '1001',
  'A': '1010',
  'B': '1011',
  'C': '1100',
  'D': '1101',
  'E': '1110',
  'F': '1111',
};

extension BitExtension on String {
  String toBinary() => _binaryMap[this]!;

  int convertBits(int index, int length) =>
      substring(index, index + length).binaryToInt();

  String readBits(int index, int length) => substring(index, index + length);

  int binaryToInt() {
    var result = 0;
    for (int i = 0; i < length; i++) {
      final bit = int.parse(substring(length - i - 1, length - i));
      result += (bit * pow(2, i)) as int;
    }
    return result;
  }

  List<int> sumPacket(int index) {
    var sum = 0;
    var bitsRead = 0;

    int version = convertBits(index, 3);
    index += 3;
    bitsRead += 3;
    sum += version;

    int type = convertBits(index, 3);
    index += 3;
    bitsRead += 3;

    if (type == 4) {
      // Literal value
      var indicator = 0;
      var bitString = '';
      do {
        indicator = convertBits(index, 1);
        index += 1;
        bitsRead += 1;
        bitString = bitString + readBits(index, 4);
        index += 4;
        bitsRead += 4;
      } while (indicator == 1);
      int value = bitString.binaryToInt();
    } else {
      final lengthTypeId = convertBits(index, 1);
      index += 1;
      bitsRead += 1;
      if (lengthTypeId == 0) {
        final length = convertBits(index, 15);
        index += 15;
        bitsRead += 15;
        var bitsLeft = length;
        do {
          final subPacketResult = sumPacket(index);
          sum += subPacketResult[0];
          index += subPacketResult[1];
          bitsRead += subPacketResult[1];
          bitsLeft -= subPacketResult[1];
        } while (bitsLeft > 0);
      } else {
        int nrOfPackets = convertBits(index, 11);
        index += 11;
        bitsRead += 11;
        for (int i = 0; i < nrOfPackets; i++) {
          final subPacketResult = sumPacket(index);
          sum += subPacketResult[0];
          index += subPacketResult[1];
          bitsRead += subPacketResult[1];
        }
      }
    }
    return [sum, bitsRead];
  }

  List<int> evalPacket(int index) {
    var bitsRead = 0;

    int version = convertBits(index, 3);
    index += 3;
    bitsRead += 3;

    int type = convertBits(index, 3);
    index += 3;
    bitsRead += 3;

    if (type == 4) {
      // LITERAL VALUE
      // Encodes a single binary number. To do this, the binary number is padded
      // with leading zeroes until its length is a multiple of four bits, and then
      // it is broken into groups of four bits. Each group is prefixed by a 1 bit
      // except the last group, which is prefixed by a 0 bit. These groups of five
      // bits immediately follow the packet header.
      var indicator = 0;
      var bitString = '';
      do {
        indicator = convertBits(index, 1);
        index += 1;
        bitsRead += 1;
        bitString = bitString + readBits(index, 4);
        index += 4;
        bitsRead += 4;
      } while (indicator == 1);
      int value = bitString.binaryToInt();
      return [value, bitsRead];
    }

    final subPackets = <int>[];

    final lengthTypeId = convertBits(index, 1);
    index += 1;
    bitsRead += 1;
    if (lengthTypeId == 0) {
      final length = convertBits(index, 15);
      index += 15;
      bitsRead += 15;
      var bitsLeft = length;
      do {
        var subPacketResult = evalPacket(index);
        subPackets.add(subPacketResult[0]);
        index += subPacketResult[1];
        bitsRead += subPacketResult[1];
        bitsLeft -= subPacketResult[1];
      } while (bitsLeft > 0);
    } else {
      int nrOfPackets = convertBits(index, 11);
      index += 11;
      bitsRead += 11;
      for (int i = 0; i < nrOfPackets; i++) {
        final subPacketResult = evalPacket(index);
        subPackets.add(subPacketResult[0]);
        index += subPacketResult[1];
        bitsRead += subPacketResult[1];
      }
    }

    if (type == 0) {
      // SUM
      // Their value is the sum of the values of their sub-packets. If they only
      // have a single sub-packet, their value is the value of the sub-packet.
      final value = subPackets.fold<int>(0, (v1, v2) => v1 + v2);
      return [value, bitsRead];
    } else if (type == 1) {
      // PRODUCT
      // Their value is the result of multiplying together the values of their
      // sub-packets. If they only have a single sub-packet, their value is the
      // value of the sub-packet.
      final value = subPackets.fold<int>(1, (v1, v2) => v1 * v2);
      return [value, bitsRead];
    } else if (type == 2) {
      // MINIMUM
      // Their value is the minimum of the values of their sub-packets.
      final value = subPackets.fold<int>(0, (v1, v2) => v1 == 0 || v2 < v1 ? v2 : v1);
      return [value, bitsRead];
    } else if (type == 3) {
      // MAXIMUM
      // Their value is the maximum of the values of their sub-packets.
      final value = subPackets.fold<int>(0, (v1, v2) => v1 == 0 || v2 > v1 ? v2 : v1);
      return [value, bitsRead];
    } else if (type == 5) {
      // GREATER THAN
      // Their value is 1 if the value of the first sub-packet is greater than the
      // value of the second sub-packet; otherwise, their value is 0.
      // These packets always have exactly two sub-packets.
      return [subPackets[0] > subPackets[1] ? 1 : 0, bitsRead];
    } else if (type == 6) {
      // LESS THAN
      // Their value is 1 if the value of the first sub-packet is less than the
      // value of the second sub-packet; otherwise, their value is 0.
      // These packets always have exactly two sub-packets.
      return [subPackets[0] < subPackets[1] ? 1 : 0, bitsRead];
    } else if (type == 7) {
      // EQUAL TO
      // Their value is 1 if the value of the first sub-packet is equal to the
      // value of the second sub-packet; otherwise, their value is 0.
      // These packets always have exactly two sub-packets.
      return [subPackets[0] == subPackets[1] ? 1 : 0, bitsRead];
    }

    throw Exception('Sumtin went wrong!');
  }

}
