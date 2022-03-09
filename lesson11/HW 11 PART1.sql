
CREATE TABLE data_for_merge2
(
	Function_name nvarchar(30),
	Function_count INT
)
SELECT * FROM data_for_merge
SELECT * FROM data_for_merge2


MERGE data_for_merge2 target
USING data_for_merge source ON target.Function_name=source.a
WHEN NOT MATCHED BY TARGET
	THEN INSERT (Function_name, Function_count)
	VALUES (source.a, 1);

MERGE data_for_merge2 target
USING data_for_merge source ON target.Function_name=source.b 
WHEN MATCHED AND target.Function_name = source.b 
	THEN UPDATE SET target.Function_count = target.Function_count+1
WHEN NOT MATCHED BY TARGET AND source.b IS NOT NULL
THEN INSERT (Function_name, Function_count)
VALUES (source.b, 1);

MERGE data_for_merge2 target
USING data_for_merge source ON target.Function_name=source.c
WHEN MATCHED AND target.Function_name = source.c
	THEN UPDATE SET target.Function_count = target.Function_count+1
WHEN NOT MATCHED BY TARGET AND source.c IS NOT NULL
THEN INSERT (Function_name, Function_count)
VALUES (source.c, 1);

MERGE data_for_merge2 target
USING data_for_merge source ON target.Function_name=source.d
WHEN MATCHED AND target.Function_name = source.d
	THEN UPDATE SET target.Function_count = target.Function_count+1
WHEN NOT MATCHED BY TARGET AND source.d IS NOT NULL
THEN INSERT (Function_name, Function_count)
VALUES (source.d, 1);

MERGE data_for_merge2 target
USING data_for_merge source ON target.Function_name=source.e
WHEN MATCHED AND target.Function_name = source.e
	THEN UPDATE SET target.Function_count = target.Function_count+1
WHEN NOT MATCHED BY TARGET AND source.e IS NOT NULL
THEN INSERT (Function_name, Function_count)
VALUES (source.e, 1);

MERGE data_for_merge2 target
USING data_for_merge source ON target.Function_name=source.f
WHEN MATCHED AND target.Function_name = source.f
	THEN UPDATE SET target.Function_count = target.Function_count+1
WHEN NOT MATCHED BY TARGET AND source.f IS NOT NULL
THEN INSERT (Function_name, Function_count)
VALUES (source.f, 1);

MERGE data_for_merge2 target
USING data_for_merge source ON target.Function_name=source.g
WHEN MATCHED AND target.Function_name = source.g
	THEN UPDATE SET target.Function_count = target.Function_count+1
WHEN NOT MATCHED BY TARGET AND source.g IS NOT NULL
THEN INSERT (Function_name, Function_count)
VALUES (source.g, 1);

MERGE data_for_merge2 target
USING data_for_merge source ON target.Function_name=source.h
WHEN MATCHED AND target.Function_name = source.h
	THEN UPDATE SET target.Function_count = target.Function_count+1
WHEN NOT MATCHED BY TARGET AND source.h IS NOT NULL
THEN INSERT (Function_name, Function_count)
VALUES (source.h, 1);

MERGE data_for_merge2 target
USING data_for_merge source ON target.Function_name=source.i
WHEN MATCHED AND target.Function_name = source.i
	THEN UPDATE SET target.Function_count = target.Function_count+1
WHEN NOT MATCHED BY TARGET AND source.i IS NOT NULL
THEN INSERT (Function_name, Function_count)
VALUES (source.i, 1);

SELECT * FROM data_for_merge2
ORDER BY 2 DESC

