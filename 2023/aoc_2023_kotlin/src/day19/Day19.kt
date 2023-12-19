package day19

import util.println
import util.readText

private const val DAY = "day19" // https://adventofcode.com/2023/day/19

fun main() {
    solveDay19()
}

private const val X = 0
private const val M = 1
private const val A = 2
private const val S = 3

fun solveDay19() {

    val input = "$DAY/input_example.txt".readText()
    val (workflowInput, partInput) = input.split("\n\n")
    val workflows = buildMap {
        workflowInput.lines().forEach { line ->
            val (key, ruleString) = line.split("{")
            val rules = ruleString.dropLast(1).split(",").map { it.split(":") }
            put(key, rules)
        }
    }
    val parts = partInput.lines()
        .map { line -> line.drop(1).dropLast(1).split(",").map { it.substringAfter("=").toInt() } }

    fun doWorkflow(part: List<Int>, key: String): Boolean {
        if (key == "A") return true
        if (key == "R") return false
        val rules = workflows[key]!!
        for (rule in rules) {
            if (rule.size == 1) {
                if (rule[0] == "A") return true
                if (rule[0] == "R") return false
                return doWorkflow(part, rule[0])
            } else {
                val category = when (rule[0][0]) {
                    'x' -> X
                    'm' -> M
                    'a' -> A
                    else -> S
                }
                val comparator = rule[0][1]
                val boundary = rule[0].substring(2).toInt()
                when (comparator) {
                    '>' -> if (part[category] > boundary) return doWorkflow(part, rule[1])
                    '<' -> if (part[category] < boundary) return doWorkflow(part, rule[1])
                }
            }
        }
        return false
    }

    val solutionPart1 = parts.sumOf { part ->
        if (doWorkflow(part, "in")) part.sum() else 0
    }
    check(solutionPart1 == 19114) { "Expected 19114 but was $solutionPart1" }
    "The solution for $DAY part1 is: $solutionPart1".println()

    fun doWorkflowPart2(key: String, ranges: List<List<Int>>): List<Pair<String, List<List<Int>>>> {
        val result = mutableListOf<Pair<String, List<List<Int>>>>()
        if (key == "A") {
            result += "A" to ranges
        } else if (key != "R") {
            val rules = workflows[key]!!
            val currentRanges = ranges.toMutableList()
            for (rule in rules) {
                if (rule.size == 1) {
                    if (rule[0] == "A") {
                        result += "A" to currentRanges
                    } else if (rule[0] != "R") {
                        result += doWorkflowPart2(rule[0], currentRanges)
                    }
                } else {
                    val category = when (rule[0][0]) {
                        'x' -> X
                        'm' -> M
                        'a' -> A
                        else -> S
                    }
                    val comparator = rule[0][1]
                    val boundary = rule[0].substring(2).toInt()
                    val newRanges = currentRanges.toMutableList()
                    when (comparator) {
                        '>' -> {
                            val acceptedRange =
                                currentRanges[category].intersect(boundary + 1..4000)
                            newRanges[category] = acceptedRange.toList()
                            if (acceptedRange.isNotEmpty()) result += doWorkflowPart2(
                                rule[1],
                                newRanges
                            )
                            val rejectedRange = currentRanges[category].intersect(1..boundary)
                            currentRanges[category] = rejectedRange.toList()
                        }

                        '<' -> {
                            val acceptedRange = currentRanges[category].intersect(1..<boundary)
                            newRanges[category] = acceptedRange.toList()
                            if (acceptedRange.isNotEmpty()) result += doWorkflowPart2(
                                rule[1],
                                newRanges
                            )
                            val rejectedRange = currentRanges[category].intersect(boundary..4000)
                            currentRanges[category] = rejectedRange.toList()
                        }
                    }
                }
            }
        }
        return result
    }

    var solutionPart2 = 0L
    val partRanges = List(4) { List(4000) { it + 1 } }
    val toProcess = ArrayDeque<Pair<String, List<List<Int>>>>()
    toProcess.add("in" to partRanges)
    while (toProcess.isNotEmpty()) {
        val (key, ranges) = toProcess.removeFirst()
        val result = doWorkflowPart2(key, ranges)
        for ((newKey, newRanges) in result) {
            if (newKey == "A") {
                solutionPart2 += newRanges.fold(1L) { acc, list -> acc * list.count() }
            } else if (newKey != "R") {
                toProcess.add(newKey to newRanges)
            }
        }
    }
    check(solutionPart2 == 167409079868000) { "Expected 167409079868000 but was $solutionPart2" }
    "The solution for $DAY part2 is: $solutionPart2".println()
}
