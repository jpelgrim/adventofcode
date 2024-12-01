@file:Suppress("unused")
package util

import java.io.File
import java.math.BigInteger
import java.security.MessageDigest

fun String.readLines(): List<String> {
    "Reading file: $this".println()
    croakIfUsingSampleInput()

    return File("src", this).readLines()
}

private fun String.croakIfUsingSampleInput() {
    if (contains("ample")) {
        "⚠️ WARNING 🧝‍ YOU ARE USING SAMPLE INPUT‼️☠️".println()
    }
}

fun String.readBytes(): ByteArray {
    croakIfUsingSampleInput()

    return File("src", this).readBytes()
}

fun String.readText(): String {
    croakIfUsingSampleInput()

    return File("src", this).readText()
}

/**
 * Converts string to md5 hash.
 */
fun String.md5() = BigInteger(1, MessageDigest.getInstance("MD5").digest(toByteArray()))
    .toString(16)
    .padStart(32, '0')

/**
 * The cleaner shorthand for printing output.
 */
fun Any?.println() = println(this)

/**
 * Transposes a matrix of characters, represented as a list of strings.
 *
 * Example:
 * listOf("123", "456", "789").transposed()
 *
 * Output:
 * ["147", "258", "369"]
 *
 */
fun List<String>.transposed() = first().indices.map {
    buildString { for (line in this@transposed) append(line[it]) }
}

fun <T> List<List<T>>.flipped() = first().indices.map {
    buildList<T> { for (item in this@flipped) add(item[it]) }
}

fun String.ints() = Regex("""-?\d+""").findAll(this).map { it.value.toInt() }.toList()
fun String.longs() = Regex("""-?\d+""").findAll(this).map { it.value.toLong() }.toList()

fun List<String>.ints() = map { it.ints() }
