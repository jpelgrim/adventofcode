package y2023.day03

import util.println
import util.readLines
import java.awt.Point

private const val DAY = "day03" // https://adventofcode.com/2023/day/3

fun main() {
    solveDay3()
}

fun solveDay3() {
    val input = "y2023/$DAY/input_example.txt".readLines()
    var solutionPart1 = 0
    val numbersAdjacentToAsterisk = mutableMapOf<Point, MutableList<Int>>()
    for (lineIndex in input.indices) {
        val line = input[lineIndex]
        val numbers = extractNumbers(line)
        if (numbers.isEmpty()) continue
        var currentNumber = ""
        var numberStartIndex = -1
        var numberEndIndex = -1
        for (charIndex in line.indices) {
            if (line[charIndex].isDigit()) {
                if (numberStartIndex == -1) {
                    numberStartIndex = charIndex
                }
                numberEndIndex = charIndex
                currentNumber += line[charIndex]
            }
            if ((charIndex == line.length - 1 || !line[charIndex + 1].isDigit()) && currentNumber.isNotEmpty()) {
                val number = currentNumber.toInt()
                val startX = if (numberStartIndex > 0) numberStartIndex - 1 else 0
                val endX = if (numberEndIndex < line.length - 1) numberEndIndex + 2 else line.length
                val previousSubstring =
                    if (lineIndex > 0) input[lineIndex - 1].substring(startX, endX) else ""
                val nextSubstring = if (lineIndex < input.size - 1) input[lineIndex + 1].substring(
                    startX, endX
                ) else ""
                val stringToCheck = line.substring(startX, endX) + previousSubstring + nextSubstring
                currentNumber = ""
                numberStartIndex = -1
                numberEndIndex = -1
                if (noSymbols(stringToCheck)) continue
                solutionPart1 += number

                // On to part 2
                val startY = if (lineIndex > 0) lineIndex - 1 else 0
                val endY = if (lineIndex < input.size - 1) lineIndex + 1 else input.size - 1
                for (x in startX..<endX) {
                    for (y in startY..endY) {
                        // Check if the number is adjacent to an asterisk
                        if (input[y][x] == '*') {
                            // If it is, add it to the map with the asterisk's coordinates as the key
                            if (numbersAdjacentToAsterisk[Point(y, x)] == null) {
                                numbersAdjacentToAsterisk[Point(y, x)] = mutableListOf()
                            }
                            numbersAdjacentToAsterisk[Point(y, x)]!!.add(number)
                        }
                    }

                }
            }
        }
    }
    "The solution for $DAY part1 is: $solutionPart1".println()

    val solutionPart2 =
        numbersAdjacentToAsterisk.values.filter { it.size == 2 }.sumOf { it[0] * it[1] }

    "The solution for $DAY part2 is: $solutionPart2".println()
}

fun noSymbols(substring: String) = substring.codePoints().allMatch { it == 46 || it in 48..57 }

private fun extractNumbers(line: String): List<Int> {
    val numbers = mutableListOf<Int>()
    var currentNumber = ""
    for (char in line) {
        if (char.isDigit()) {
            currentNumber += char
        } else {
            if (currentNumber.isNotEmpty()) {
                numbers.add(currentNumber.toInt())
                currentNumber = ""
            }
        }
    }
    if (currentNumber.isNotEmpty()) {
        numbers.add(currentNumber.toInt())
    }
    return numbers
}
