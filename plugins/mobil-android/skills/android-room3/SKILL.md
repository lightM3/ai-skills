---
name: android-room3
description: Migrating an Android / Kotlin Multiplatform app from Room 2.x (androidx.room) to Room 3 (androidx.room3), or fixing code that fails to compile after Room dependencies were bumped to room3 — TypeConverter / ProvidedTypeConverter renames, LiveData / PagingSource / RxJava / Guava DAO return types, SupportSQLiteDatabase migrations and callbacks, SupportSQLiteQuery raw queries, withTransaction, InvalidationTracker.Observer, executors, kapt. Holds the current Room 3 versions and API mapping. Not for writing ordinary DAO queries or entities on an unchanged Room version.
---

# Room 2.x → Room 3 migration

Room 3 is newer than the model's training data. **Use this mapping, not remembered Room 2 APIs**
(verified 2026-11-20 on developer.android.com/jetpack/androidx/releases/room3 and the official guide
developer.android.com/training/data-storage/room/migration-2-to-3; re-check after 2027-02-28):

| | Version |
|---|---|
| Room 3 stable | **3.0.3** (9 Sep 2026); 3.0.0 stable 1 Jul 2026 |
| Room 3 next | 3.1.0-alpha04 (18 Nov 2026) — libraries need kotlinc 2.2 from 3.1.0-alpha03 |
| Room 2.x | maintenance mode (bug-fix patches only); 2.8 is the "prepare" step |
| androidx.sqlite (drivers) | 2.7.1 (9 Sep 2026) |

## What changes

- **New Maven group and package**: `androidx.room3` everywhere — `androidx.room3:room3-runtime`,
  `ksp("androidx.room3:room3-compiler")`; `import androidx.room.*` → `import androidx.room3.*`
  Room 2 and 3 use different packages, so they don't conflict during a staged migration.
- **KSP only**: kapt, `com.android.legacy-kapt` and `annotationProcessor` are not supported; Room 3 generates
  Kotlin only (Java sources are still accepted as input). Apply `com.google.devtools.ksp`.
- **Coroutines first**: every DAO function must be `suspend` unless it returns an observable type
  (`Flow`, or a type with a DAO return type converter). Executors → `setQueryCoroutineContext(...)`.
- **No SupportSQLite** in core APIs: migrations, callbacks, raw queries and transactions use `androidx.sqlite`
  driver APIs (`SQLiteConnection`, `SQLiteStatement`).
- **Driver**: configure a `SQLiteDriver` with `setDriver(...)` — `AndroidSQLiteDriver`
  (`androidx.sqlite:sqlite-framework`, the platform SQLite) or `BundledSQLiteDriver`
  (`androidx.sqlite:sqlite-bundled`, SQLite compiled into the app, used in the official test examples).
  *Not verified*: whether Room 3 has a default driver on Android when `setDriver` is omitted — the official
  examples always call it, so do the same.

## API mapping

| Room 2.x | Room 3 |
|---|---|
| `androidx.room:room-runtime` / `room-ktx` / `kapt(room-compiler)` | `androidx.room3:room3-runtime` + `ksp("androidx.room3:room3-compiler")` (no `room3-ktx` is listed; coroutine APIs are in the runtime) |
| `@TypeConverter` / `@TypeConverters` | `@ColumnTypeConverter` / `@ColumnTypeConverters` |
| `@ProvidedTypeConverter` / `Builder.addTypeConverter(x)` | `@ProvidedColumnTypeConverter` / `Builder.addColumnTypeConverter(x)` |
| blocking `fun insert(...)`, `fun byId(...): T?` | `suspend fun ...` |
| `LiveData<T>` return | `@DaoReturnTypeConverters(LiveDataDaoReturnTypeConverter::class)` + `androidx.room3:room3-livedata` — or switch to `Flow` |
| `PagingSource<K, V>` return | `@DaoReturnTypeConverters(PagingSourceDaoReturnTypeConverter::class)` (`androidx.room3.paging.`) + `androidx.room3:room3-paging` |
| RxJava 3 `Observable/Flowable/Single/Maybe/Completable` | `RxDaoReturnTypeConverters` + `androidx.room3:room3-rxjava3` (RxJava 2 not listed) |
| `ListenableFuture` | `GuavaDaoReturnTypeConverter` + `androidx.room3:room3-guava` |
| `Migration.migrate(db: SupportSQLiteDatabase)` + `db.execSQL(...)` | `override suspend fun migrate(connection: SQLiteConnection)` + `connection.executeSQL(...)` (`import androidx.sqlite.async.executeSQL`) |
| `Callback.onCreate/onOpen(db: SupportSQLiteDatabase)` | `override suspend fun onCreate(connection: SQLiteConnection)` |
| `@RawQuery fun f(q: SupportSQLiteQuery)`, `SimpleSQLiteQuery(sql, args)` | `@RawQuery suspend fun f(q: RoomRawQuery)`, `RoomRawQuery(sql) { it.bindText(1, x) }` (1-based `bindText/bindLong/bindInt/bindDouble/bindNull`) |
| `db.withTransaction { }` / `runInTransaction { }` | `db.withWriteTransaction { }` / `db.withReadTransaction { }` |
| `InvalidationTracker.Observer` + `addObserver/removeObserver` | `db.invalidationTracker.createFlow("table").collect { ... }` (collect in a scope you control) |
| `setQueryExecutor` / `setTransactionExecutor` | `setQueryCoroutineContext(Dispatchers.IO)` |
| `db.openHelper.writableDatabase`, `query(...)` cursors | `db.useReaderConnection { c -> c.usePrepared(sql) { st -> while (st.step()) ... } }` / `useWriterConnection`; legacy code: `androidx.room3:room3-sqlite-wrapper` → `roomDatabase.getSupportWrapper()` (temporary) |
| `clearAllTables()` (blocking) | `suspend fun clearAllTables()` |
| `@Relation(parentColumn=..., entityColumn=...)` | `parentColumns` / `entityColumns` are **arrays** (composite keys) |
| `Room.databaseBuilder(ctx, Db::class.java, "x.db")` | `Room.databaseBuilder<Db>(ctx, "x.db")` (reified form used in all official examples) |

```kotlin
import androidx.room3.*
import androidx.room3.migration.Migration
import androidx.sqlite.SQLiteConnection
import androidx.sqlite.async.executeSQL
import androidx.sqlite.driver.AndroidSQLiteDriver

@Database(entities = [Note::class], version = 2)
@ColumnTypeConverters(Converters::class)
abstract class NotesDatabase : RoomDatabase() {
    abstract fun notes(): NoteDao
}

@Dao
@DaoReturnTypeConverters(LiveDataDaoReturnTypeConverter::class) // only if keeping LiveData
interface NoteDao {
    @Query("SELECT * FROM notes") fun observeAll(): LiveData<List<Note>>
    @Query("SELECT * FROM notes WHERE id = :id") suspend fun byId(id: Long): Note?
    @Insert suspend fun insert(note: Note): Long
}

val MIGRATION_1_2 = object : Migration(1, 2) {
    override suspend fun migrate(connection: SQLiteConnection) {
        connection.executeSQL("ALTER TABLE notes ADD COLUMN pinned INTEGER NOT NULL DEFAULT 0")
    }
}

val db = Room.databaseBuilder<NotesDatabase>(context, "notes.db")
    .setDriver(AndroidSQLiteDriver())
    .setQueryCoroutineContext(Dispatchers.IO)
    .addMigrations(MIGRATION_1_2)
    .build()
```

*Not verified* (check the API reference / IDE before relying on them): the package of `Migration`
(shown as `androidx.room3.migration`, mirroring Room 2), exact import paths of
`AndroidSQLiteDriver`/`BundledSQLiteDriver` and of `LiveDataDaoReturnTypeConverter`
(`androidx.room3.livedata.`?), the Rx/Guava converter usage, and the Room 3 migration-test helper
(`MigrationTestHelper` / a `room3-testing` artifact are not mentioned in the Room 3 docs). Say so in the
answer rather than guessing.

## Workflow

1. Read the version catalog/build files and every `@Database`, `@Dao`, entity, converter, migration and
   callback; grep for `androidx.room.`, `SupportSQLite`, `withTransaction`, `runInTransaction`,
   `InvalidationTracker`, `openHelper`, `LiveData`, `PagingSource`, `rxjava`, `kapt`.
2. If the app is large or uses lots of SupportSQLite code, recommend the official two-phase route:
   phase 1 on Room **2.8** (KSP, suspend DAOs, driver APIs, `createFlow`, `RoomRawQuery`,
   `useWriterConnection { it.immediateTransaction { } }` — 2.8 still runs SupportSQLite code until
   `setDriver` is called); phase 2 swap to `androidx.room3` and apply the renames. For a small app,
   do it in one step.
3. Apply every row of the mapping that the code triggers; keep the schema version and migrations intact.
   Show each changed file in full.
4. Callers of newly `suspend` DAO functions must move into coroutines (ViewModel `viewModelScope`,
   `withContext`). Point out every call site you changed or that still needs changing.
5. Remind: after `setDriver`, any leftover `SupportSQLiteDatabase` access throws at runtime.

## Rules

- Don't downgrade the catalog back to `androidx.room` 2.x to make a room3 build compile.
- Don't keep kapt for Room 3.
- If something isn't in the mapping above, say it's not verified instead of inventing an API name.
