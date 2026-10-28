# NutriBuddy — Adım 4 / Dashboard & Water Tracker

Bu paket Adım 3'ü başarıyla tamamlamış `C:\dev\projects\nutri_buddy` projesinin üzerine **dosya güncellemesi** olarak uygulanır. Android/iOS platform dosyaları, `pubspec.yaml`, `.env.dev.json`, mevcut Supabase migration'ları ve var olan kullanıcı verileri değiştirilmez.

## Kurulum

1. Çalışan Flutter oturumunda `q` ile uygulamayı durdur.
2. `C:\dev\projects\nutri_buddy` klasörünü başka bir konuma yedekle.
3. ZIP dosyasını `C:\dev\projects\nutri_buddy` içine aç (`-Force`).
4. VS Code terminalinde:

```powershell
cd C:\dev\projects\nutri_buddy
flutter pub get
dart run build_runner build
dart format lib test
flutter analyze
flutter test
flutter run -d emulator-5554 --dart-define-from-file=.env.dev.json
```

Bu aşamada yeni Isar koleksiyonu veya Supabase migration'ı eklenmez: Stage 2 `WaterRecordSchema` ve `water_entries` tablosu kullanılır. Yeni Riverpod kodları `lib/features/dashboard/presentation/providers/dashboard_providers.g.dart` olarak üretilmelidir.

## Kabul testleri

1. Kayıtlı hesabınla giriş yap. Onboarding tamamlandıysa **Dashboard** açılmalı. Profil/çıkış ekranı sağ üstteki kullanıcı ikonu ile açılır.
2. Öğün girişi yapılmadıysa `0 kcal` ve `Bugün henüz öğün kaydı yok` görünür. Sahte kalori gösterilmez.
3. `+ 250 ml`'ye bir kere bas. Su sayacı 250 ml olur. Tekrar bas: 500 ml.
4. `Son kaydı geri al` ile 250 ml düş. Son kayıt yoksa buton devre dışıdır.
5. Uygulamayı kapat ve **aynı hesaba** yeniden giriş yap. Su toplamı korunmalıdır.
6. İnterneti kesip yeni +250 ml kaydı ekle. Kayıt yerelde tutulmalı ve bekleyen eşitleme sayısı artmalı.
7. İnterneti aç; su kartındaki **eşitle** simgesine bas. Bekleyen sayı sıfırlanmalı. Supabase Table Editor → `water_entries` tablosunda `user_id`, `amount_ml`, `recorded_at` ve `is_deleted` sütunlarını kontrol et. Başarılı geri alma için satır `is_deleted=true` olur.
8. Profil/çıkış menüsünün çalıştığını ve `flutter analyze` / `flutter test` sonuçlarını doğrula.

## Önemli sınırlamalar

- Yeni su kayıtları öncelikle Isar'a ve aynı atomik transaction'da `pending_mutations` kuyruğuna yazılır. İnternet bağlantısında en iyi çabayla eşitlenir; uygulama çalışmıyorken periyodik arka plan senkronizasyonu **henüz yoktur**.
- Bulut `water_entries` verileri kullanıcı erişim politikalarıyla korunur. Isar dosyası henüz uygulama düzeyinde şifrelenmiş değildir; gerçek hassas sağlık verileriyle dağıtıma hazır sayılmamalıdır.
- 2000 ml ekrandaki genel bir görsel referanstır, kişiye özel sıvı önerisi değildir. Kalori ve makrolar Adım 3'teki genel yetişkin tahminlerini kullanır.
- Öğün ekranı/AI fotoğraf tanıma **Adım 5**, kilo grafikleri **Adım 7**, Rive karakteri **Adım 8** kapsamındadır. Bu adımda ürünleşmiş gibi gösterilmez.
- Bu ZIP kaynak dosyaları içerir; otomatik üretilen `.g.dart` dosyaları bilerek eklenmez. SDK üzerinde üretilecek.
- Bulut eşitlemesi için `--dart-define-from-file=.env.dev.json` ve mevcut test kullanıcısı oturumu gereklidir.
- `water_entries` RLS politikasını kaldırma, `service_role` anahtarını Flutter'a ekleme.
