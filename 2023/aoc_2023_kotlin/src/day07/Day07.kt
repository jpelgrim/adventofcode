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
    return input.map { it.split(" ") }.sortedWith(HandComparatorPart1())
        .foldIndexed(0) { index, acc, list ->
            acc + (index + 1) * list[1].toInt()
        }
}

fun solvePart2(input: List<String>): Int {
    return input.map { it.split(" ") }.sortedWith(HandComparatorPart2())
        .foldIndexed(0) { index, acc, list ->
            acc + (index + 1) * list[1].toInt()
        }
}

class HandComparatorPart1 : java.util.Comparator<List<String>> {
    override fun compare(hand1: List<String>, hand2: List<String>): Int {
        val handType1 = hand1[0].handType()
        val handType2 = hand2[0].handType()
        if (handType1 > handType2) return 1
        if (handType1 < handType2) return -1
        // We have an equal hand type, so we need to compare the cards
        val hand1Cards = hand1[0].toCharArray()
        val hand2Cards = hand2[0].toCharArray()
        for (i in 0..<5) {
            val card1 = hand1Cards[i].cardValue()
            val card2 = hand2Cards[i].cardValue()
            if (card1 > card2) return 1
            if (card1 < card2) return -1
        }
        return 0
    }
}

class HandComparatorPart2 : java.util.Comparator<List<String>> {
    override fun compare(hand1: List<String>, hand2: List<String>): Int {
        val handType1 = hand1[0].handTypePart2()
        val handType2 = hand2[0].handTypePart2()
        if (handType1 > handType2) return 1
        if (handType1 < handType2) return -1
        // We have an equal hand type, so we need to compare the cards
        val hand1Cards = hand1[0].toCharArray()
        val hand2Cards = hand2[0].toCharArray()
        for (i in 0..<5) {
            val card1 = if (hand1Cards[i] == 'J') 1 else hand1Cards[i].cardValue()
            val card2 = if (hand2Cards[i] == 'J') 1 else hand2Cards[i].cardValue()
            if (card1 > card2) return 1
            if (card1 < card2) return -1
        }
        return 0
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

private fun String.handType(): Int {
    // Extract groups of cards by their denomination
    val cardGroups = this.toCharArray().groupBy { it }

    // Five of a Kind: Five cards of the same value --> 7
    if (cardGroups.values.any { it.size == 5 }) return 7

    // Four of a Kind: Four cards of the same value and one unmatched card --> 6
    if (cardGroups.values.any { it.size == 4 }) return 6

    // Full House: Three cards of the same value, with the remaining two cards forming a pair --> 5
    if (cardGroups.values.any { it.size == 3 } && cardGroups.values.any { it.size == 2 }) return 5

    // Three of a Kind: Three cards of the same value and two unmatched cards --> 4
    if (cardGroups.values.any { it.size == 3 }) return 4

    // Two Pairs: Two cards of the same value, another two cards of the same value, and one unmatched card --> 3
    if (cardGroups.values.filter { it.size == 2 }.size == 2) return 3

    // One Pair: Two cards of the same value and three unmatched cards --> 2
    if (cardGroups.values.any { it.size == 2 }) return 2

    // High Card: Five unmatched cards --> 1
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
