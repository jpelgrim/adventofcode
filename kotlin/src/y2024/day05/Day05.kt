package y2024.day05

import util.ints
import util.println
import util.readLines

private const val DAY = "day05" // https://adventofcode.com/2024/day/5

fun main() {
    solveDay5()
}

fun solveDay5() {
    val lines = ("y2024/${DAY}/sample.txt").readLines()
    val rules = lines.filter { it.contains("|") }.map { it.ints() }
    val updates = lines.filter { it.contains(",") }.map { it.ints() }

    val solutionPart1 = updates
        .filterNot { updateNotCorrect(it, rules) }
        .sumOf { it[it.size / 2] }
    "The solution for $DAY part1 is: $solutionPart1".println()

    val solutionPart2 = updates
        .filter { updateNotCorrect(it, rules) }
        .sumOf { update ->
            val correctedUpdate = mutableListOf<Int>()
            update.forEach { page ->
                for (i in 0..correctedUpdate.size) {
                    val correction = mutableListOf<Int>()
                    correction.addAll(correctedUpdate)
                    correction.add(i, page)
                    if (!updateNotCorrect(correction, rules)) {
                        correctedUpdate.add(i, page)
                        break
                    }
                }
            }
            correctedUpdate[correctedUpdate.size / 2]
        }
    "The solution for $DAY part2 is: $solutionPart2".println()
}

private fun updateNotCorrect(
    update: List<Int>,
    rules: List<List<Int>>
): Boolean = update.any { page ->
    val pagesBefore = update.subList(0, update.indexOf(page))
    val rulePagesAfter = rules.filter { it[0] == page }.map { it[1] }
    if (pagesBefore.any { it in rulePagesAfter }) return@any true

    val pagesAfter = update.subList(update.indexOf(page) + 1, update.size)
    val rulePagesBefore = rules.filter { it[1] == page }.map { it[0] }
    return@any pagesAfter.any { it in rulePagesBefore }
}
