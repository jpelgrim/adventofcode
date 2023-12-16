package day13

import util.println
import util.readText
import util.transposed

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
    findMirrorIndexFuzzy(listOfRows).let { if (it > 0) return@sumOf it * 100 }
    findMirrorIndexFuzzy(listOfRows.transposed()).let { if (it > 0) return@sumOf it }
    return@sumOf 0
}

fun solvePart2(matrices: List<List<String>>) = matrices.sumOf { listOfRows ->
    findMirrorIndexFuzzy(listOfRows, 1).let { if (it > 0) return@sumOf it * 100 }
    findMirrorIndexFuzzy(listOfRows.transposed(), 1).let { if (it > 0) return@sumOf it }
    return@sumOf 0
}

private fun findMirrorIndexFuzzy(
    list: List<String>,
    fuzziness: Int = 0,
): Int {
    (1..<list.size).forEach { index ->
        var charsDifferent = 0
        for (i in 0..index) {
            if (index + i >= list.size || index - i - 1 < 0) break
            charsDifferent += charsDifferent(list[index + i], list[index - i - 1])
        }
        if (charsDifferent == fuzziness) return index
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
