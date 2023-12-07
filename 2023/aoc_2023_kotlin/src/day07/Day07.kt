package day07

import println
import readLines

private const val DAY = "day07" // https://adventofcode.com/2023/day/7

fun main() {
    solveDay7()
}

fun solveDay7() {
    val input = "$DAY/input_example.txt".readLines()
    "The solution for $DAY part1 is: ${solvePart1(input)}".println()
    "The solution for $DAY part2 is: ${solvePart2(input)}".println()
}

fun solvePart1(input: List<String>): Int {
    return input.map { it.split(" ") }.sortedWith(
        compareBy(
            { it[0].handType() },
            { it[0].toCharArray()[0].cardValue() },
            { it[0].toCharArray()[1].cardValue() },
            { it[0].toCharArray()[2].cardValue() },
            { it[0].toCharArray()[3].cardValue() },
            { it[0].toCharArray()[4].cardValue() },
        )
    ).foldIndexed(0) { index, acc, list ->
            acc + (index + 1) * list[1].toInt()
        }
}

fun solvePart2(input: List<String>): Int {
    return input.map { it.split(" ") }.sortedWith(
        compareBy(
            { it[0].handTypePart2() },
            { it[0].toCharArray()[0].cardValuePart2() },
            { it[0].toCharArray()[1].cardValuePart2() },
            { it[0].toCharArray()[2].cardValuePart2() },
            { it[0].toCharArray()[3].cardValuePart2() },
            { it[0].toCharArray()[4].cardValuePart2() },
        )
    ).foldIndexed(0) { index, acc, list ->
        acc + (index + 1) * list[1].toInt()
    }
}

private fun Char.cardValue() = when {
    this.isDigit() -> this - '0'
    this == 'A' -> 14
    this == 'K' -> 13
    this == 'Q' -> 12
    this == 'J' -> 11
    this == 'T' -> 10
    else -> 0
}

private fun Char.cardValuePart2() = when {
    this == 'J' -> 1
    else -> cardValue()
}

private fun String.handType(): Int {
    val cardGroups = this.toCharArray().groupBy { it }
    if (cardGroups.values.any { it.size == 5 }) return 7
    if (cardGroups.values.any { it.size == 4 }) return 6
    if (cardGroups.values.any { it.size == 3 } && cardGroups.values.any { it.size == 2 }) return 5
    if (cardGroups.values.any { it.size == 3 }) return 4
    if (cardGroups.values.filter { it.size == 2 }.size == 2) return 3
    if (cardGroups.values.any { it.size == 2 }) return 2
    return 1
}

private fun String.handTypePart2(): Int {
    var maxHandType = this.handType()
    if (this.contains("J")) {
        val otherCards = this.replace("J", "").toCharArray()
        for (element in otherCards) {
            val newHand = this.replace("J", element.toString())
            val handType = newHand.handType()
            if (handType > maxHandType) maxHandType = handType
        }
    }
    return maxHandType
}
