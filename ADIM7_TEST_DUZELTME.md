# NutriBuddy Adım 7 - Test onarım paketi

Bu paket **yalnızca test/ altındaki üç dosyayı** değiştirir. Uygulama mantığına,
Gemini/Supabase ayarlarına, Isar kayıtlarına veya kullanıcı verilerine dokunmaz.

## Neden gerekli?

- TimeoutException() Dart SDK'da zorunlu `message` argümanını almıyordu.
- Analytics widget testi ekrandan aşağıdaki kilo butonuna görünür olmadan basıyordu.
- Meal Builder widget testi birden fazla Scrollable olduğunda yanlış/çoklu seçim yapıyordu.

## Kurulum (PowerShell)

flutter run açıksa q ile durdur.

```powershell
cd C:\dev\projects\nutri_buddy
Expand-Archive -Path "$HOME\Downloads\nutri_buddy_step7_test_fix.zip" -DestinationPath "C:\dev\projects\nutri_buddy" -Force

dart format test/analytics/analytics_page_test.dart test/meal_builder/meal_builder_page_test.dart test/meals/vision_error_message_test.dart

dart fix --apply --code=curly_braces_in_flow_control_structures
dart fix --apply --code=unnecessary_underscores

flutter analyze
flutter test
```

Testler yeşil olmadan Adım 8'e geçmeyin. Kotlin/Rive veya paket sürümü güncellemesi bu düzeltme için gerekmez.
