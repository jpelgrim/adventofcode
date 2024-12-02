package y2024.day02

import util.ints
import util.println
import util.readLines
import kotlin.math.abs

private const val DAY = "day02" // https://adventofcode.com/2024/day/2

fun main() {
    solveDay2()
}

fun solveDay2() {
    val lines = "y2024/$DAY/sample.txt".readLines()
    val reports = lines.ints()
    val solutionPart1 = reports.count { report ->
        (allIncreasing(report) || allDecreasing(report)) && maxDistance(report, 3)
    }
    "The solution for $DAY part1 is: $solutionPart1".println()

    val solutionPart2 = reports.count { report ->
        report.indices.any { i ->
            val altReport = report.toMutableList().apply { removeAt(i) }
            (allIncreasing(altReport) || allDecreasing(altReport)) && maxDistance(altReport, 3)
        }
    }
    "The solution for $DAY part2 is: $solutionPart2".println()
}

fun maxDistance(list: List<Int>, distance: Int) = list
    .windowed(2)
    .all {
        (a, b) -> abs(a - b) in 1..distance
    }

fun allDecreasing(list: List<Int>) = list
    .windowed(2)
    .all {
        (a, b) -> a > b
    }

fun allIncreasing(list: List<Int>) = list
    .windowed(2)
    .all {
        (a, b) -> a < b
    }
