import day01.solveDay1
import day02.solveDay2
import day03.solveDay3
import day04.solveDay4
import day05.solveDay5
import day06.solveDay6
import day07.solveDay7
import day08.solveDay8
import day09.solveDay9
import day10.solveDay10
import day11.solveDay11
import day12.solveDay12
import day13.solveDay13
import day14.solveDay14
import day15.solveDay15
import day16.solveDay16
import day17.solveDay17
import day18.solveDay18
import day19.solveDay19
import day20.solveDay20
import day21.solveDay21
import day22.solveDay22
import day23.solveDay23
import day24.solveDay24
import day25.solveDay25
import kotlin.time.measureTime

private val solvers = listOf(
    { solveDay1() },
    { solveDay2() },
    { solveDay3() },
    { solveDay4() },
    { solveDay5() },
    { solveDay6() },
    { solveDay7() },
    { solveDay8() },
    { solveDay9() },
    { solveDay10() },
    { solveDay11() },
    { solveDay12() },
    { solveDay13() },
    { solveDay14() },
    { solveDay15() },
    { solveDay16() },
    { solveDay17() },
    { solveDay18() },
    { solveDay19() },
    { solveDay20() },
    { solveDay21() },
    { solveDay22() },
    { solveDay23() },
    { solveDay24() },
    { solveDay25() },
)

fun main() = solvers.forEachIndexed { index, solver ->
    "Day ${index + 1} took ${measureTime { solver() }}\n".println()
}
