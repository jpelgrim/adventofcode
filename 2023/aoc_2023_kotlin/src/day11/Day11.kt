package day11

import println
import readLines
import kotlin.math.abs

private const val DAY = "day11" // https://adventofcode.com/2023/day/11

fun main() {
    solveDay11()
}

data class Point(val x: Long, val y: Long)

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
    "The solution for $DAY part1 is: ${manhattanDistances(translatedGalaxies).sum()}".println()

    val translatedGalaxiesPart2 = translateGalaxies(galaxies, emptyColumns, emptyRows, 1000000)
    "The solution for $DAY part2 is: ${manhattanDistances(translatedGalaxiesPart2).sum()}".println()
}

private fun translateGalaxies(
    galaxies: MutableList<Point>,
    emptyColumns: MutableList<Int>,
    emptyRows: MutableList<Int>,
    expansion: Int
): List<Point> {
    val translatedGalaxies = galaxies.map { point ->
        val x = point.x
        val y = point.y
        val translateX = emptyColumns.count { it < x } * (expansion - 1)
        val translateY = emptyRows.count { it < y } * (expansion - 1)
        Point(x + translateX, y + translateY)
    }
    return translatedGalaxies
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
