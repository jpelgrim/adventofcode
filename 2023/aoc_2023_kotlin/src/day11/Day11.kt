package day11

import util.println
import util.readLines
import kotlin.math.abs

private const val DAY = "day11" // https://adventofcode.com/2023/day/11

fun main() {
    solveDay11()
}

internal data class Point(val x: Long, val y: Long)

fun solveDay11() {
    val input = "$DAY/input_example.txt".readLines()

    val emptyColumns = (0..<input[0].length).map { it }.toMutableList()
    val emptyRows = mutableListOf<Int>()
    val galaxies = mutableListOf<Point>()
    input.forEachIndexed { y, line ->
        if (line.all { it == '.' }) {
            emptyRows.add(y)
        } else {
            line.forEachIndexed { x, c ->
                if (c == '#') {
                    emptyColumns.remove(x)
                    galaxies.add(Point(x.toLong(), y.toLong()))
                }
            }
        }
    }
    val translatedGalaxies = translateGalaxies(galaxies, emptyColumns, emptyRows, 2)
    val solutionPart1 = manhattanDistances(translatedGalaxies).sum()
    check(solutionPart1 == 374L)
    "The solution for $DAY part1 is: $solutionPart1".println()

    val translatedGalaxiesPart2 = translateGalaxies(galaxies, emptyColumns, emptyRows, 1000000)
    val solutionPart2 = manhattanDistances(translatedGalaxiesPart2).sum()
    check(solutionPart2 == 82000210L)
    "The solution for $DAY part2 is: $solutionPart2".println()
}

private fun translateGalaxies(
    galaxies: MutableList<Point>,
    emptyColumns: MutableList<Int>,
    emptyRows: MutableList<Int>,
    expansion: Int
) = galaxies.map { point ->
    val translateX = emptyColumns.count { it < point.x } * (expansion - 1)
    val translateY = emptyRows.count { it < point.y } * (expansion - 1)
    Point(point.x + translateX, point.y + translateY)
}

private fun manhattanDistances(translatedGalaxies: List<Point>): MutableList<Long> {
    val distances = mutableListOf<Long>()
    translatedGalaxies.forEachIndexed { index, point ->
        translatedGalaxies.subList(index + 1, translatedGalaxies.size).forEach { otherPoint ->
            distances.add(abs(point.x - otherPoint.x) + abs(point.y - otherPoint.y))
        }
    }
    return distances
}
