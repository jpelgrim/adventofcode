package util

import util.Direction.DOWN
import util.Direction.LEFT
import util.Direction.RIGHT
import util.Direction.UP
import kotlin.math.absoluteValue
import kotlin.math.atan2

data class Point(val x: Long, val y: Long) {

    constructor(x: Int, y: Int) : this(x.toLong(), y.toLong())

    fun adjacent(includeDiagonal: Boolean = false): List<Point> {
        val horizontal = listOf(
            Point(x = x, y = y - 1),
            Point(x = x, y = y + 1),
            Point(x = x - 1, y = y),
            Point(x = x + 1, y = y),
        )
        return if (includeDiagonal) {
            val diagonal = listOf(
                Point(x = x - 1, y = y - 1),
                Point(x = x - 1, y = y + 1),
                Point(x = x + 1, y = y - 1),
                Point(x = x + 1, y = y + 1),
            )
            horizontal + diagonal
        } else {
            horizontal
        }
    }

    fun manhattanDistanceTo(other: Point): Long {
        return (x - other.x).absoluteValue + (y - other.y).absoluteValue
    }

    fun degreesTo(other: Point) = (Math.toDegrees(
        atan2(
            y = (other.y - this.y).toDouble(),
            x = (other.x - this.x).toDouble(),
        )
    ) + 90 + 360) % 360

    fun isInPath(path: List<Point>): Boolean {
        // https://en.wikipedia.org/wiki/Point_in_polygon#Ray_casting_algorithm
        var count = 0
        var previous = path.last()
        path.forEach { current ->
            if (previous.y > y != current.y > y && x < (current.x - previous.x) * (y - previous.y) / (current.y - previous.y) + previous.x) {
                count++
            }
            previous = current
        }
        return count % 2 != 0
    }

    fun move(
        direction: Direction,
        steps: Int = 1,
    ): Point {
        if (steps == 0) return this
        return when (direction) {
            UP -> Point(x, y - steps)
            DOWN -> Point(x, y + steps)
            RIGHT -> Point(x + steps, y)
            LEFT -> Point(x - steps, y)
        }
    }

    override fun toString(): String = "($x,$y)"

    operator fun plus(other: Point): Point = Point(x = x + other.x, y = y + other.y)

    companion object {
        val ZERO = Point(0, 0)
        fun parse(from: String): Point {
            val (x, y) = from.split(",")
            return Point(x = x.toLong(), y = y.toLong())
        }
    }
}

fun Point.withinBounds(width: Int, height: Int) = x in 0 until width && y in 0 until height

fun Collection<Point>.printString(): String = associateWith { }.printString {
    if (it in this) "█" else " "
}

inline fun <T> Map<Point, T>.printString(crossinline tile: (Point) -> String): String {
    if (isEmpty()) {
        return "EMPTY MAP"
    }
    val bounds = keys.bounds()
    return (bounds.top..bounds.bottom).joinToString(
        separator = "\n",
        prefix = buildString {
            append('╔')
            append("═".repeat(1 + (bounds.right - bounds.left).toInt()))
            append('╗')
            appendLine()
        },
        postfix = buildString {
            appendLine()
            append('╚')
            append("═".repeat(1 + (bounds.right - bounds.left).toInt()))
            append('╝')
        },
    ) { y ->
        (bounds.left..bounds.right).joinToString(separator = "", prefix = "║", postfix = "║") { x ->
                tile(Point(x, y))
            }
    }
}

fun Collection<Point>.print() {
    println(printString())
}

inline fun <T> Map<Point, T>.print(crossinline tile: (Point) -> String) {
    println(printString(tile))
}

fun Collection<Point>.bounds(): Rect {
    return Rect(
        left = minOf { it.x },
        right = maxOf { it.x },
        top = minOf { it.y },
        bottom = maxOf { it.y },
    )
}

// Calculate the size of the area of a list of (clockwise, ordered) points using the shoelace formula
// See https://en.wikipedia.org/wiki/Shoelace_formula
fun List<Point>.sizeOfEnclosedArea(): Long {
    val x = map(Point::x)
    val y = map(Point::y)
    val left = y.drop(1).zip(x, Long::times)
    val right = x.drop(1).zip(y, Long::times)
    return left.zip(right, Long::minus).sum() / 2
}
