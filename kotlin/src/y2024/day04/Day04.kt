package y2024.day04

import util.println
import util.readLines
import util.transposed

private const val DAY = "day04" // https://adventofcode.com/2024/day/4

fun main() {
    solveDay4()
}

private fun solveDay4() {
    val lines = "y2024/$DAY/sample.txt".readLines()
    solvePart1(lines)
    solvePart2(lines)
}

private fun solvePart1(lines: List<String>) {
    val linesTransposed = lines.transposed()

    val diagonalLines = mutableListOf<String>()
    for (c in 0 until lines[0].length) {
        val diagonalLine = mutableListOf<String>()
        var y = 0
        var x = c
        while (y < lines.size && x >= 0) {
            diagonalLine.add(lines[y][x].toString())
            y++
            x--
        }
        diagonalLines.add(diagonalLine.joinToString(""))
    }
    for (r in 1 until lines.size) {
        val diagonalLine = mutableListOf<String>()
        var y = r
        var x = lines[0].length - 1
        while (y < lines.size && x >= 0) {
            diagonalLine.add(lines[y][x].toString())
            y++
            x--
        }
        diagonalLines.add(diagonalLine.joinToString(""))
    }
    for (c in lines[0].length - 1 downTo 0) {
        val diagonalLine = mutableListOf<String>()
        var y = 0
        var x = c
        while (y < lines.size && x < lines[0].length) {
            diagonalLine.add(lines[y][x].toString())
            y++
            x++
        }
        diagonalLines.add(diagonalLine.joinToString(""))
    }
    for (r in lines.size - 1 downTo 1) {
        val diagonalLine = mutableListOf<String>()
        var y = r
        var x = 0
        while (y < lines.size && x < lines[0].length) {
            diagonalLine.add(lines[y][x].toString())
            y++
            x++
        }
        diagonalLines.add(diagonalLine.joinToString(""))
    }

    val newLines = mutableListOf<String>()
    newLines.addAll(lines)
    newLines.addAll(linesTransposed)
    newLines.addAll(diagonalLines)

    val solutionPart1 = newLines.sumOf { line ->
        """XMAS""".toRegex().findAll(line).count() + """SAMX""".toRegex().findAll(line).count()
    }
    "The solution for $DAY part1 is: $solutionPart1".println()
}

private fun solvePart2(lines: List<String>) {
    var counter = 0
    for (x in 0 until lines[0].length - 2) {
        for (y in 0 until lines.size - 2) {
            var xmas =
                lines[y][x].toString() + lines[y][x + 2] + lines[y + 1][x + 1] + lines[y + 2][x] + lines[y + 2][x + 2]
            counter += if (xmas == "SSAMM" || xmas == "MMASS" || xmas == "SMASM" || xmas == "MSAMS") 1 else 0
        }
    }

    val solutionPart2 = counter
    "The solution for $DAY part2 is: $solutionPart2".println()
}
