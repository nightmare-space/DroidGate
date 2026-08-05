./gradlew :droidgate-core:assembleRelease
mvn install:install-file \
  -Dfile=droidgate-core/build/outputs/aar/droidgate-core-release.aar \
  -DgroupId=com.github.nightmare-space.DroidGate \
  -DartifactId=droidgate-core \
  -Dversion=1.0.0 \
  -Dpackaging=aar
./gradlew :droidgate-plugins:assembleRelease
mvn install:install-file \
  -Dfile=droidgate-plugins/build/outputs/aar/droidgate-plugins-release.aar \
  -DgroupId=com.github.nightmare-space.DroidGate \
  -DartifactId=droidgate-plugins \
  -Dversion=1.0.0 \
  -Dpackaging=aar
./gradlew :droidgate-hidden-api:assembleRelease
mvn install:install-file \
  -Dfile=droidgate-hidden-api/build/outputs/aar/droidgate-hidden-api-release.aar \
  -DgroupId=com.github.nightmare-space.DroidGate \
  -DartifactId=droidgate-hidden-api \
  -Dversion=1.0.0 \
  -Dpackaging=aar
./gradlew :droidgate-bundle:assembleRelease
mvn install:install-file \
  -Dfile=droidgate-bundle/build/outputs/aar/droidgate-bundle-release.aar \
  -DgroupId=com.github.nightmare-space.DroidGate \
  -DartifactId=droidgate-bundle \
  -Dversion=1.0.0 \
  -Dpackaging=aar
