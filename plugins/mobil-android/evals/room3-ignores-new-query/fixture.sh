#!/usr/bin/env bash
set -e
J=app/src/main/java/com/acme/notes/data
mkdir -p $J
cat > app/build.gradle.kts <<'G'
plugins { id("com.android.application"); id("com.google.devtools.ksp") }
android { namespace = "com.acme.notes"; compileSdk = 37 }
dependencies {
    implementation("androidx.room:room-runtime:2.8.4")
    ksp("androidx.room:room-compiler:2.8.4")
}
G
cat > $J/NoteDao.kt <<'K'
package com.acme.notes.data

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query
import kotlinx.coroutines.flow.Flow

@Dao
interface NoteDao {
    @Query("SELECT * FROM notes ORDER BY pinned DESC, updatedAt DESC")
    fun observeAll(): Flow<List<Note>>

    @Insert
    suspend fun insert(note: Note): Long
}
K
