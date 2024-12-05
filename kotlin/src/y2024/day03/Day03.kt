package y2024.day03

import util.println
import util.readLines

private const val DAY = "day03" // https://adventofcode.com/2024/day/3

fun main() {
    solveDay3()
}

fun solveDay3() {
    solvePart1()
    solvePart2()
}

private fun solvePart1() {
    val lines = "y2024/$DAY/sample.txt".readLines()
    val solutionPart1 = lines.fold(0, { sum, line -> sum + findMultiplications(line) })
    "The solution for $DAY part1 is: $solutionPart1".println()
}

private fun findMultiplications(line: String) =
    """mul\((\d+),(\d+)\)"""
        .toRegex()
        .findAll(line)
        .fold(0) { sum, match ->
            val (a, b) = match.destructured
            sum + a.toInt() * b.toInt()
        }

private fun solvePart2() {
    val lines = "y2024/$DAY/sample2.txt".readLines()
    var mode = Mode.DO
    val solutionPart2 = lines.fold(0, { sum, line ->
        var result = 0
        var index = 0
        while (true) {
            if (mode == Mode.DO) {
                val indexOfDoNot = line.indexOf("don't()", startIndex = index)
                if (indexOfDoNot > -1) {
                    mode = Mode.DO_NOT
                    result += findMultiplications(line.substring(index, indexOfDoNot))
                    index = line.indexOf("do()", startIndex = indexOfDoNot)
                } else {
                    result += findMultiplications(line.substring(index))
                    index = -1
                }
                if (index == -1) break
            } else {
                index = line.indexOf("do()", startIndex = index)
                if (index == -1) break
                mode = Mode.DO
            }
        }
        sum + result
    })
    "The solution for $DAY part2 is: $solutionPart2".println()
}

private enum class Mode { DO, DO_NOT }
