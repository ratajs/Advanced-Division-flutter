#!/bin/sh
flutter create advdiv --org cz.ratajs
rm -r ./advdiv/lib ./advdiv/android/app/src/main/AndroidManifest.xml ./advdiv/pubspec.yaml ./advdiv/README.md
ln -s ../lib ./advdiv/lib
ln -s ../../../../../AndroidManifest.xml ./advdiv/android/app/src/main/AndroidManifest.xml
ln -s ../pubspec.yaml ./advdiv/pubspec.yaml
ln -s ../README.md ./advdiv/README.md
cd advdiv
flutter pub get
