package day13

import println
import readText

private const val DAY = "day13"

fun main() {
    solveDay13()
}

fun solveDay13() {
    val input = "$DAY/input_example.txt".readText().split("\n\n").map { it.split("\n") }
    "The solution for $DAY part1 is: ${solvePart1(input)}".println()
    "The solution for $DAY part2 is: ${solvePart2(input)}".println()
}

fun solvePart1(matrices: List<List<String>>) = matrices.sumOf { listOfRows ->
    findMirrorIndex(listOfRows).let { if (it > 0) return@sumOf it * 100 }
    findMirrorIndex(transpose(listOfRows)).let { if (it > 0) return@sumOf it }
    return@sumOf 0
}

fun solvePart2(matrices: List<List<String>>) = matrices.sumOf { listOfRows ->
    findMirrorIndexFuzzy(listOfRows).let { if (it > 0) return@sumOf it * 100 }
    findMirrorIndexFuzzy(transpose(listOfRows)).let { if (it > 0) return@sumOf it }
    return@sumOf 0
}

fun transpose(list: List<String>): List<String> {
    val transposed = mutableListOf<String>()
    val width = list[0].length
    for (i in 0..<width) {
        val sb = StringBuilder()
        for (j in list.indices) {
            sb.append(list[j][i])
        }
        transposed.add(sb.toString())
    }
    return transposed
}

private fun findMirrorIndex(
    list: List<String>,
): Int {
    (1..<list.size).forEach { index ->
        var matchFound = true
        for (i in 0..index) {
            if (index + i >= list.size || index - i - 1 < 0) break
            if (list[index + i] != list[index - i - 1]) {
                matchFound = false
                break
            }
        }
        if (matchFound) return index
    }
    return 0
}

private fun findMirrorIndexFuzzy(
    list: List<String>,
): Int {
    (1..<list.size).forEach { index ->
        var charsDifferent = 0
        for (i in 0..index) {
            if (index + i >= list.size || index - i - 1 < 0) break
            charsDifferent += charsDifferent(list[index + i], list[index - i - 1])
        }
        if (charsDifferent == 1) return index
    }
    return 0
}

fun charsDifferent(first: String, second: String): Int {
    var count = 0
    for (i in first.indices) {
        if (first[i] != second[i]) count++
    }
    return count
}
