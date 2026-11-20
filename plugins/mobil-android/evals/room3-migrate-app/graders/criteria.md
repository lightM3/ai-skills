---
type: llm
---

Grade only the code and build files in the answer; it doesn't matter that the agent could not write files.

Facts (Room 3.0, stable since 1 Jul 2026, latest 3.0.3; official guide developer.android.com/training/data-storage/room/migration-2-to-3): new Maven group and package `androidx.room3` (`androidx.room3:room3-runtime`, `ksp("androidx.room3:room3-compiler")`); KSP only (no kapt / legacy-kapt); `@TypeConverter`/`@TypeConverters` renamed `@ColumnTypeConverter`/`@ColumnTypeConverters`; DAO functions must be `suspend` unless they return an observable type; `LiveData` return types need `@DaoReturnTypeConverters(LiveDataDaoReturnTypeConverter::class)` from `androidx.room3:room3-livedata` (or switch to `Flow`); migrations override `suspend fun migrate(connection: SQLiteConnection)` and use `connection.executeSQL(...)` (`androidx.sqlite.async.executeSQL`); `SupportSQLiteDatabase` is gone from core APIs; executors are replaced by `setQueryCoroutineContext(...)`; `withTransaction` → `withWriteTransaction`; `InvalidationTracker.Observer`/`addObserver` removed → `invalidationTracker.createFlow("notes")`; a `SQLiteDriver` such as `AndroidSQLiteDriver` (`androidx.sqlite:sqlite-framework`) or `BundledSQLiteDriver` (`androidx.sqlite:sqlite-bundled`) is set with `setDriver(...)`.

PASS if the answer:
- moves to `androidx.room3` 3.0.x coordinates with `ksp(...)` and the KSP plugin, removing kapt;
- changes imports to `androidx.room3` and renames the type-converter annotations;
- makes the non-observable DAO functions `suspend` and handles `LiveData` (converter + room3-livedata, or a switch to `Flow`);
- rewrites the migration with `SQLiteConnection` (suspend `migrate`, `executeSQL`);
- replaces `withTransaction`, the executor and the `InvalidationTracker.Observer` with their Room 3 equivalents.

Award PASS if all five points are covered, or four are fully correct and the fifth is only partly done. FAIL if it stays on `androidx.room` 2.x as the "new major version", keeps kapt, or keeps `SupportSQLiteDatabase` in the migration.
