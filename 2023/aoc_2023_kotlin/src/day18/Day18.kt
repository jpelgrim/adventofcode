package day18

import util.Direction
import util.Direction.DOWN
import util.Direction.LEFT
import util.Direction.RIGHT
import util.Direction.UP
import util.Point
import util.println
import util.readLines

private const val DAY = "day18" // https://adventofcode.com/2023/day/18

fun main() {
    solveDay18()
}

fun solveDay18() {
    val input = "$DAY/input_example.txt".readLines()
    val solutionPart1 = solvePart1(input)
    check(solutionPart1 == 62L)
    "The solution for $DAY part1 is: $solutionPart1".println()

    val solutionPart2 = solvePart2(input)
    check(solutionPart2 == 952408144115L)
    "The solution for $DAY part2 is: $solutionPart2".println()
}

data class Instruction(val direction: Direction, val distance: Int, val color: String)

fun solvePart1(input: List<String>): Long {
    val instructions = input.map { it.split(" ") }.map {
        Instruction(
            it[0].toDirection(), it[1].toInt(), it[2].substringAfter("(#").substringBefore(")")
        )
    }
    return calculatePart1(instructions)
}

private fun calculatePart1(instructions: List<Instruction>): Long {
    var current = Point(0, 0)
    val border = mutableSetOf(current)
    val toVisit = mutableSetOf<Point>()
    for (instruction in instructions) {
        repeat(instruction.distance) {
            current = current.move(instruction.direction)
            border += current
        }
        toVisit += current.move(instruction.direction.clockwise())
    }
    val visited = mutableSetOf<Point>()
    while (toVisit.isNotEmpty()) {
        val next = toVisit.first()
        toVisit.remove(next)
        if (next in visited || next in border) continue
        visited += next
        toVisit.addAll(next.adjacent())
    }
    return (border.size + visited.size).toLong()
}

private fun String.toDirection(): Direction = when (this) {
    "R" -> RIGHT
    "L" -> LEFT
    "U" -> UP
    "D" -> DOWN
    else -> throw IllegalArgumentException("Unknown direction: $this")
}


fun solvePart2(input: List<String>): Long {
    val instructions = input.map { it.split(" ") }.map {
        Instruction(
            it[0].toDirection(), it[1].toInt(), it[2].substringAfter("(#").substringBefore(")")
        )
    }.map {
        instructionFromColor(it.color)
    }
    return calculatePart2(instructions)
}

fun instructionFromColor(color: String): Instruction {
    val direction = when (color.last().toString().toInt()) {
        0 -> RIGHT
        1 -> DOWN
        2 -> LEFT
        3 -> UP
        else -> throw IllegalArgumentException("Unknown direction")
    }
    // steps is a hex number convert it to decimal
    val distance = color.dropLast(1).toLong(16).toInt()
    return Instruction(direction, distance, color)
}

// Shoelace formula on pairs of box corners to calculate the area
// See https://en.wikipedia.org/wiki/Shoelace_formula
// See https://www.theoremoftheday.org/GeometryAndTrigonometry/Shoelace/TotDShoelace.pdf
// 👆🏻 PDF is also in this directory
fun calculatePart2(instructions: List<Instruction>): Long {
    var area = 0L
    var border = 0L

    var nextCorner = Point(0, 0)
    var lastCorner = nextCorner

    instructions.forEach { instruction ->
        nextCorner = nextCorner.move(instruction.direction, instruction.distance)
        area += lastCorner.x * nextCorner.y - lastCorner.y * nextCorner.x
        border += instruction.distance
        lastCorner = nextCorner
    }

    // The answer is the area + half the border points + 1 (see explanation.png)
    return area / 2 + border / 2 + 1
}
