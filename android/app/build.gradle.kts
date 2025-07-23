plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle"
}

def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
if (flutterVersionCode == null) {
    flutterVersionCode = '1'
}

def flutterVersionName = localProperties.getProperty('flutter.versionName')
if (flutterVersionName == null) {
    flutterVersionName = '1.0'
}

android {
    namespace "com.example.self_management_app" // Pastikan ini sesuai dengan package name Anda
    compileSdkVersion 34 // Sesuaikan dengan versi SDK Anda
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
        applicationId "com.example.self_management_app" // Pastikan ini sesuai
        minSdkVersion 21 // Minimal SDK
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        multiDexEnabled true
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug
        }
    }
}

flutter {
    source '../..'
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
    implementation 'androidx.multidex:multidex:2.0.1'

    // **BLOK PENTING DARI FIREBASE DITAMBAHKAN DI SINI**

    // 1. Tambahkan Firebase BOM (Bill of Materials)
    implementation platform('com.google.firebase:firebase-bom:33.1.0')

    // 2. Tambahkan dependensi Firebase yang ingin digunakan (tanpa menyebutkan versi)
    implementation 'com.google.firebase:firebase-database'
    // Jika nanti butuh storage untuk gambar, tambahkan di sini:
    // implementation 'com.google.firebase:firebase-storage'
}

// **PLUGIN GOOGLE SERVICES DITAMBAHKAN DI AKHIR FILE**
apply plugin: 'com.google.gms.google-services'