package y2024.day11

import util.longs
import util.println
import util.readText

private const val DAY = "day11" // https://adventofcode.com/2024/day/11

fun main() {
    solveDay11()
}

fun solveDay11() {
    val input = "y2024/$DAY/sample.txt".readText().longs()

    var transformed = listOf(input)
    repeat(25) {
        transformed = transformed.flatten().map { it.transform() }
    }

    "The solution for $DAY part 1 is: ${transformed.flatten().size}".println()

    var transformedMap = buildMap<Long, Long> {
        input.forEach { value ->
            if (get(value) == null) put(value, 1)
            else put(value, get(value)!! + 1)
        }
    }
    repeat(75) {
        transformedMap = transformedMap.transform()
    }

    "The solution for $DAY part 2 is: ${transformedMap.values.sum()}".println()
}

fun Long.transform(): List<Long> {
    when {
        this == 0L -> return listOf(1)
        this.toString().length % 2 == 0 -> {
            val stringValue = this.toString()
            val left = stringValue.substring(0, stringValue.length / 2)
            val right = stringValue.substring(stringValue.length / 2)
            return listOf(left.toLong(), right.toLong())
        }
        else -> return listOf(this * 2024)
    }
}

fun Map<Long, Long>.transform(): Map<Long, Long> {
    val result = mutableMapOf<Long, Long>()
    forEach { (key, value) ->
        val transformed = key.transform()
        transformed.forEach {
            if (result[it] == null) result[it] = value
            else result[it] = result[it]!! + value
        }
    }
    return result
}
