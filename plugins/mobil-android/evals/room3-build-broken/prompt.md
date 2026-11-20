---
description: Dependencies already bumped to room3 3.0.3 but code still uses Room 2 APIs (TypeConverter, ProvidedTypeConverter/addTypeConverter, PagingSource, SupportSQLiteQuery RawQuery, blocking DAO, onCreate callback). Expect ColumnTypeConverter/ProvidedColumnTypeConverter/addColumnTypeConverter, PagingSourceDaoReturnTypeConverter + room3-paging, RoomRawQuery, suspend, SQLiteConnection callback.
tags: [android-room3, android-hard, v3]
max_turns: 14
allowed_tools: [Read, Glob, Grep, Skill]
---

A teammate updated our Room dependencies and now the project doesn't compile. Fix the data layer code (and the build file if needed) so it builds against what's in the version catalog. Show the full updated files.
