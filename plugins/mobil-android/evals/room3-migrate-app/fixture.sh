#!/usr/bin/env bash
set -e
J=app/src/main/java/com/acme/notes/data
mkdir -p $J gradle
cat > gradle/libs.versions.toml <<'G'
[versions]
agp = "9.5.0"
kotlin = "2.3.0"
room = "2.7.2"

[libraries]
room-runtime = { group = "androidx.room", name = "room-runtime", version.ref = "room" }
room-ktx = { group = "androidx.room", name = "room-ktx", version.ref = "room" }
room-compiler = { group = "androidx.room", name = "room-compiler", version.ref = "room" }
lifecycle-livedata = { group = "androidx.lifecycle", name = "lifecycle-livedata-ktx", version = "2.9.4" }

[plugins]
android-application = { id = "com.android.application", version.ref = "agp" }
legacy-kapt = { id = "com.android.legacy-kapt", version.ref = "agp" }
G
cat > app/build.gradle.kts <<'G'
plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.legacy.kapt)
}
android {
    namespace = "com.acme.notes"
    compileSdk = 37
    defaultConfig { applicationId = "com.acme.notes"; minSdk = 26; targetSdk = 37 }
}
dependencies {
    implementation(libs.room.runtime)
    implementation(libs.room.ktx)
    kapt(libs.room.compiler)
    implementation(libs.lifecycle.livedata)
}
G
cat > $J/Note.kt <<'K'
package com.acme.notes.data

import androidx.room.Entity
import androidx.room.PrimaryKey
import java.time.Instant

@Entity(tableName = "notes")
data class Note(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val title: String,
    val body: String,
    val updatedAt: Instant,
    val pinned: Boolean = false,
)
K
cat > $J/Converters.kt <<'K'
package com.acme.notes.data

import androidx.room.TypeConverter
import java.time.Instant

class Converters {
    @TypeConverter fun toInstant(value: Long?): Instant? = value?.let(Instant::ofEpochMilli)
    @TypeConverter fun fromInstant(value: Instant?): Long? = value?.toEpochMilli()
}
K
cat > $J/NoteDao.kt <<'K'
package com.acme.notes.data

import androidx.lifecycle.LiveData
import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query
import androidx.room.Update

@Dao
interface NoteDao {
    @Query("SELECT * FROM notes ORDER BY pinned DESC, updatedAt DESC")
    fun observeAll(): LiveData<List<Note>>

    @Query("SELECT * FROM notes WHERE id = :id")
    fun byId(id: Long): Note?

    @Insert
    fun insert(note: Note): Long

    @Update
    fun update(note: Note)

    @Query("DELETE FROM notes WHERE id IN (:ids)")
    fun deleteAll(ids: List<Long>)
}
K
cat > $J/NotesDatabase.kt <<'K'
package com.acme.notes.data

import android.content.Context
import androidx.room.Database
import androidx.room.InvalidationTracker
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import androidx.room.migration.Migration
import androidx.room.withTransaction
import androidx.sqlite.db.SupportSQLiteDatabase
import java.util.concurrent.Executors

@Database(entities = [Note::class], version = 2, exportSchema = false)
@TypeConverters(Converters::class)
abstract class NotesDatabase : RoomDatabase() {
    abstract fun notes(): NoteDao

    companion object {
        val MIGRATION_1_2 = object : Migration(1, 2) {
            override fun migrate(db: SupportSQLiteDatabase) {
                db.execSQL("ALTER TABLE notes ADD COLUMN pinned INTEGER NOT NULL DEFAULT 0")
            }
        }

        fun create(context: Context): NotesDatabase =
            Room.databaseBuilder(context, NotesDatabase::class.java, "notes.db")
                .addMigrations(MIGRATION_1_2)
                .setQueryExecutor(Executors.newFixedThreadPool(4))
                .build()
    }
}

/** Moves several notes to the archive atomically. */
suspend fun NotesDatabase.archive(ids: List<Long>, archive: suspend (List<Note>) -> Unit) {
    withTransaction {
        val items = ids.mapNotNull { notes().byId(it) }
        archive(items)
        notes().deleteAll(ids)
    }
}

/** Tells the home-screen widget to refresh whenever notes change. */
class WidgetRefresher(db: NotesDatabase, private val refresh: () -> Unit) {
    private val observer = object : InvalidationTracker.Observer("notes") {
        override fun onInvalidated(tables: Set<String>) = refresh()
    }
    init { db.invalidationTracker.addObserver(observer) }
}
K
