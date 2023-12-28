package y2023.day18

import util.Direction
import util.Direction.DOWN
import util.Direction.LEFT
import util.Direction.RIGHT
import util.Direction.UP
import util.Point
import util.loopInfo
import util.println
import util.readLines
import util.sizeOfEnclosedArea

private const val DAY = "day18" // https://adventofcode.com/2023/day/18

fun main() {
    solveDay18()
}

fun solveDay18() {
    val input = "y2023/$DAY/input_example.txt".readLines()
    val solutionPart1 = solvePart1(input)
    check(solutionPart1 == 62L)
    "The solution for $DAY part1 is: $solutionPart1".println()

    val solutionPart2 = solvePart2(input)
    check(solutionPart2 == 952408144115L) { "Expected 952408144115 but was $solutionPart2"}
    "The solution for $DAY part2 is: $solutionPart2".println()

    val solutionPart2Alt = solvePart2Alt(input)
    check(solutionPart2Alt == 952408144115L) { "Expected 952408144115 but was $solutionPart2"}
    "The solution for $DAY part2 is: $solutionPart2Alt".println()
}

data class Instruction(val direction: Direction, val distance: Int, val color: String)

fun solvePart1(input: List<String>): Long {
    val instructions = input.map { it.split(" ") }.map {
        Instruction(
            Direction.parse(it[0][0]), it[1].toInt(), it[2].substringAfter("(#").substringBefore(")")
        )
    }
    return calculatePart1(instructions)
}

private fun calculatePart1(instructions: List<Instruction>): Long {
    var current = Point.ZERO
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

fun solvePart2(input: List<String>): Long {
    val instructions = input.map { it.split(" ") }.map {
        Instruction(
            Direction.parse(it[0][0]), it[1].toInt(), it[2].substringAfter("(#").substringBefore(")")
        )
    }.map {
        instructionFromColor(it.color)
    }
    return calculatePart2(instructions)
}

fun solvePart2Alt(input: List<String>): Long {
    val instructions = input.map { it.split(" ") }.map {
        Instruction(
            Direction.parse(it[0][0]), it[1].toInt(), it[2].substringAfter("(#").substringBefore(")")
        )
    }.map {
        instructionFromColor(it.color)
    }
    val (enclosedArea, borderLength, borderWithArea) = instructions.map { it.direction to it.distance }.loopInfo()
    "Enclosed area size: $enclosedArea\nBorder length: $borderLength\nSize of border and enclosed area: $borderWithArea".println()
    return borderWithArea
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
    val border = instructions.sumOf { it.distance }
    val points = mutableListOf(Point.ZERO)
    instructions.forEach { instruction ->
        points.add(points.last().move(instruction.direction, instruction.distance))
    }
    // The answer is the area + half the border points + 1 (see explanation.png)
    return points.sizeOfEnclosedArea() + border / 2 + 1
}
