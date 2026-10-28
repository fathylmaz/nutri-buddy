NutriBuddy / Adım 4 — widget-test onarımı

Değişen tek Dart dosyası: test/dashboard/dashboard_page_test.dart
- Import sıralaması düzeltildi.
- Su kartındaki 0 ml başlangıç değeri test edilmeden önce kart görünür alana kaydırılıyor.
- +250 ml / son kaydı geri al / repository kontrolü korunuyor.

Kurulum (PowerShell):
cd C:\dev\projects\nutri_buddy
Expand-Archive -Path "$HOME\Downloads\nutri_buddy_step4_test_fix.zip" -DestinationPath "C:\dev\projects\nutri_buddy" -Force
dart format test/dashboard/dashboard_page_test.dart
flutter analyze
flutter test test/dashboard/dashboard_page_test.dart
flutter test

Bu ortamda Flutter SDK bulunmadığından testler kullanıcı bilgisayarında çalıştırılmalıdır.
