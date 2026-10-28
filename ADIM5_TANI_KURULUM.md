# NutriBuddy — Adım 5 / Fotoğraf Analizi Hata Tanılama Düzeltmesi

Bu paket önceki Adım 5 sürümünün üzerine uygulanan küçük, **tanılama amaçlı** güncellemedir. AI modelini, yerel öğün kayıtlarını, SQL migration'ı ve Supabase Edge Function'ını değiştirmez.

## Neler değişti?

- Fotoğraf analizi sırasında gelen bilinen Supabase HTTP hata kodlarını kullanıcıya açıklayan güvenli metinler eklendi.
- Hata yanıtındaki serbest metin veya gizli bilgiler ekrana yazılmaz; yalnızca bilinen hata kodları gösterilir.
- Fotoğraf izni metnindeki eski OpenAI adı Gemini olarak güncellendi.
- 4 birim test eklendi.

## Kurulum

Flutter terminalinde `q` ile çıkış yap. PowerShell:

```powershell
cd C:\dev\projects\nutri_buddy
Expand-Archive -Path "$HOME\Downloads\nutri_buddy_step5_vision_error_patch.zip" -DestinationPath "C:\dev\projects\nutri_buddy" -Force
dart format lib/features/meals/presentation/pages/meal_logger_page.dart lib/features/meals/presentation/utils/vision_error_message.dart test/meals/vision_error_message_test.dart
flutter analyze
flutter test
flutter run -d emulator-5554 --dart-define-from-file=.env.dev.json
```

Analizi bir kez dene. Hata mesajındaki **HTTP numarası ve kısa kodu** paylaş (anahtar, fotoğraf ve JWT paylaşma).

## Sunucu durumları

Supabase Dashboard > Edge Functions > analyze-meal > Invocations bölümündeki HTTP durumunu aynı denemeyle karşılaştır. Eğer Invocations içinde yeni çağrı görünmüyorsa yanlış Supabase projesi/Function adı, ağ veya JWT geçidi ihtimalleri incelenmelidir. Logs içindeki herhangi bir hatada kişisel bilgileri gizle.

## Notlar

Burada Flutter SDK bulunmadığı için kodun Android üzerinde derlenmesi ve testlerin geçmesi senin yerel ortamında doğrulanmalıdır. Düzeltme mevcut Supabase veya Isar verilerini temizlemez. Başka bir modele geçiş yapmaz.
