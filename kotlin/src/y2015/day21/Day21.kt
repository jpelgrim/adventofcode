package y2015.day21

import util.println

private const val DAY = "day21" // https://adventofcode.com/2015/day/21

fun main() {
    solveDay1()
}

fun solveDay1() {
    var minCost = Int.MAX_VALUE
    var maxCost = Int.MIN_VALUE
    for (w in weapons) {
        for (a in armors) {
            for (r1 in rings) {
                for (r2 in rings - r1) {
                    val cost = w.cost + a.cost + r1.cost + r2.cost
                    val damage = w.damage + a.damage + r1.damage + r2.damage
                    val armor = w.armor + a.armor + r1.armor + r2.armor
                    val playerWins = play(damage, armor)
                    if (playerWins && cost < minCost) minCost = cost
                    if (!playerWins && cost > maxCost) maxCost = cost
                }
            }
        }
    }
    "The solution for $DAY part1 is: $minCost".println()
    "The solution for $DAY part2 is: $maxCost".println()
}

fun play(
    playerDamage: Int,
    playerArmor: Int,
): Boolean {
    var playerHP = 100
    var bossHP = 100
    while (playerHP > 0) {
        // Boss armor is 2
        bossHP -= (playerDamage - 2).coerceAtLeast(1)
        // Boss damage is 8
        playerHP -= (8 - playerArmor).coerceAtLeast(1)
        if (bossHP <= 0) return true
    }
    return false
}

data class Item(val name: String, val cost: Int, val damage: Int, val armor: Int)

val weapons = listOf(
    Item("Dagger", 8, 4, 0),
    Item("Shortsword", 10, 5, 0),
    Item("Warhammer", 25, 6, 0),
    Item("Longsword", 40, 7, 0),
    Item("Greataxe", 74, 8, 0)
)

val armors = listOf(
    Item("Nothing1", 0, 0, 0),
    Item("Leather", 13, 0, 1),
    Item("Chainmail", 31, 0, 2),
    Item("Splintmail", 53, 0, 3),
    Item("Bandedmail", 75, 0, 4),
    Item("Platemail", 102, 0, 5)
)

val rings = listOf(
    Item("Nothing2", 0, 0, 0),
    Item("Nothing3", 0, 0, 0),
    Item("Damage +1", 25, 1, 0),
    Item("Damage +2", 50, 2, 0),
    Item("Damage +3", 100, 3, 0),
    Item("Defense +1", 20, 0, 1),
    Item("Defense +2", 40, 0, 2),
    Item("Defense +3", 80, 0, 3)
)
