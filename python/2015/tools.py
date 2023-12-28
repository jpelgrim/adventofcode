def map_many(iterable, function, *other):
    if other:
        return map_many(map(function, iterable), *other)
    return map(function, iterable)
