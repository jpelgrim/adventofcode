package day21

import util.Point
import util.println
import util.readLines
import util.withinBounds

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
    check(solutionPart1 == 3795)
    "The solution for $DAY part1 is: $solutionPart1".println()

    // Part 2
    stepPositions.clear()
    stepPositions.add(start)

    val width = input[0].length
    val height = input.size
    val steps = 65 + 132
    var diamondShapeSize = 0L
    var sizeAtStep197 = 0L
    var block1Size = 0
    var block2Size = 0
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
        if (it == 64) {
            diamondShapeSize = stepPositions.size.toLong()
        }
        if (it == 64 + 131) {
            sizeAtStep197 = stepPositions.size.toLong()
            block1Size = stepPositions.filter { step -> step.withinBounds(width,height) }.size
        }
        if (it == 64 + 132) {
            block2Size = stepPositions.filter { step -> step.withinBounds(width,height) }.size
        }
    }

    // Size of repeating block pattern 1
    val sizePattern1 = block1Size + block2Size
    // Size of repeating block pattern 2
    val sizePattern2 = sizeAtStep197 - sizePattern1 - diamondShapeSize
    // Radius of the diamond shape, in original numbers of original block sizes
    val radius = 26501365 / 131L
    // The first block pattern is repeated radius * radius times
    val totalBlockPattern1Size = sizePattern1 * radius * radius
    // The second block pattern is repeated radius times
    val totalBlockPattern2Size = sizePattern2 * radius
    // We also need to add the diamond shape size itself to the result
    val solutionPart2 = totalBlockPattern1Size + totalBlockPattern2Size + diamondShapeSize
    check(solutionPart2 == 630129824772393L)
    "The solution for $DAY part2 is: $solutionPart2".println()
}
