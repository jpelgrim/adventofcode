package day15

import println
import readText

private const val DAY = "day15" // https://adventofcode.com/2023/day/15

fun main() {
    solveDay15()
}

fun solveDay15() {
    val exampleInput = "$DAY/input_example.txt".readText().split(",")
    val solutionPart1 = solvePart1(exampleInput)
    check(solutionPart1 == 1320)
    "The solution for $DAY part1 is: $solutionPart1".println()

    val solutionPart2 = solvePart2(exampleInput)
    check(solutionPart2 == 145)
    "The solution for $DAY part2 is: $solutionPart2".println()
}

fun String.hashed() = fold(0) { acc, i -> (acc + i.code) * 17 % 256 }

fun solvePart1(input: List<String>) = input.sumOf { it.hashed() }

fun solvePart2(input: List<String>): Int {
    val boxes = MutableList(256) { mutableListOf<Pair<String, Int>>() }
    input.forEach { step ->
        val (label, value) = step.split("=", "-")
        val hash = label.hashed()
        if (value.isNotEmpty()) {
            val index = boxes[hash].indexOfFirst { it.first == label }
            val lens = label to value.toInt()
            if (index >= 0) boxes[hash][index] = lens else boxes[hash] += lens
        } else {
            boxes[hash].removeIf { it.first == label }
        }
    }
    return boxes.flatMapIndexed { boxIndex, box ->
        box.mapIndexed { lensIndex, lens -> (1 + boxIndex) * (1 + lensIndex) * lens.second }
    }.sum()
}
