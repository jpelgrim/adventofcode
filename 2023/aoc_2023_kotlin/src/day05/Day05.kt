package day05

import println
import readLines

private const val DAY = "day05" // https://adventofcode.com/2023/day/5

fun main() {
    solveDay5()
}

fun solveDay5() {
    val input = "$DAY/part1_example.txt".readLines()

    val seedsPart1 = input[0].substringAfter(": ").split(" ").map { it.toLong() }

    val maps = mutableMapOf<Pair<String, String>, MutableList<MapRule>>()

    lateinit var activeKey: Pair<String, String>
    for (index in 2..input.lastIndex) {
        if (input[index].contains("-to-")) {
            val (source, dest) = input[index].substringBefore(" ").split("-to-")
            activeKey = Pair(source, dest)
            maps[activeKey] = mutableListOf()
            continue
        }
        if (input[index].isEmpty()) continue
        maps[activeKey]!!.add(MapRule.fromString(input[index]))
    }

    val solutionPart1 = findLowestLocation(seedsPart1, maps)
    "The solution for $DAY part1 is: $solutionPart1".println()

    var solutionPart2 = Long.MAX_VALUE
    for (index in 0..<seedsPart1.size / 2) {
        for (i in 0 until seedsPart1[index * 2 + 1]) {
            val lowestLocation = findLowestLocation(listOf(seedsPart1[index * 2] + i), maps)
            if (lowestLocation < solutionPart2) {
                solutionPart2 = lowestLocation
            }
        }
    }

    "The solution for $DAY part2 is: $solutionPart2".println()
}


private fun findLowestLocation(
    seeds: List<Long>, maps: MutableMap<Pair<String, String>, MutableList<MapRule>>
): Long {
    var lowestLocation = Long.MAX_VALUE

    for (seed in seeds) {
        val soil = maps[Pair("seed", "soil")]!!.filter { it.canMap(seed) }.map { it.map(seed) }
            .firstOrNull() ?: seed
        val fertilizer =
            maps[Pair("soil", "fertilizer")]!!.filter { it.canMap(soil) }.map { it.map(soil) }
                .firstOrNull() ?: soil
        val water = maps[Pair("fertilizer", "water")]!!.filter { it.canMap(fertilizer) }
            .map { it.map(fertilizer) }.firstOrNull() ?: fertilizer
        val light = maps[Pair("water", "light")]!!.filter { it.canMap(water) }.map { it.map(water) }
            .firstOrNull() ?: water
        val temperature =
            maps[Pair("light", "temperature")]!!.filter { it.canMap(light) }.map { it.map(light) }
                .firstOrNull() ?: light
        val humidity = maps[Pair("temperature", "humidity")]!!.filter { it.canMap(temperature) }
            .map { it.map(temperature) }.firstOrNull() ?: temperature
        val location = maps[Pair("humidity", "location")]!!.filter { it.canMap(humidity) }
            .map { it.map(humidity) }.firstOrNull() ?: humidity
        if (location < lowestLocation) {
            lowestLocation = location
        }
    }
    return lowestLocation
}

private class MapRule(val sourceStart: Long, val destStart: Long, val length: Long) {

    fun canMap(value: Long) = value in sourceStart..(sourceStart + length)

    fun map(value: Long) = destStart + (value - sourceStart)

    companion object {
        fun fromString(input: String): MapRule {
            val (destStart, sourceStart, length) = input.split(" ").map { it.toLong() }
            return MapRule(sourceStart, destStart, length)
        }
    }

}