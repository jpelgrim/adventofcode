package day21

import util.Point
import util.println
import util.readLines

private const val DAY = "day21" // https://adventofcode.com/2023/day/21

fun main() {
    solveDay21()
}

fun solveDay21() {
    val input = "$DAY/input_example.txt".readLines()

    val garden = mutableListOf<Point>()
    lateinit var start: Point
    input.forEachIndexed { y, line ->
        line.forEachIndexed { x, c ->
            when (c) {
                '#' -> garden.add(Point(x, y))
                'S' -> start = Point(x, y)
            }
        }
    }
    // Part 1
    val stepPositions = mutableSetOf(start)
    repeat(64) {
        val newStepPositions = mutableSetOf<Point>()
        stepPositions.forEach { stepPosition ->
            val adjacent = stepPosition.adjacent()
            newStepPositions.addAll(adjacent.filter { !garden.contains(it) })
        }
        stepPositions.clear()
        stepPositions.addAll(newStepPositions)
    }
    val solutionPart1 = stepPositions.size
    "The solution for $DAY part1 is: $solutionPart1".println()

    // Part 2
    stepPositions.clear()
    stepPositions.add(start)

    val width = input[0].length
    val height = input.size
    val steps = 65 + 131 + 131
    var diamondShapeSize = 0L
    var sizeAtStep197 = 0L
    var sizeAtStep327 = 0L
    repeat(steps) {
        val newStepPositions = mutableSetOf<Point>()
        stepPositions.forEach { stepPosition ->
            for (adjacent in stepPosition.adjacent()) {
                val x = adjacent.x % width
                val y = adjacent.y % height
                if (!garden.contains(
                        Point(
                            if (x < 0) x + width else x,
                            if (y < 0) y + height else y
                        )
                    )
                ) {
                    newStepPositions.add(adjacent)
                }
            }
        }
        stepPositions.clear()
        stepPositions.addAll(newStepPositions)
        if (it == 64) diamondShapeSize = stepPositions.size.toLong()
        if (it == 64 + 131) sizeAtStep197 = stepPositions.size.toLong()
        if (it == 64 + 131 + 131) sizeAtStep327 = stepPositions.size.toLong()
    }

    val block1Size = (sizeAtStep327 - 2 * sizeAtStep197 + diamondShapeSize) / 2
    val block2Size = (4 * sizeAtStep197 - sizeAtStep327 - 3 * diamondShapeSize) / 2
    val spread = 26501365 / 131L
    val solutionPart2 = block1Size * spread * spread + block2Size * spread + diamondShapeSize
    "The solution for $DAY part2 is: $solutionPart2".println()
}
