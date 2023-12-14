package day14

import println
import readLines

private const val DAY = "day14"

fun main() {
    solveDay14()
}

internal data class Point(val x: Int, val y: Int)

fun solveDay14() {
    val input = "$DAY/input_example.txt".readLines()
    val cubeShapedRocks = mutableListOf<Point>()
    val roundedRocks = mutableListOf<Point>()
    val width = input[0].length
    val height = input.size
    input.forEachIndexed { y, line ->
        line.forEachIndexed { x, char ->
            when (char) {
                '#' -> cubeShapedRocks.add(Point(x, y))
                'O' -> roundedRocks.add(Point(x, y))
            }
        }
    }
    val solutionPart1 = roleNorth(roundedRocks, cubeShapedRocks).sumOf { height - it.y }
    "The solution for $DAY part1 is: $solutionPart1".println()

    val totalLoadsForIndex = mutableMapOf<Int, Int>()
    val cycleLength: Int
    val cycleStart: Int
    var index = 0
    while (true) {
        val rolledNorthRocks = roleNorth(roundedRocks, cubeShapedRocks)
        val rolledWestRocks = roleWest(rolledNorthRocks, cubeShapedRocks)
        val rolledSouthRocks = roleSouth(rolledWestRocks, cubeShapedRocks, height)
        val rolledEastRocks = roleEast(rolledSouthRocks, cubeShapedRocks, width)
        roundedRocks.clear()
        roundedRocks.addAll(rolledEastRocks)
        val totalLoad = roundedRocks.sumOf { height - it.y }
        if (index < 200) {
            totalLoadsForIndex[totalLoad] = index
        } else {
            if (totalLoadsForIndex[totalLoad] != null) {
                val previousIndex = totalLoadsForIndex[totalLoad]!!
                cycleLength = index - previousIndex
                cycleStart = previousIndex - cycleLength
                break
            } else {
                totalLoadsForIndex[totalLoad] = index
            }
        }
        index++
    }
    var solutionIndex = 1000000000 % cycleLength
    while (solutionIndex < cycleStart + cycleLength) {
        solutionIndex += cycleLength
    }
    val solutionPart2 = totalLoadsForIndex.entries.first { it.value == solutionIndex - 1 }.key
    "The solution for $DAY part2 is: $solutionPart2".println()
}


internal fun roleNorth(
    roundedRocks: List<Point>, cubeShapedRocks: List<Point>
): List<Point> {
    val newRoundedRockPositions = mutableListOf<Point>()
    roundedRocks.groupBy { it.x }.forEach { (x, points) ->
        points.sortedBy { it.y }.forEach { point ->
            // Check if there is a cube shaped rock above us
            val cubeShapedRockAbove =
                cubeShapedRocks.filter { it.x == x && it.y < point.y }.maxByOrNull { it.y }
            // Check if there is a cube shaped rock above us
            val roundedRockAbove =
                newRoundedRockPositions.filter { it.x == x && it.y < point.y }.maxByOrNull { it.y }
            // Pick the lowest rock above us
            val lowestRockAbove = if (cubeShapedRockAbove == null && roundedRockAbove == null) {
                null
            } else if (cubeShapedRockAbove == null) {
                roundedRockAbove
            } else if (roundedRockAbove == null) {
                cubeShapedRockAbove
            } else {
                if (cubeShapedRockAbove.y > roundedRockAbove.y) {
                    cubeShapedRockAbove
                } else {
                    roundedRockAbove
                }
            }
            // Move to the new position
            if (lowestRockAbove == null) {
                newRoundedRockPositions.add(Point(point.x, 0))
            } else {
                newRoundedRockPositions.add(Point(point.x, lowestRockAbove.y + 1))
            }
        }
    }
    return newRoundedRockPositions.toList()
}

internal fun roleWest(
    roundedRocks: List<Point>, cubeShapedRocks: List<Point>
): List<Point> {
    val newRoundedRockPositions = mutableListOf<Point>()
    roundedRocks.groupBy { it.y }.forEach { (y, points) ->
        points.sortedBy { it.x }.forEach { point ->
            // Check if there is a cube shaped rock to the left of us
            val mostLeftCubeShapedRock =
                cubeShapedRocks.filter { it.y == y && it.x < point.x }.maxByOrNull { it.x }
            // Check if there is a cube shaped rock to the left of us
            val mostRightRoundShapedRock =
                newRoundedRockPositions.filter { it.y == y && it.x < point.x }.maxByOrNull { it.x }
            // Pick the most right rock to the left of us
            val mostRightRockToTheLeftOfUs =
                if (mostLeftCubeShapedRock == null && mostRightRoundShapedRock == null) {
                    null
                } else if (mostLeftCubeShapedRock == null) {
                    mostRightRoundShapedRock
                } else if (mostRightRoundShapedRock == null) {
                    mostLeftCubeShapedRock
                } else {
                    if (mostLeftCubeShapedRock.x > mostRightRoundShapedRock.x) {
                        mostLeftCubeShapedRock
                    } else {
                        mostRightRoundShapedRock
                    }
                }
            // Move to the new position
            if (mostRightRockToTheLeftOfUs == null) {
                newRoundedRockPositions.add(Point(0, point.y))
            } else {
                newRoundedRockPositions.add(Point(mostRightRockToTheLeftOfUs.x + 1, point.y))
            }
        }
    }
    return newRoundedRockPositions.toList()
}

internal fun roleEast(
    roundedRocks: List<Point>, cubeShapedRocks: List<Point>, width: Int
): List<Point> {
    val newRoundedRockPositions = mutableListOf<Point>()
    roundedRocks.groupBy { it.y }.forEach { (y, points) ->
        points.sortedByDescending { it.x }.forEach { point ->
            // Check if there is a cube shaped rock to the right of us
            val mostRightCubeShapedRock =
                cubeShapedRocks.filter { it.y == y && it.x > point.x }.minByOrNull { it.x }
            // Check if there is a cube shaped rock to the right of us
            val mostLeftRoundShapedRock =
                newRoundedRockPositions.filter { it.y == y && it.x > point.x }.minByOrNull { it.x }
            // Pick the most left rock to the right of us
            val mostLeftRockToTheRightOfUs =
                if (mostRightCubeShapedRock == null && mostLeftRoundShapedRock == null) {
                    null
                } else if (mostRightCubeShapedRock == null) {
                    mostLeftRoundShapedRock
                } else if (mostLeftRoundShapedRock == null) {
                    mostRightCubeShapedRock
                } else {
                    if (mostRightCubeShapedRock.x < mostLeftRoundShapedRock.x) {
                        mostRightCubeShapedRock
                    } else {
                        mostLeftRoundShapedRock
                    }
                }
            // Move to the new position
            if (mostLeftRockToTheRightOfUs == null) {
                newRoundedRockPositions.add(Point(width - 1, point.y))
            } else {
                newRoundedRockPositions.add(Point(mostLeftRockToTheRightOfUs.x - 1, point.y))
            }
        }
    }
    return newRoundedRockPositions.toList()
}

internal fun roleSouth(
    roundedRocks: List<Point>, cubeShapedRocks: List<Point>, height: Int
): List<Point> {
    val newRoundedRockPositions = mutableListOf<Point>()
    roundedRocks.groupBy { it.x }.forEach { (x, points) ->
        points.sortedByDescending { it.y }.forEach { point ->
            // Check if there is a cube shaped rock below us
            val cubeShapedRockBelow =
                cubeShapedRocks.filter { it.x == x && it.y > point.y }.minByOrNull { it.y }
            // Check if there is a cube shaped rock below us
            val roundedRockBelow =
                newRoundedRockPositions.filter { it.x == x && it.y > point.y }.minByOrNull { it.y }
            // Pick the highest rock below us
            val highestRockBelow = if (cubeShapedRockBelow == null && roundedRockBelow == null) {
                null
            } else if (cubeShapedRockBelow == null) {
                roundedRockBelow
            } else if (roundedRockBelow == null) {
                cubeShapedRockBelow
            } else {
                if (cubeShapedRockBelow.y < roundedRockBelow.y) {
                    cubeShapedRockBelow
                } else {
                    roundedRockBelow
                }
            }
            // Move to the new position
            if (highestRockBelow == null) {
                newRoundedRockPositions.add(Point(point.x, height - 1))
            } else {
                newRoundedRockPositions.add(Point(point.x, highestRockBelow.y - 1))
            }
        }
    }
    return newRoundedRockPositions.toList()
}
