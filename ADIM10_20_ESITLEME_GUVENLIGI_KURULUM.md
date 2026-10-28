# NutriBuddy — Adım 10.20.8: Güvenli bulut eşitleme

Bu paket üç CloudSyncService dosyasını günceller, ortak Supabase onayı doğrulayıcısı ve otomatik birim testi ekler. Hesap çıkışını, Isar şemasını, Supabase tablolarını, RLS politikalarını veya buluttan geri yükleme servisini değiştirmez.

## 1. Yedek al

VS Code'da uygulamayı durdur. Proje klasöründe `git status` çalıştır. Henüz commit edilmemiş değişiklikler varsa ayrıca yedek al. Uygulamayı emülatörden kaldırma; Android uygulama verilerini temizleme.

PowerShell:

```powershell
cd C:\dev\projects
Copy-Item .\nutri_buddy .\nutri_buddy_backup_before_sync_fix -Recurse
```

## 2. ZIP'i aç

```powershell
Expand-Archive -Path "$HOME\Downloads\nutribuddy_adim10_20_sync_fix.zip" -DestinationPath 'C:\dev\projects\nutri_buddy' -Force
cd C:\dev\projects\nutri_buddy
```

## 3. Kod kontrolü

```powershell
dart format lib/core/sync/sync_acknowledgement.dart lib/features/meals/data/services/meal_cloud_sync_service.dart lib/features/dashboard/data/services/water_cloud_sync_service.dart lib/features/analytics/data/services/weight_cloud_sync_service.dart test/sync/sync_acknowledgement_test.dart
flutter analyze
flutter test
```

**Önce test çıktılarını paylaş; emülatörde hesap değiştirme stres testi yapma.**

## Güvenlik davranışı

- Her ağ çağrısı öncesi/sonrası oturum sahibini kontrol eder; oturum değişirse kuyruk silinmez.
- Bir servis instance'ında başka kullanıcı için aynı anda eşitleme başlatılmaz.
- `.update(...).select('id,revision')` ile beklenen kaydı ve gerçek sunucu revizyonunu doğrular.
- Başarısız/0 satırlık onaylarda pending değişiklikleri korur. Daha önce hiç buluta çıkmamış bir kaydın silinmesi yalnızca sunucuda bulunmadığı da doğrulanırsa tamamlanmış sayılır.
- Eşitleme sırasında yerel kayıt değiştiyse yeni pending işlem korunur.

## Sınırlar

- Uygulamada zaten gönderilmiş bir HTTP isteğini iptal ettiğini iddia etmez; kullanıcı değişimi tespit edilirse yerel outbox korunur. Supabase RLS ve `user_id` filtresi uzaktaki sahipliği ayrıca korur.
- Çoklu cihazdaki karşılıklı çakışan güncellemeler için ayrı bir iyimser kilit/çatışma çözümü gerekir.
- Gerçek Supabase ve Flutter SDK testlerini burada koşturamadım; kullanıcının yerel `flutter analyze` ve `flutter test` sonuçları gereklidir.
- `clear()` fonksiyonu paket kapsamında değiştirilmez, normal çıkış tarafından çağrılmadığı önceki incelemede doğrulandı.
