package y2024.day08

import util.println
import util.readLines

private const val DAY = "day08" // https://adventofcode.com/2024/day/8

fun main() {
    solveDay8()
}

fun solveDay8() {
    val input = "y2024/$DAY/sample.txt"
    val lines = input.readLines()

    val antennas = buildMap {
        for (y in 0..lines.size - 1) {
            for (x in 0..lines[y].length - 1) {
                val c = lines[y][x]
                if (c != '.') put(c, (get(c) ?: emptyList<Pair<Int, Int>>()) + (x to y))
            }
        }
    }

    val maxY = lines.size - 1
    val maxX = lines[0].length - 1

    val solutionPart1 = solvePart1(antennas, maxX, maxY)
    "The solution for $DAY part 1 is: $solutionPart1".println()

    val solutionPart2 = solvePart2(antennas, maxX, maxY)
    "The solution for $DAY part 1 is: $solutionPart2".println()
}

private fun solvePart1(antennas: Map<Char, List<Pair<Int, Int>>>, maxX: Int, maxY: Int): Int {
    val antinodes = buildSet<Pair<Int, Int>> {
        antennas.filterValues { it.size > 1 }.values.forEach { v ->
            for (i in 0..v.size - 1) {
                for (j in i + 1..v.size - 1) {
                    val (x1, y1) = v[i]
                    val (x2, y2) = v[j]
                    val dx = x1 - x2
                    val dy = y1 - y2
                    add(x2 - dx to y2 - dy)
                    add(x1 + dx to y1 + dy)
                }
            }
        }
    }.filter { (x, y) -> x in 0..maxX && y in 0..maxY }

    return antinodes.size
}

private fun solvePart2(antennas: Map<Char, List<Pair<Int, Int>>>, maxX: Int, maxY: Int): Int {
    val antinodes = buildSet<Pair<Int, Int>> {
        antennas.filterValues { it.size > 1 }.values.forEach { v ->
            // All antennas are now antinodes too
            addAll(v)
            for (i in 0..v.size - 1) {
                for (j in i + 1..v.size - 1) {
                    val (x1, y1) = v[i]
                    val (x2, y2) = v[j]
                    val dx = x1 - x2
                    val dy = y1 - y2
                    var x = x2
                    var y = y2
                    while (true) {
                        x = x - dx
                        y = y - dy
                        if (x in 0..maxX && y in 0..maxY) add(x to y) else break
                    }
                    x = x1
                    y = y1
                    while (true) {
                        x += dx
                        y += dy
                        if (x in 0..maxX && y in 0..maxY) add(x to y) else break
                    }
                }
            }
        }
    }

    return antinodes.size
}
