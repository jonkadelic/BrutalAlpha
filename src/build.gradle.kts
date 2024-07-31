plugins {
    id("java")
    id("maven-publish")
}

group = "net.minecraft"
version = "0.1"

tasks.withType(JavaCompile::class.java) {
    options.isIncremental = false
    options.encoding = "UTF-8"
    if (JavaVersion.current() != JavaVersion.VERSION_1_8) {
        options.compilerArgs.add("--release")
        options.compilerArgs.add("8")
    }
}

repositories {
    mavenCentral()
    maven("https://libraries.minecraft.net/")
    maven("https://jitpack.io")
    ivy {
        url = uri("https://piston-data.mojang.com")
        patternLayout {
            artifact("v1/[organisation]/[revision]/[module].jar")
            m2Compatible
        }
        metadataSources { artifact() }
    }
}

dependencies {
    val lwjglVersion = "2.9.3"
    implementation("org.lwjgl.lwjgl:lwjgl_util:${lwjglVersion}")
    implementation("org.lwjgl.lwjgl:lwjgl:${lwjglVersion}")
    runtimeOnly("org.lwjgl.lwjgl:lwjgl-platform:${lwjglVersion}")

    runtimeOnly("net.java.jinput:jinput-platform:2.0.5")
    implementation("net.java.jinput:jinput:2.0.5")
    implementation("net.java.jutils:jutils:1.0.0")

    implementation("objects:client:daa4b9f192d2c260837d3b98c39432324da28e86") // Minecraft client jar
}

task("copyNatives", Copy::class) {
    configurations.runtimeClasspath.get()
        .filter { it.extension == "jar" && it.name.contains("platform") }
        .forEach { from(zipTree(it).filter { file -> !file.name.contains("META-INF") && !file.name.contains(".MF") }).into("$buildDir/natives") }
}

task("runClient", JavaExec::class) {
    dependsOn(tasks["copyNatives"])
    group = "brutal"
    mainClass.set("net.minecraft.client.Minecraft")
    classpath = sourceSets["main"].runtimeClasspath

    systemProperty("java.library.path", layout.buildDirectory.dir("natives").get().asFile.absolutePath)
}

java {
    sourceCompatibility = JavaVersion.VERSION_1_8
    targetCompatibility = JavaVersion.VERSION_1_8
}

