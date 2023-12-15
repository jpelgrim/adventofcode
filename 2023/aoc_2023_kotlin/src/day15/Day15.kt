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

fun String.hashAlgorithm() = fold(0) { acc, i -> (acc + i.code) * 17 % 256 }

fun solvePart1(input: List<String>) = input.sumOf { it.hashAlgorithm() }

fun solvePart2(input: List<String>): Int {
    val map = mutableMapOf<Int, MutableList<Pair<String, Int>>>()
    input.forEach { step ->
        if (step.contains("=")) {
            val (label, value) = step.split("=")
            val labelHash = label.hashAlgorithm()
            val list = map.getOrPut(labelHash) { mutableListOf() }
            list.firstOrNull { it.first == label }?.let {
                // Replace the value if the label already exists
                val index = list.indexOf(it)
                list.remove(it)
                list.add(index, label to value.toInt())
            } ?: list.add(label to value.toInt())
        } else {
            val (label, _) = step.split("-")
            val labelHash = label.hashAlgorithm()
            map[labelHash]?.let { list ->
                list.firstOrNull { it.first == label }?.let { list.remove(it) }
                if (list.isEmpty()) map.remove(labelHash)
            }
        }
    }
    return map.entries.sumOf { entry ->
        entry.value.foldIndexed(0) { index, sum, pair ->
            sum + (pair.second * (index + 1) * (entry.key + 1))
        }.toInt()
    }
}
