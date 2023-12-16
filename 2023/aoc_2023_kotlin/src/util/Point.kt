package util

import util.Direction.DOWN
import util.Direction.LEFT
import util.Direction.RIGHT
import util.Direction.UP
import kotlin.math.absoluteValue
import kotlin.math.atan2

data class Point(val x: Int, val y: Int) {

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

    fun manhattanDistanceTo(other: Point): Int {
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

    override fun toString(): String = "($x,$y)"

    operator fun plus(other: Point): Point = Point(x = x + other.x, y = y + other.y)

    companion object {
        val Zero = Point(0, 0)
        fun parse(from: String): Point {
            val (x, y) = from.split(",")
            return Point(x = x.toInt(), y = y.toInt())
        }
    }
}

fun Point.withinBounds(width: Int, height: Int) = x in 0 until width && y in 0 until height

fun Point.move(
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
            append("═".repeat(1 + bounds.right - bounds.left))
            append('╗')
            appendLine()
        },
        postfix = buildString {
            appendLine()
            append('╚')
            append("═".repeat(1 + bounds.right - bounds.left))
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
