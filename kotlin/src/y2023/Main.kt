import y2023.day01.solveDay1
import y2023.day02.solveDay2
import y2023.day03.solveDay3
import y2023.day04.solveDay4
import y2023.day05.solveDay5
import y2023.day06.solveDay6
import y2023.day07.solveDay7
import y2023.day08.solveDay8
import y2023.day09.solveDay9
import y2023.day10.solveDay10
import y2023.day11.solveDay11
import y2023.day12.solveDay12
import y2023.day13.solveDay13
import y2023.day14.solveDay14
import y2023.day15.solveDay15
import y2023.day16.solveDay16
import y2023.day17.solveDay17
import y2023.day18.solveDay18
import y2023.day19.solveDay19
import y2023.day20.solveDay20
import y2023.day21.solveDay21
import y2023.day22.solveDay22
import y2023.day23.solveDay23
import y2023.day24.solveDay24
import y2023.day25.solveDay25
import util.println
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
