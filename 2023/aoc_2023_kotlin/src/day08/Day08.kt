package day08

import util.lcm
import util.println
import util.readLines

private const val DAY = "day08" // https://adventofcode.com/2023/day/8

fun main() {
    solveDay8()
}

fun solveDay8() {
    val inputPart1 = "$DAY/input_example.txt".readLines()
    check(solvePart1(inputPart1) == 6)
    "The solution for $DAY part1 is: ${solvePart1(inputPart1)}".println()

    val inputPart2 = "$DAY/input_example2.txt".readLines()
    check(solvePart2(inputPart2) == 6L)
    "The solution for $DAY part2 is: ${solvePart2(inputPart2)}".println()
}

fun solvePart1(input: List<String>): Int {
    val leftRightInstructions = input[0].toCharArray()
    val nodes = input.subList(2, input.size).associate {
        val (key, leftRightPair) = it.split(" = ")
        key to leftRightPair.substring(1, leftRightPair.length - 1).split(", ")
    }
    var steps = 0
    var currentNode = "AAA"
    while (true) {
        val nextInstruction = leftRightInstructions[steps % leftRightInstructions.size]
        currentNode = if (nextInstruction == 'L') {
            nodes[currentNode]!![0]
        } else {
            nodes[currentNode]!![1]
        }
        steps++
        if (currentNode == "ZZZ") break
    }
    return steps
}

fun solvePart2(input: List<String>): Long {
    val leftRightInstructions = input[0].toCharArray()
    val nodes = input.subList(2, input.size).associate {
        val (key, leftRightPair) = it.split(" = ")
        key to leftRightPair.substring(1, leftRightPair.length - 1).split(", ")
    }
    val startNodes = nodes.keys.filter { it.endsWith("A") }
    val repeatingPatternLengths = mutableListOf<Long>()
    // For each start node, find the repeating pattern length
    startNodes.forEach { node ->
        var steps = 0L
        var currentNode = node
        val endNodesPatterns = mutableListOf<Long>()
        while (true) {
            val nextInstruction =
                leftRightInstructions[(steps % leftRightInstructions.size).toInt()]
            currentNode = if (nextInstruction == 'L') {
                nodes[currentNode]!![0]
            } else {
                nodes[currentNode]!![1]
            }
            if (currentNode.endsWith("Z")) {
                endNodesPatterns.add(steps)
            }
            steps++
            if (endNodesPatterns.size == 3) {
                repeatingPatternLengths.add(endNodesPatterns[2] - endNodesPatterns[1])
                break
            }
        }
    }
    return lcm(repeatingPatternLengths)
}
