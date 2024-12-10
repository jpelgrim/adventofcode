package y2024.day10

import util.Point
import util.println
import util.readLines
import util.singleInts
import util.withinBounds

private const val DAY = "day10" // https://adventofcode.com/2024/day/10

fun main() {
    solveDay10()
}

fun solveDay10() {
    val lines = "y2024/$DAY/sample.txt".readLines().map { it.singleInts() }

    var solutionPart1 = 0
    for (y in 0 until lines.size) {
        for (x in 0 until lines[0].size) {
            if (lines[y][x] == 0) {
                solutionPart1 += numberOfPaths(x,y, lines, false)
            }
        }
    }
    "The solution for $DAY part 1 is: $solutionPart1".println()

    var solutionPart2 = 0
    for (y in 0 until lines.size) {
        for (x in 0 until lines[0].size) {
            if (lines[y][x] == 0) {
                solutionPart2 += numberOfPaths(x,y, lines, true)
            }
        }
    }
    "The solution for $DAY part 2 is: $solutionPart2".println()
}

fun numberOfPaths(
    x: Int,
    y: Int,
    matrix: List<List<Int>>,
    uniquePaths: Boolean
): Int {
    val validPaths = mutableSetOf<List<Point>>()
    val toVisit = mutableListOf<List<Point>>(listOf(Point(x, y)))
    while (toVisit.isNotEmpty()) {
        val path = toVisit.removeAt(0)
        val last = path.last()
        val level = matrix[last.y.toInt()][last.x.toInt()]
        if (level == 9) {
            validPaths.add(path)
        } else {
            for (point in last.adjacent()) {
                if (path.contains(point)) continue
                if (!point.withinBounds(matrix.size, matrix[0].size)) continue
                if (matrix[point.y.toInt()][point.x.toInt()] == level + 1) {
                    toVisit.add(path + point)
                }
            }
        }
    }
    return if (uniquePaths) {
        // All the paths leading to (maybe similar) points with value 9
        validPaths.size
    } else {
        // It's enough to return the size of unique end points, having a value of 9
        validPaths.map { it.last() }.toSet().size
    }
}
