rm -rf ~/flutter/bin/cache
flutter clean
rm -rf ios/Pods
flutter doctor -v
flutter pub get