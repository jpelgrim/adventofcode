package y2023.day02

import util.println
import util.readLines

private const val DAY = "day02" // https://adventofcode.com/2023/day/2

fun main() {
    solveDay2()
}

fun solveDay2() {

    val inputPart1 = "y2023/$DAY/input_example.txt".readLines()
    val solutionPart1 = solvePart1(inputPart1)
    "The solution for $DAY part1 is: $solutionPart1".println()

    val inputPart2 = "y2023/$DAY/input_example.txt".readLines()
    val solutionPart2 = solvePart2(inputPart2)
    "The solution for $DAY part2 is: $solutionPart2".println()
}

fun solvePart1(input: List<String>): Int {
    var runningSum = 0
    val maxAllowed = mapOf(
        "red" to 12, "green" to 13, "blue" to 14
    )
    for (game in input) {
        val (gameNameAndId, drawString) = game.split(": ")
        val gameId = gameNameAndId.split(" ")[1].toInt()
        val draws = drawString.split("; ")
        var allDrawsValid = true
        for (draw in draws) {
            val groups = draw.split(", ")
            for (group in groups) {
                val (count, color) = group.split(" ")
                if (count.toInt() > maxAllowed[color]!!) {
                    allDrawsValid = false
                    break
                }
            }
            if (!allDrawsValid) break
        }
        if (allDrawsValid) {
            runningSum += gameId
        }
    }
    return runningSum
}

fun solvePart2(input: List<String>): Int {
    var runningSum = 0
    for (game in input) {
        val minCubes = mutableMapOf(
            "red" to Int.MIN_VALUE, "green" to Int.MIN_VALUE, "blue" to Int.MIN_VALUE
        )
        val (_, drawString) = game.split(": ")
        val draws = drawString.split("; ")
        for (draw in draws) {
            val groups = draw.split(", ")
            for (group in groups) {
                val (count, color) = group.split(" ")
                if (count.toInt() > minCubes[color]!!) {
                    minCubes[color] = count.toInt()
                }
            }
        }
        runningSum += minCubes.values.fold(1) { acc, i -> acc * i }
    }
    return runningSum
}
