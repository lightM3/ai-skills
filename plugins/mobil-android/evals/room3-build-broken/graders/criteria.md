---
type: llm
---

Grade only the code and build files in the answer; it doesn't matter that the agent could not write files.

Facts (Room 3.0.3, official migration guide): package `androidx.room3`; `@TypeConverter`/`@TypeConverters`/`@ProvidedTypeConverter`/`addTypeConverter` → `@ColumnTypeConverter`/`@ColumnTypeConverters`/`@ProvidedColumnTypeConverter`/`addColumnTypeConverter`; `PagingSource` return types need `@DaoReturnTypeConverters(PagingSourceDaoReturnTypeConverter::class)` (import `androidx.room3.paging.PagingSourceDaoReturnTypeConverter`) and the `androidx.room3:room3-paging` artifact; `@RawQuery` takes `RoomRawQuery(sql, onBindStatement = { it.bindText(1, ...) })` instead of `SupportSQLiteQuery`/`SimpleSQLiteQuery`; non-observable DAO functions (`upsertAll`, `search`) must be `suspend`; `RoomDatabase.Callback.onCreate` receives a `SQLiteConnection` (suspend, `executeSQL`) instead of `SupportSQLiteDatabase`.

PASS if the answer:
- switches all imports to `androidx.room3` and applies the four converter renames;
- adds the `PagingSourceDaoReturnTypeConverter` registration and the `room3-paging` dependency;
- replaces `SupportSQLiteQuery`/`SimpleSQLiteQuery` with `RoomRawQuery`;
- makes `upsertAll` and `search` suspend (and adjusts `searchByMaxPrice`);
- rewrites the `onCreate` callback with `SQLiteConnection`.

Award PASS if at least four of the five points are fully correct and none is wrong. FAIL if it downgrades the catalog back to `androidx.room` 2.x.
