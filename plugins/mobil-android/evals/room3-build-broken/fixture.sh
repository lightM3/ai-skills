#!/usr/bin/env bash
set -e
J=app/src/main/java/com/acme/shop/data
mkdir -p $J gradle
cat > gradle/libs.versions.toml <<'G'
[versions]
agp = "9.5.0"
kotlin = "2.3.0"
ksp = "2.3.0-2.0.4"
room = "3.0.3"
paging = "3.3.6"

[libraries]
room-runtime = { group = "androidx.room3", name = "room3-runtime", version.ref = "room" }
room-compiler = { group = "androidx.room3", name = "room3-compiler", version.ref = "room" }
paging-runtime = { group = "androidx.paging", name = "paging-runtime", version.ref = "paging" }

[plugins]
android-application = { id = "com.android.application", version.ref = "agp" }
ksp = { id = "com.google.devtools.ksp", version.ref = "ksp" }
G
cat > app/build.gradle.kts <<'G'
plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.ksp)
}
android {
    namespace = "com.acme.shop"
    compileSdk = 37
    defaultConfig { applicationId = "com.acme.shop"; minSdk = 26; targetSdk = 37 }
}
dependencies {
    implementation(libs.room.runtime)
    ksp(libs.room.compiler)
    implementation(libs.paging.runtime)
}
G
cat > $J/Product.kt <<'K'
package com.acme.shop.data

import androidx.room.Entity
import androidx.room.PrimaryKey
import java.math.BigDecimal

@Entity
data class Product(@PrimaryKey val sku: String, val name: String, val price: BigDecimal, val tags: List<String>)
K
cat > $J/Converters.kt <<'K'
package com.acme.shop.data

import androidx.room.ProvidedTypeConverter
import androidx.room.TypeConverter
import java.math.BigDecimal
import kotlinx.serialization.json.Json

@ProvidedTypeConverter
class Converters(private val json: Json) {
    @TypeConverter fun fromDecimal(v: BigDecimal): String = v.toPlainString()
    @TypeConverter fun toDecimal(v: String): BigDecimal = BigDecimal(v)
    @TypeConverter fun fromTags(v: List<String>): String = json.encodeToString(v)
    @TypeConverter fun toTags(v: String): List<String> = json.decodeFromString(v)
}
K
cat > $J/ProductDao.kt <<'K'
package com.acme.shop.data

import androidx.paging.PagingSource
import androidx.room.Dao
import androidx.room.Query
import androidx.room.RawQuery
import androidx.room.Upsert
import androidx.sqlite.db.SupportSQLiteQuery
import kotlinx.coroutines.flow.Flow

@Dao
interface ProductDao {
    @Query("SELECT * FROM Product ORDER BY name")
    fun paged(): PagingSource<Int, Product>

    @Query("SELECT COUNT(*) FROM Product")
    fun count(): Flow<Int>

    @Upsert
    fun upsertAll(items: List<Product>)

    /** Filter screen builds the WHERE clause dynamically. */
    @RawQuery
    fun search(query: SupportSQLiteQuery): List<Product>
}
K
cat > $J/ShopDatabase.kt <<'K'
package com.acme.shop.data

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import androidx.sqlite.db.SimpleSQLiteQuery
import androidx.sqlite.db.SupportSQLiteDatabase
import kotlinx.serialization.json.Json

@Database(entities = [Product::class], version = 1)
@TypeConverters(Converters::class)
abstract class ShopDatabase : RoomDatabase() {
    abstract fun products(): ProductDao

    companion object {
        fun create(context: Context, json: Json) =
            Room.databaseBuilder(context, ShopDatabase::class.java, "shop.db")
                .addTypeConverter(Converters(json))
                .addCallback(object : Callback() {
                    override fun onCreate(db: SupportSQLiteDatabase) {
                        db.execSQL("CREATE INDEX IF NOT EXISTS idx_product_name ON Product(name)")
                    }
                })
                .build()
    }
}

fun ProductDao.searchByMaxPrice(max: String) =
    search(SimpleSQLiteQuery("SELECT * FROM Product WHERE CAST(price AS REAL) <= ?", arrayOf(max)))
K
