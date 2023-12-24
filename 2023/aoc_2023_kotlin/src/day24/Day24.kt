package day24

import util.println
import util.readLines
import java.io.File
import java.math.BigDecimal
import java.math.BigDecimal.ZERO

private const val DAY = "day24" // https://adventofcode.com/2023/day/24

fun main() {
    solveDay24()
}

fun solveDay24() {
    val input = "$DAY/input_example.txt".readLines()
    val stones = input.map { line ->
        line.split(" @ ").map {
            it.split(", ").map { n ->
                n.trim().toBigDecimal()
            }
        }.map {
            Point(it[0], it[1], it[2])
        }
    }
    var solutionPart1 = 0
    val low = BigDecimal(7)
    val high = BigDecimal(27)

    // Part 1
    stones.indices.forEach { i1 ->
        (i1 + 1..<stones.size).forEach inner@{ i2 ->
            try {
                val l1 = line(stones[i1][0], stones[i1][0] + stones[i1][1])
                val l2 = line(stones[i2][0], stones[i2][0] + stones[i2][1])
                val iP = intersection(l1, l2)
                if (inTheFuture(stones[i1], iP) && inTheFuture(
                        stones[i2], iP
                    ) && iP.x in low..high && iP.y in low..high
                ) {
                    solutionPart1++
                }
            } catch (e: ArithmeticException) {
                // No intersection
                return@inner
            }
        }
    }
    "The solution for $DAY part1 is: $solutionPart1".println()

    val text = buildString {
        appendLine("(declare-const fx Int)")
        appendLine("(declare-const fy Int)")
        appendLine("(declare-const fz Int)")
        appendLine("(declare-const fdx Int)")
        appendLine("(declare-const fdy Int)")
        appendLine("(declare-const fdz Int)")
        stones.take(3).forEachIndexed { index, stone ->
            appendLine("(declare-const t$index Int)")
            appendLine("(assert (>= t$index 0))")
            appendLine("(assert (= (+ ${stone[0].x} (* ${stone[1].x} t$index)) (+ fx (* fdx t$index))))")
            appendLine("(assert (= (+ ${stone[0].y} (* ${stone[1].y} t$index)) (+ fy (* fdy t$index))))")
            appendLine("(assert (= (+ ${stone[0].z} (* ${stone[1].z} t$index)) (+ fz (* fdz t$index))))")
        }
        appendLine("(check-sat)")
        appendLine("(get-model)")
        appendLine("(eval (+ fx fy fz))")
    }

    val solutionPart2: String
    File("day24.z3").run {
        deleteOnExit()
        writeText(text)
        val process = Runtime.getRuntime().exec("z3 day24.z3")
        solutionPart2 = String(process.inputStream.readBytes()).substringAfterLast(")").trim()
    }
    "The solution for $DAY part2 is: $solutionPart2".println()

}

data class Point(val x: BigDecimal, val y: BigDecimal, val z: BigDecimal) {

    operator fun plus(other: Point): Point {
        return Point(x + other.x, y + other.y, z + other.z)
    }

    operator fun minus(other: Point): Point {
        return Point(x - other.x, y - other.y, z - other.z)
    }

    operator fun div(factor: BigDecimal): Point {
        return Point(x / factor, y / factor, z / factor)
    }

    override fun toString(): String {
        return "$x, $y, $z"
    }

}

fun inTheFuture(stone: List<Point>, intersection: Point) =
    ((((stone[1].x > ZERO && intersection.x > stone[0].x) || (stone[1].x < ZERO && intersection.x < stone[0].x)) && (((stone[1].y > ZERO && intersection.y > stone[0].y) || (stone[1].y < ZERO && intersection.y < stone[0].y)))))

fun line(p1: Point, p2: Point): List<BigDecimal> {
    val a = p1.y - p2.y
    val b = p2.x - p1.x
    val c = p1.x * p2.y - p2.x * p1.y
    return listOf(a, b, -c)
}

fun intersection(l1: List<BigDecimal>, l2: List<BigDecimal>): Point {
    val d = l1[0] * l2[1] - l1[1] * l2[0]
    val dX = l1[2] * l2[1] - l1[1] * l2[2]
    val dY = l1[0] * l2[2] - l1[2] * l2[0]
    if (d != ZERO) {
        val x = dX / d
        val y = dY / d
        return Point(x, y, ZERO)
    } else {
        throw ArithmeticException("Lines do not intersect")
    }
}
