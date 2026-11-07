#!/usr/bin/env bash
set -e
mkdir -p build-logic/convention/src/main/kotlin app feature/home
cat > settings.gradle.kts <<'G'
pluginManagement {
    includeBuild("build-logic")
    repositories { google(); mavenCentral(); gradlePluginPortal() }
}
plugins {
    id("com.android.application") version "9.1.0" apply false
    id("com.android.library") version "9.1.0" apply false
}
rootProject.name = "Shop"
include(":app", ":feature:home")
G
cat > build-logic/convention/build.gradle.kts <<'G'
plugins { `kotlin-dsl` }
dependencies {
    compileOnly("com.android.tools.build:gradle:9.1.0")
}
gradlePlugin {
    plugins {
        register("androidConvention") {
            id = "shop.android"
            implementationClass = "AndroidConventionPlugin"
        }
    }
}
G
cat > build-logic/convention/src/main/kotlin/AndroidConventionPlugin.kt <<'K'
import com.android.build.api.dsl.CommonExtension
import com.android.build.gradle.BaseExtension
import org.gradle.api.JavaVersion
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.kotlin.dsl.getByType

class AndroidConventionPlugin : Plugin<Project> {
    override fun apply(target: Project) {
        with(target) {
            pluginManager.withPlugin("com.android.base") {
                // shared defaults for app and library modules
                val android = extensions.getByType<BaseExtension>()
                android.compileSdkVersion(36)
                android.defaultConfig { minSdk = 26 }
                android.compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_17
                    targetCompatibility = JavaVersion.VERSION_17
                }

                val common = extensions.getByType(CommonExtension::class.java) as CommonExtension<*, *, *, *, *, *>
                common.lint { abortOnError = false }
            }
        }
    }
}
K
cat > app/build.gradle.kts <<'G'
plugins {
    id("com.android.application")
    id("shop.android")
}
android {
    namespace = "com.acme.shop"
    defaultConfig { applicationId = "com.acme.shop"; targetSdk = 36 }
}
G
cat > feature/home/build.gradle.kts <<'G'
plugins {
    id("com.android.library")
    id("shop.android")
}
android { namespace = "com.acme.shop.home" }
G
cat > gradle.properties <<'G'
android.useAndroidX=true
G
