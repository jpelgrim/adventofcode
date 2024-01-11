package y2023.day21

import util.Point
import util.println
import util.readLines
import util.withinBounds

private const val DAY = "day21" // https://adventofcode.com/2023/day/21

fun main() {
    solveDay21()
}

fun solveDay21() {
    val input = "y2023/$DAY/input_example.txt".readLines()

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
    val steps = 65 + 134
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
            // The first time we encounter a full block in the original 131x131 grid
            block1Size = stepPositions.filter { step -> step.withinBounds(width,height) }.size
        }
        if (it == 64 + 132) {
            // The flop size of the previous block. This pattern is now repeated indefinitely in the original 131x131 grid
            block2Size = stepPositions.filter { step -> step.withinBounds(width,height) }.size
        }
        // The below checks are not necessary, but just to demonstrate that the pattern repeats itself
        if (it == 64 + 133) {
            val block3Size = stepPositions.filter { step -> step.withinBounds(width,height) }.size
            check(block3Size == block1Size)
        }
        if (it == 64 + 134) {
            val block4Size = stepPositions.filter { step -> step.withinBounds(width,height) }.size
            check(block4Size == block2Size)
        }
    }

    // Nice explanation of the geometry of what's defined below here:
    // https://github.com/villuna/aoc23/wiki/A-Geometric-solution-to-advent-of-code-2023,-day-21

    // Size of repeating odd block pattern
    val oddPatternSize = block1Size + block2Size
    // Size of repeating even block pattern
    val evenPatternSize = sizeAtStep197 - oddPatternSize - diamondShapeSize
    // Radius of the diamond shape, in original numbers of original block sizes
    val radius = 26501365 / 131L
    // The odd block pattern is repeated radius * radius times (see explanation in link above)
    val totalOddPatternSize = oddPatternSize * radius * radius
    // The even block pattern is repeated radius times (see explanation in link above)
    val totalEvenPatternSize = evenPatternSize * radius
    // We also need to add the diamond shape size itself to the result
    val solutionPart2 = totalOddPatternSize + totalEvenPatternSize + diamondShapeSize
    check(solutionPart2 == 630129824772393L)
    "The solution for $DAY part2 is: $solutionPart2".println()
}
