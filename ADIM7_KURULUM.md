# NutriBuddy — Adım 7: Analytics & Charts

Bu paket **Adım 6 doğrulandıktan sonra** `C:\dev\projects\nutri_buddy` üzerine uygulanır. Daha önceki profil, yemek, tarif, su veya Gemini dosyalarını değiştirmez. Yalnızca dashboard navigasyonu güncellenir ve `lib/features/analytics/` içine özellik dosyaları eklenir.

## Neler geliyor?

- Dashboard sağ üstünde **Analizler ve grafikler** (çizgi grafik) butonu.
- Son 7, 30 ve 90 günlük kalori, su ve makro istatistikleri.
- Kayıt bulunmayan günleri **0 tüketim** kabul etmeyen istatistik motoru.
- Kaydedilmiş öğünlerden günlük kalori hedef aralığı (±%10) sayısı.
- `fl_chart` ile günlük kalori/su sütunları, kilo eğrisi ve makro ilerlemeleri.
- Kilo ölçümü ekleme (10–500 kg), geçmişi görme ve yanlış ölçümü silme.
- Kilo ölçümlerinin Isar'a atomik outbox kaydıyla yerel olarak yazılması; kullanıcının `weight_entries` tablosuna yüklenmesi.
- Unit testler + widget testi.

## A) Yedek al

Flutter terminalinde `q` ile çalışan işlemi durdur.

```powershell
cd C:\dev\projects
Copy-Item .\nutri_buddy .\nutri_buddy_backup_before_step7 -Recurse
```

## B) ZIP'i uygula

```powershell
Expand-Archive `
  -Path "$HOME\Downloads\nutri_buddy_step7_overlay.zip" `
  -DestinationPath "C:\dev\projects\nutri_buddy" `
  -Force
```

**Yeni SQL migration GEREKMİYOR.** Adım 2 migration'ındaki `public.weight_entries`, INSERT/UPDATE yetkileri ve RLS kullanılıyor. Supabase Edge Function, yeni API key veya ekstra ücretli servis eklenmez.

## C) Kod üret, test et

```powershell
cd C:\dev\projects\nutri_buddy
flutter pub get
dart run build_runner build
dart format lib test
flutter analyze
flutter test
```

Kod üretimi `analytics_providers.g.dart` dosyasını üretmeli. `build_runner` hata verirse tam çıktıyı paylaş; generated dosyaları elle yazma. **Önce testler başarılı olmalı.**

## D) Emülatörde çalıştır

```powershell
flutter run -d emulator-5554 --dart-define-from-file=.env.dev.json
```

Dashboard sağ üstündeki grafik ikonuna dokun. Başlangıçta **7 gün** seçili. 30 ve 90 gün sekmelerini dene. Önceki öğün ve su kayıtları grafikte görünmeli (yerel Isar kayıtları cihazda bulunuyorsa). Boş günler grafikte açık renkli/boş kalmalı, sıfır tüketim olarak yorumlanmamalı.

**Kilo geçmişi:** **Ölçüm ekle** düğmesiyle örneğin *70,4* kg gir. Listeye eklendiğini, uygulama kapanıp açıldığında korunduğunu gör. İkinci ölçümle grafik ve dönem içi değişim oluşmalı. Ölçümü silme işlemini de dene.

## E) Bulut doğrulaması

Analizler sayfasında **Kilo kayıtlarını eşitle** simgesine bas. Supabase Dashboard > Table Editor > **weight_entries** tablosunda aynı hesap altında yeni satır görünmeli. `user_id` yalnızca o kullanıcıya ait olmalı. Silinmiş ölçüm için `is_deleted=true` beklenir. Bazen eşitleme kısa süre bekleyebilir; ağ yoksa yerel outbox kaybolmaz. `pending` sayısı sıfıra düşmeli.

### Gerçekçi sınırlamalar

- Grafikler şu an **yalnızca cihazın Isar veritabanında bulunan kayıtları** gösteriyor. Başka telefonda kaydedilmiş verileri Supabase'den topluca indirme henüz eklenmedi; buluta **yükleme** ile cihazlar arasında tam çift yönlü senkronizasyon aynı şey değildir.
- Öğün/su istatistiklerinde boş günler sıfır kabul edilmez. Ortalama yalnızca kayıtlı günlere dayanır; tüm tüketimin eksiksiz kaydedildiği varsayılamaz.
- Kilo noktaları ölçüm günlerine aittir. İlk ağırlık, onboarding profilinden uydurularak grafikleştirilmez. İki ölçüm yoksa değişim hesaplanmaz.
- Günlük hedefler mevcut profilden hesaplanır; geçmişteki farklı hedeflerin tarihçesi tutulmuyor. Su hedefi 2000 ml yalnızca **görsel referans**; kişisel sağlık tavsiyesi değildir.
- Grafiklerin kesin tıbbi anlamı yoktur; AI tahminleri doğrulanmalıdır.
- Kullanıcı hesabından çıkışta önceden tanımlanan mekanizma yerel, henüz eşitlenmemiş verileri silebilir. Çıkış öncesi eşitleme yap.

## Kabul senaryoları

1. `flutter analyze` temiz, `flutter test` başarılı.
2. Dashboard grafik butonu Analytics sayfasını açıyor.
3. 7/30/90 günlük filtreler çalışıyor; eski kayıtlar uygun günlere yerleşiyor.
4. Kaydı olmayan günler `0 tüketim` sayılmıyor.
5. Makro ortalamaları yalnızca kayıtlı günlerden hesaplanıyor.
6. Kilo ölçümü giriliyor, siliniyor ve uygulama yeniden açıldığında doğru kalıyor.
7. İnternet olmadan kilo ölçümü eklenebiliyor; internet gelince `weight_entries` tablosuna yükleniyor.
8. Önceki fotoğraf analiz, AI tarif, su ve oturum açma akışları çalışmaya devam ediyor.

Hata olursa özellikle `flutter analyze`, `flutter test` ve kayıt/senkronizasyon ekran çıktısını paylaş. Önce Adım 7'yi birlikte doğrulayacağız; Adım 8'e otomatik geçmeyeceğiz.
