def total_value(items, max_weight):
    return sum([x[2] for x in items]) if sum([x[1] for x in items]) <= max_weight else 0


cache = {}


def solve(items, max_weight):
    if not items:
        return ()
    if (items, max_weight) not in cache:
        head = items[0]
        tail = items[1:]
        include = (head,) + solve(tail, max_weight - head[1])
        dont_include = solve(tail, max_weight)
        if total_value(include, max_weight) > total_value(dont_include, max_weight):
            answer = include
        else:
            answer = dont_include
        cache[(items, max_weight)] = answer
    return cache[(items, max_weight)]


items = (
    ("1", 0.4, 90), ("2", 0.7, 98), ("3", 0.6, 71), ("4", 0.7, 5),
    ("5", 0.7, 10), ("6", 0.2, 62), ("7", 0.2, 41), ("8", 0.9, 53), ("9", 0.6, 86), ("10", 0.7, 77),
    ("11", 0.9, 24), ("12", 0.9, 27), ("13", 0.3, 43), ("14", 0.9, 16), ("15", 0.2, 4), ("16", 0.3, 43),
    ("17", 0.2, 89), ("18", 0.3, 59), ("19", 0.9, 88), ("20", 1, 11), ("21", 0.2, 54), ("22", 0.6, 49),
    ("23", 0.2, 60), ("24", 0.2, 67), ("25", 0.4, 29), ("26", 0.1, 22), ("27", 0.4, 58), ("28", 0.6, 18),
    ("29", 0.6, 24), ("30", 1, 83), ("31", 0.3, 41), ("32", 0.4, 90)
)
max_weight = 4.98

solution = solve(items, max_weight)
print("items:")
for x in solution:
    print(x[0])
print ("value:", total_value(solution, max_weight))
print("weight:", sum([x[1] for x in solution]))