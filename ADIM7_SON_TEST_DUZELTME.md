# NutriBuddy Adım 7 — Son Widget Testi Düzeltmesi

Bu güncelleme **yalnızca** `test/meal_builder/meal_builder_page_test.dart` dosyasını değiştirir. Flutter uygulama kodunu ve veritabanını değiştirmez.

Sorun: Widget testi `builder-consent` anahtarlı öğenin konumunu (`getRect`) okumaya çalışıyordu. Flutter ListView öğeleri ekran dışında kaldığında onları henüz oluşturmamış olabilir. Bu durumda finder 0 öğe bulur. Önceki yardımcı fonksiyon da öğe henüz oluşturulmadan konumunu okumaya çalışıyordu.

Düzeltme: `tester.scrollUntilVisible(...)` ile sayfanın **dış ListView** kaydırma alanı açıkça seçildi. Hedef widget oluşturulup görünür olunca etkileşim gerçekleşir. Aynı yöntem tarif oluşturma ve kaydetme butonlarında kullanılır.

## Kurulum — PowerShell

```powershell
cd C:\dev\projects\nutri_buddy
Expand-Archive -Path "$HOME\Downloads\nutri_buddy_step7_last_test_fix.zip" -DestinationPath "C:\dev\projects\nutri_buddy" -Force

dart format test/meal_builder/meal_builder_page_test.dart
flutter test test/meal_builder/meal_builder_page_test.dart
flutter analyze
flutter test
```

Beklenen sonuçlar: `No issues found!` ve `All tests passed!`.

Flutter SDK bu ortamda kurulu olmadığı için gerçek testler burada çalıştırılamadı; Windows ortamında sonuçları doğrulayın.
