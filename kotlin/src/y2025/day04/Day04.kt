package y2025.day04

import util.Point
import util.println
import util.readLines
import util.verify

private const val DAY = "day04" // https://adventofcode.com/2025/day/4

fun main() {
    solveDay4()
}

fun solveDay4() {
    val input = "y2025/$DAY/sample.txt".readLines()
    verify(13, "Day 4 Part 1") { part1(input) }
    verify(43, "Day 4 Part 2") { part2(input) }
}

private fun part1(input: List<String>): Int {
    val paperPoints = buildSet {
        input.forEachIndexed { y, line ->
            line.forEachIndexed { x, c ->
                if (c == '@') add(Point(x.toLong(), y.toLong()))
            }
        }
    }
    val solution = paperPoints.sumOf { point ->
        val adjacentsInSet = point.adjacent(true).count { it in paperPoints }
        if (adjacentsInSet < 4) 1 else 0
    }
    "The solution for $DAY part 1 is: $solution".println()
    return solution
}

private fun part2(input: List<String>): Int {
    val paperPoints = buildSet {
        input.forEachIndexed { y, line ->
            line.forEachIndexed { x, c ->
                if (c == '@') add(Point(x.toLong(), y.toLong()))
            }
        }
    }
    val removedPaperPoints = mutableSetOf<Point>()
    while (true) {
        var foundPaperPoint = false
        val pointsToVisit = paperPoints - removedPaperPoints
        pointsToVisit.forEach { point ->
            val adjacentsInSet = point.adjacent(true).count { it in pointsToVisit }
            if (adjacentsInSet < 4) {
                foundPaperPoint = true
                removedPaperPoints.add(point)
            }
        }
        if (!foundPaperPoint) break
    }
    val solution = removedPaperPoints.size
    "The solution for $DAY part 1 is: $solution".println()
    return solution
}
