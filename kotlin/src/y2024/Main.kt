package y2024

import y2024.day01.solveDay1
import y2024.day02.solveDay2
import util.println
import kotlin.time.measureTime

private val solvers = listOf(
    { solveDay1() },
    { solveDay2() },
)

fun main() = solvers.forEachIndexed { index, solver ->
    "Day ${index + 1} took ${measureTime { solver() }}\n".println()
}
