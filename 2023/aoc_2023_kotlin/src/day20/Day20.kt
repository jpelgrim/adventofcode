package day20

import day20.PulseType.HIGH
import day20.PulseType.LOW
import util.lcm
import util.println
import util.readLines

private const val DAY = "day20" // https://adventofcode.com/2023/day/20

fun main() {
    solveDay20()
}

fun solveDay20() {
    val input = "$DAY/input_example.txt".readLines()
    val modules = buildModulesMap(input)
    var lowPulses = 0
    var highPulses = 0
    var buttonPresses = 0
    var solutionPart1 = 0
    val solutionPart2: Long
    val highPulseCountsRxInputs = mutableMapOf<String, MutableList<Int>>()
    while (true) {
        buttonPresses++
        if (highPulseCountsRxInputs.size == 4 && highPulseCountsRxInputs.values.all { it.size >= 2 }) {
            solutionPart2 = lcm(highPulseCountsRxInputs.values.map { (it[1] - it[0]).toLong() })
            break
        }
        val pulses = mutableListOf(modules["broadcaster"]!!.processPulse(null, LOW)!!)
        lowPulses++ // For the button push
        while (pulses.isNotEmpty()) {
            val signal = pulses.removeFirst()
            signal.destinationModuleIds.forEach { moduleId ->
                if (signal.type == HIGH) {
                    highPulses++
                    // Reasoning for part two:
                    // We need to record the first time the "rx" module receives a LOW pulse
                    // In my input the "xn" module is the only conjunction module that can send a pulse to "rx"
                    // For a conjunction module to send a LOW pulse, all its memorized inputs must be HIGH
                    // However, this can take a while… 😒
                    //
                    // In my input the inputs for "xn" are: ("hn", "mp", "xf","fz")
                    // We will record the number of button presses it takes for each input of "xn" to be HIGH
                    // We need at least two records to identify a repeating pattern for the input sources
                    // Then we calculate the lowest common multiple of all those numbers
                    if (signal.sourceModuleId in listOf("hn", "mp", "xf", "fz")) {
                        highPulseCountsRxInputs.getOrPut(signal.sourceModuleId) { mutableListOf() }.add(buttonPresses)
                    }
                } else {
                    lowPulses++
                }
                modules[moduleId]?.processPulse(signal.sourceModuleId, signal.type)?.let { newSignal ->
                    pulses.add(newSignal)
                }
            }
        }
        if (buttonPresses == 1000) {
            solutionPart1 = highPulses * lowPulses
        }
    }
    check(solutionPart1 == 806332748)
    "The solution for $DAY part1 is: $solutionPart1".println()
    check(solutionPart2 == 228060006554227)
    "The solution for $DAY part2 is: $solutionPart2".println()
}

private fun buildModulesMap(input: List<String>): Map<String, Module> {
    val modules = buildMap {
        input.forEach { line ->
            val (typeId, destinations) = line.split(" -> ")
            val type = if (typeId == "broadcaster") {
                "broadcaster"
            } else {
                when (typeId[0]) {
                    '%' -> "flip-flop"
                    '&' -> "conjunction"
                    else -> error("Unknown module type: $typeId")
                }
            }
            val id = if (typeId == "broadcaster") {
                "broadcaster"
            } else {
                typeId.substring(1)
            }
            val module = when (type) {
                "flip-flop" -> FlipFlop(id)
                "conjunction" -> Conjunction(id)
                "broadcaster" -> Broadcaster(id)
                else -> error("Unknown module type: $type")
            }
            module.addDestinations(destinations.split(", "))
            put(id, module)
        }
    }
    // Process all the modules which can send signals to a conjunction module and add them as inputs
    modules.values.filterIsInstance<Conjunction>().forEach { conjunction ->
        modules.filter { it.value.destinations.contains(conjunction.id) }.forEach { (id, _) ->
            conjunction.addInput(id)
        }
    }
    return modules
}

abstract class Module(val id: String, var state: Boolean = false) {

    val destinations = mutableListOf<String>()
    abstract fun processPulse(sourceModuleId: String?, type: PulseType): Pulse?

    fun addDestinations(moduleIds: List<String>) = destinations.addAll(moduleIds)

}

data class Pulse(val sourceModuleId: String, val type: PulseType, val destinationModuleIds: List<String>)

enum class PulseType { HIGH, LOW }

/**
 * Flip-flop modules (prefix %) are either on or off;
 * They are initially off.
 * If a flip-flop module receives a high pulse, it is ignored and nothing happens.
 * If a flip-flop module receives a low pulse, it flips between on and off.
 * If it was off, it turns on and sends a high pulse.
 * If it was on, it turns off and sends a low pulse.
 *
 */
class FlipFlop(id: String, state: Boolean = false) : Module(id, state) {
    override fun processPulse(sourceModuleId: String?, type: PulseType): Pulse? {
        if (type == LOW) {
            state = !state
            return if (state) {
                Pulse(id, HIGH, destinations)
            } else {
                Pulse(id, LOW, destinations)
            }
        }
        return null
    }

    override fun toString() = "FlipFlop(id=$id, state=$state, destinations=$destinations)\n"

}

/**
 * Conjunction modules (prefix &) remember the type of the most recent pulse received
 * from each of their connected input modules;
 * they initially default to remembering a low pulse for each input.
 * When a pulse is received, the conjunction module first updates its memory for that input.
 * If it remembers high pulses for all inputs it sends a low pulse; otherwise, it sends a high pulse.
 */
class Conjunction(id: String, state: Boolean = false) : Module(id, state) {

    private val memory = mutableMapOf<String, PulseType>()
    override fun processPulse(sourceModuleId: String?, type: PulseType): Pulse {
        if (sourceModuleId == null) error("sourceModuleId cannot be null")
        memory[sourceModuleId] = type
        return if (memory.values.all { it == HIGH }) {
            Pulse(id, LOW, destinations)
        } else {
            Pulse(id, HIGH, destinations)
        }
    }

    fun addInput(moduleId: String) {
        memory[moduleId] = LOW
    }

    override fun toString() = "Conjunction(id=$id, state=$state, memory=$memory, destinations=$destinations)\n"

}

// There is a single broadcast module (named broadcaster).
// When it receives a pulse, it sends the same pulse to all of its destination modules.
// A broadcast module only sends signals to flip-flop modules
class Broadcaster(id: String, state: Boolean = false) : Module(id, state) {
    override fun processPulse(sourceModuleId: String?, type: PulseType) = Pulse(id,type,destinations)

    override fun toString() = "Broadcaster(id=$id, state=$state, destinations=$destinations)\n"
}
