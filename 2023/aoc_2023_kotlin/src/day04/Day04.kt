package day04

import println
import readLines
import kotlin.math.pow

private const val DAY = "day04"

// https://adventofcode.com/2023/day/4

fun main() {
    solveDay4()
}

fun solveDay4() {
    val input = "$DAY/example_input.txt".readLines()

    var solutionPart1 = 0

    val totalNrOfCards = mutableMapOf<Int, Int>()

    input.forEachIndexed { index, line ->
        // Add the original card to the total number of cards
        totalNrOfCards[index] = if (totalNrOfCards[index] != null) {
            totalNrOfCards[index]!! + 1
        } else {
            1
        }
        val winningNumbers =
            line.substringAfter(": ").split(" | ").map { it.trim().split(Regex(" +")) }
                .reduce { acc, list -> acc.intersect(list.toSet()).toList() }

        // part 1
        val cardValue = if (winningNumbers.isNotEmpty()) {
            2.0.pow((winningNumbers.size - 1)).toInt()
        } else 0
        solutionPart1 += cardValue

        // part 2
        for (i in 1..winningNumbers.size) {
            // This is the number of cards that we have for the current index.
            // I.e. we "win" this amount of cards and we need to add that number to the next indices
            val totalNumberOfCurrentCards = totalNrOfCards[index]!!
            totalNrOfCards[index + i] = if (totalNrOfCards[index + i] != null) {
                totalNrOfCards[index + i]!! + totalNumberOfCurrentCards
            } else {
                totalNumberOfCurrentCards
            }
        }
    }

    val solutionPart2 = totalNrOfCards.values.sum()

    "The solution for $DAY part1 is: $solutionPart1".println()
    "The solution for $DAY part2 is: $solutionPart2".println()
}
