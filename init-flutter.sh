#!/bin/sh
flutter create advdiv --org cz.ratajs
rm -r ./advdiv/lib ./advdiv/android/app/src/main/AndroidManifest.xml ./advdiv/android/app/src/main/res/drawable/launch_background.xml ./advdiv/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png ./advdiv/android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png ./advdiv/android/app/src/main/res/mipmap-xhdpi/ic_launcher.png ./advdiv/android/app/src/main/res/mipmap-hdpi/ic_launcher.png ./advdiv/android/app/src/main/res/mipmap-mdpi/ic_launcher.png ./advdiv/windows/runner/resources/app_icon.ico ./advdiv/pubspec.yaml ./advdiv/README.md
ln -s ../lib ./advdiv/lib
ln -s ../../../../../AndroidManifest.xml ./advdiv/android/app/src/main/AndroidManifest.xml
ln -s ../../../../../../../launch_background.xml ./advdiv/android/app/src/main/res/drawable/launch_background.xml
ln -s ../../../../../../../icons/192.png ./advdiv/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png
ln -s ../../../../../../../icons/144.png ./advdiv/android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
ln -s ../../../../../../../icons/96.png ./advdiv/android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
ln -s ../../../../../../../icons/72.png ./advdiv/android/app/src/main/res/mipmap-hdpi/ic_launcher.png
ln -s ../../../../../../../icons/48.png ./advdiv/android/app/src/main/res/mipmap-mdpi/ic_launcher.png
ln -s ../../../../icons/app_icon.ico ./advdiv/windows/runner/resources/app_icon.ico
ln -s ../google_fonts ./advdiv/google_fonts
ln -s ../pubspec.yaml ./advdiv/pubspec.yaml
ln -s ../README.md ./advdiv/README.md
sed -i s/dk7:/dk8:/g ./advdiv/android/app/build.gradle
cd advdiv
flutter pub get
