#!/bin/sh
flutter create advdiv
rm -r ./advdiv/lib ./advdiv/pubspec.yaml ./advdiv/README.md
ln -s ../lib ./advdiv/lib
ln -s ../pubspec.yaml ./advdiv/pubspec.yaml
ln -s ../README.md ./advdiv/README.md
cd advdiv
flutter pub get
