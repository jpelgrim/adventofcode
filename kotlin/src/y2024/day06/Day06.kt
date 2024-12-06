package y2024.day06

import util.Direction
import util.println
import util.readLines

private const val DAY = "day06" // https://adventofcode.com/2024/day/6

fun main() {
    solveDay6()
}

fun solveDay6() {
    val lines = ("y2024/$DAY/sample.txt").readLines()

    var initialGuardPosition = 0 to 0
    var walkingDirection = Direction.UP
    val obstacles = buildList<Pair<Int, Int>> {
        lines.forEachIndexed { y, line ->
            line.forEachIndexed { x, c ->
                if (c == '#') add(x to y)
                if (c == '^') {
                    initialGuardPosition = x to y
                }
            }
        }
    }

    val maxY = lines.size
    val maxX = lines[0].length

    val visited = mutableSetOf<Pair<Int, Int>>()
    var guardPosition = initialGuardPosition
    while (guardPosition.first in 0 until maxX && guardPosition.second in 0 until maxY) {
        visited.add(guardPosition)
        val (x, y) = guardPosition
        val (dx, dy) = when (walkingDirection) {
            Direction.LEFT -> -1 to 0
            Direction.UP -> 0 to -1
            Direction.RIGHT -> 1 to 0
            Direction.DOWN -> 0 to 1
        }
        val nextPosition = x + dx to y + dy
        if (nextPosition in obstacles) {
            walkingDirection = walkingDirection.clockwise()
        } else {
            guardPosition = nextPosition
        }
    }

    val solutionPart1 = visited.size
    "The solution for $DAY part1 is: $solutionPart1".println()

    val superBlockers = mutableSetOf<Pair<Int, Int>>()
    for (y in 0 until maxY) {
        for (x in 0 until maxX) {
            if (x to y in obstacles) continue
            val obstaclesWithSuperBlocker = obstacles.toMutableSet().apply { add(x to y) }
            val visitedWithDirection = mutableSetOf<Pair<Pair<Int, Int>, Direction>>()
            var guardPosition = initialGuardPosition
            var walkingDirection = Direction.UP
            while (guardPosition.first in 0 until maxX && guardPosition.second in 0 until maxY) {
                val guardPositionWithDirection = guardPosition to walkingDirection
                if (guardPositionWithDirection in visitedWithDirection) {
                    superBlockers.add(x to y)
                    break
                }
                visitedWithDirection.add(guardPositionWithDirection)
                val (x, y) = guardPosition
                val (dx, dy) = when (walkingDirection) {
                    Direction.LEFT -> -1 to 0
                    Direction.UP -> 0 to -1
                    Direction.RIGHT -> 1 to 0
                    Direction.DOWN -> 0 to 1
                }
                val nextPosition = x + dx to y + dy
                if (nextPosition in obstaclesWithSuperBlocker) {
                    walkingDirection = walkingDirection.clockwise()
                } else {
                    guardPosition = nextPosition
                }
            }
        }
    }

    val solutionPart2 = superBlockers.size
    "The solution for $DAY part2 is: $solutionPart2".println()
}
