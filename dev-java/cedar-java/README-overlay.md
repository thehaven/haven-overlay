# cedar-java — packaging status

**Status**: NOT YET PACKAGED.

`cedar-policy/cedar-java` is a Gradle project with the following build
dependencies that are hard to satisfy in a strict-source-based overlay:

1. **Gradle plugins**: `com.github.spotbugs.snom:spotbugs-gradle-plugin`,
   `gradle.plugin.com.github.sherter.google-java-format:google-java-format-gradle-plugin`,
   `de.undercouch.download`. These are fetched from `plugins.gradle.org/m2/`
   during Gradle's configuration phase.
2. **CedarJavaFFI subproject**: Rust crate built via `cargo build`, requiring
   `cedar-policy-symcc` and the full Rust dependency graph (already vendored
   for the main cedar CLI package).
3. **SpotBugs / JaCoCo / Checkstyle**: heavy static-analysis toolchain.

To package offline, we'd need to:
- Pre-populate `~/.gradle/caches/` with all transitive Gradle plugin and
  runtime dependencies (`./gradlew dependencies > deps.txt` first, then mirror).
- Vendor the Maven repository locally.
- Either disable SpotBugs/JaCoCo/Checkstyle plugins or vendor their plugin jars.

Open question: is the JAR (`CedarJava`) usable standalone, or does it
require `libcedar_java_ffi.so` at runtime? If standalone, a simpler
package that builds only the Java code (skipping CedarJavaFFI) might work.

Decision deferred to the maintainer.
