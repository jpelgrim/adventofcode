package y2025.day01

import util.println
import util.readLines
import util.verify

private const val DAY = "day01" // https://adventofcode.com/2025/day/1

fun main() {
    solveDay1()
}

fun solveDay1() {
    val input = "y2025/$DAY/sample.txt".readLines()
    verify(3, "Day 1 Part 1") { part1(input) }
    verify(6, "Day 1 Part 2") { part2(input) }
}

private fun part1(input: List<String>) : Int {
    var currentPosition = 50
    val solution = input.sumOf {
        val (newPosition, _) = it.rotateWithCrossings(currentPosition)
        currentPosition = newPosition
        return@sumOf if (currentPosition == 0) 1 else 0
    }
    "The solution for $DAY part 1 is: $solution".println()
    return solution
}

private fun part2(input: List<String>) : Int {
    var currentPosition = 50
    val solution = input.sumOf {
        val (newPosition, crossings) = it.rotateWithCrossings(currentPosition)
        currentPosition = newPosition
        return@sumOf if (currentPosition == 0) 1 else 0 + crossings
    }
    "The solution for $DAY part 2 is: $solution".println()
    return solution
}

private fun String.rotateWithCrossings(currentPosition: Int): Pair<Int, Int> {
    val direction = this.first()
    val steps = this.drop(1).toInt()
    var crossings = steps / 100 // No need to run full laps, but keep track
    val remainingSteps = steps % 100
    if (direction == 'R') {
        if (currentPosition + remainingSteps > 100) crossings++
        return (currentPosition + remainingSteps).mod(100) to crossings
    } else {
        if (currentPosition - remainingSteps < 0) crossings++
        if (currentPosition == 0) crossings-- // Correction for when we started at 0
        return (currentPosition - remainingSteps).mod(100) to crossings
    }
}
