package day25

import util.println
import util.readLines
import kotlin.random.Random

private const val DAY = "day25" // https://adventofcode.com/2023/day/25

fun main() {
    solveDay25()
}

fun solveDay25() {
    val input = "$DAY/input.txt".readLines()

    val graph = mutableSetOf<Node>()

    input.forEach {line ->
        val (source, adjacencies) = line.split(": ")
        val sourceNode = graph.getOrNew(source)
        adjacencies.split(" ").forEach { dest ->
            val destNode = graph.getOrNew(dest)
            destNode.adjacencies.add(sourceNode)
            sourceNode.adjacencies.add(destNode)
        }
    }

    val nodeList = graph.toList()
    val traversedEdges = mutableMapOf<Edge, Int>()
    val rand = Random(12345)
    repeat (500) {
        val from = nodeList.random(rand)
        val to = nodeList.random(rand)
        if (from != to) {
            from.findRandomPath(to, rand).forEach {
                traversedEdges[it] = 1 + (traversedEdges[it] ?: 0)
            }
        }
    }

    val mostTraversedEdges = traversedEdges.toList().sortedByDescending { it.second }
    mostTraversedEdges.take(3).forEach { (edge, _) -> graph.getOrNew(edge.from).removeAdjacency(graph.getOrNew(edge.to)) }

    val ball1 = graph.getOrNew(mostTraversedEdges[0].first.from).bfs().size
    val total = graph.size
    val solutionPart1 = ball1 * (total - ball1)

    "The solution for $DAY is: $solutionPart1".println()
}

private fun MutableSet<Node>.getOrNew(id: String) = firstOrNull { it.id == id } ?: Node(id).also { this.add(it) }

class Node(val id: String, val adjacencies: MutableSet<Node> = mutableSetOf()) {
    fun removeAdjacency(node: Node) {
        adjacencies.remove(node)
        node.adjacencies.remove(this)
    }

    fun bfs(result: MutableSet<Node> = mutableSetOf()): Set<Node> {
        if (result.add(this)) {
            adjacencies.forEach { it.bfs(result) }
        }
        return result
    }

    private fun createUndirectedEdge(n1: Node, n2: Node): Edge = Edge(minOf(n1.id, n2.id), maxOf(n1.id, n2.id))

    fun findRandomPath(dest: Node, random: Random): Set<Edge> {
        val visited: MutableSet<Node> = mutableSetOf()
        val recursive = DeepRecursiveFunction<SearchState, Set<Edge>> { searchState ->
            if (!visited.add(searchState.source)) return@DeepRecursiveFunction emptySet()
            for (next in searchState.source.adjacencies.shuffled(random)) {
                if (next in visited) continue
                if (next == dest || callRecursive(searchState.copy(source = next)).isNotEmpty()) {
                    searchState.path += createUndirectedEdge(searchState.source, next)
                    break
                }
            }
            return@DeepRecursiveFunction searchState.path
        }
        return recursive.invoke(SearchState(this))
    }

    private data class SearchState(
        val source: Node,
        val path: MutableSet<Edge> = mutableSetOf(),
    )

    override fun equals(other: Any?): Boolean = other is Node && id == other.id

    override fun hashCode(): Int = id.hashCode()
}


data class Edge(val from: String, val to: String)
