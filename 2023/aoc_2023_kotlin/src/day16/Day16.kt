package day16

import util.Direction
import util.Direction.DOWN
import util.Direction.LEFT
import util.Direction.RIGHT
import util.Direction.UP
import util.Point
import util.println
import util.readLines
import util.withinBounds

private const val DAY = "day16" // https://adventofcode.com/2023/day/16

fun main() {
    solveDay16()
}

fun solveDay16() {
    val input = "$DAY/input_example.txt".readLines()
    val width = input[0].length
    val height = input.size

    val solutionPart1 = solvePart1(input, width, height)
    check(solutionPart1 == 46)
    "The solution for $DAY part1 is: $solutionPart1".println()

    val solutionPart2 = solvePart2(input, width, height)
    check(solutionPart2 == 51)
    "The solution for $DAY part2 is: $solutionPart2".println()
}

internal fun solvePart1(lines: List<String>, width: Int, height: Int) =
    calcEnergized(lines, width, height, Point(0, 0) to RIGHT)

fun solvePart2(input: List<String>, width: Int, height: Int): Int {
    var maxEnergized = 0
    for (x in input[0].indices) {
        var energized = calcEnergized(input, width, height, Point(x, 0) to DOWN)
        if (energized > maxEnergized) {
            maxEnergized = energized
        }
        energized = calcEnergized(input, width, height, Point(x, height - 1) to UP)
        if (energized > maxEnergized) {
            maxEnergized = energized
        }
    }
    for (y in input.indices) {
        var energized = calcEnergized(input, width, height, Point(0, y) to RIGHT)
        if (energized > maxEnergized) {
            maxEnergized = energized
        }
        energized = calcEnergized(input, width, height, Point(width - 1, y) to LEFT)
        if (energized > maxEnergized) {
            maxEnergized = energized
        }
    }
    return maxEnergized
}

private fun calcEnergized(
    lines: List<String>, width: Int, height: Int, start: Pair<Point, Direction>
): Int {
    val stack = mutableListOf(start)
    val visited = mutableSetOf(start)

    while (true) {
        val (currentPoint, direction) = stack.removeFirstOrNull() ?: break
        val mirror = lines[currentPoint.y.toInt()][currentPoint.x.toInt()]
        for (newDirection in mirror.reflectedDirections(direction)) {
            val newPoint = currentPoint.move(newDirection)
            if (newPoint.withinBounds(width, height)) {
                val newPointDirectionPair = newPoint to newDirection
                if (visited.add(newPointDirectionPair)) stack.add(newPointDirectionPair)
            }
        }
    }

    return visited.mapTo(mutableSetOf()) { it.first }.size
}

internal fun Char.reflectedDirections(direction: Direction): List<Direction> = when {
    this == '/' && direction == UP -> listOf(RIGHT)
    this == '/' && direction == DOWN -> listOf(LEFT)
    this == '/' && direction == RIGHT -> listOf(UP)
    this == '/' && direction == LEFT -> listOf(DOWN)
    this == '\\' && direction == UP -> listOf(LEFT)
    this == '\\' && direction == DOWN -> listOf(RIGHT)
    this == '\\' && direction == RIGHT -> listOf(DOWN)
    this == '\\' && direction == LEFT -> listOf(UP)
    this == '-' && (direction == UP || direction == DOWN) -> listOf(LEFT, RIGHT)
    this == '|' && (direction == RIGHT || direction == LEFT) -> listOf(UP, DOWN)
    else -> listOf(direction) // A '.' or parallel mirror so keep going in the same direction
}
