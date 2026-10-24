plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "io.github.lakomoor.openpocket"
    compileSdk = 34
    defaultConfig {
        applicationId = "io.github.lakomoor.openpocket"
        minSdk = 24
        targetSdk = 34
        versionCode = 9
        versionName = "1.7.1"
    }
    buildTypes {
        release {
            isMinifyEnabled = false
            signingConfig = signingConfigs.getByName("debug")   // installable APK without a keystore
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions { jvmTarget = "17" }
    buildFeatures { compose = true }
    sourceSets["main"].assets.srcDir(layout.buildDirectory.dir("ideAssets"))
    composeOptions { kotlinCompilerExtensionVersion = "1.5.14" }
}

dependencies {
    implementation(platform("androidx.compose:compose-bom:2024.06.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.activity:activity-compose:1.9.0")
    implementation("androidx.documentfile:documentfile:1.0.1")
    implementation("androidx.webkit:webkit:1.11.0")
    implementation("com.github.mik3y:usb-serial-for-android:3.8.1")
}

// The IDE page reuses Studio's board simulator and its Monaco editor (C and a few languages only).
// Run `npm install` in apps/studio first.
val studio = rootProject.file("../studio")
val ideAssets = tasks.register<Copy>("ideAssets") {
    val monaco = File(studio, "node_modules/monaco-editor/min/vs")
    doFirst { if (!monaco.isDirectory) throw GradleException("run npm install in apps/studio first (Monaco for the IDE)") }
    into(layout.buildDirectory.dir("ideAssets/ide"))
    from(File(studio, "sim")) { include("cpu.js", "board.js", "sim.js"); into("sim") }
    from(monaco) {
        include("loader.js", "editor/**", "base/**", "basic-languages/cpp/**", "basic-languages/python/**",
            "basic-languages/shell/**", "basic-languages/markdown/**")
        into("monaco/vs")
    }
}
tasks.named("preBuild") { dependsOn(ideAssets) }
