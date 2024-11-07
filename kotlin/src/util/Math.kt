@file:Suppress("unused")

package util

/**
 * Returns the greatest common divisor of two numbers.
 */
fun gcd(a: Int, b: Int): Int = if (b == 0) a else gcd(b, a % b)

/**
 * Returns the least common multiple of two numbers.
 */
fun lcm(a: Int, b: Int): Int = a * b / gcd(a, b)

/**
 * Returns the least common multiple of a list of numbers.
 */
fun lcm(numbers: List<Int>) =
    numbers.reduce { acc, l -> lcm(acc, l) } / numbers.reduce { acc, l -> gcd(acc, l) }

/**
 * Returns the greatest common divisor of two Long numbers.
 */
fun gcd(a: Long, b: Long): Long = if (b == 0L) a else gcd(b, a % b)

/**
 * Returns the least common multiple of two Long numbers.
 */
fun lcm(a: Long, b: Long): Long = a * (b / gcd(a, b))

/**
 * Returns the least common multiple of a list of Long numbers.
 */
fun lcm(numbers: List<Long>) =
    numbers.reduce { acc, l -> lcm(acc, l) } / numbers.reduce { acc, l -> gcd(acc, l) }
