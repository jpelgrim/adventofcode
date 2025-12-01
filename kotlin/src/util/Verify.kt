package util

inline fun verify(expected: Any? = null, desc: String = "", op: () -> Any) {
    val result = op()
    if (expected != null) check(result.toString() == expected.toString()) { "$desc failed! got $result, expected $expected" }
}
