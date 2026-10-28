# NutriBuddy — Adım 6: AI Dynamic Meal Builder

## Gereksinimler

- Adım 1–5 proje dosyaları kurulu ve Adım 5 testleri başarılı.
- Gemini fotoğraf analizi çalışıyor; aynı `GEMINI_API_KEY` kullanılacak.
- Windows 11 / PowerShell / VS Code, Flutter 3.47+, Dart 3.13+.

## 1 — Yedek al ve overlay ZIP'i çıkar

Flutter terminalinde `q` ile çalışan uygulamayı durdur.

```powershell
cd C:\dev\projects
Copy-Item .\nutri_buddy .\nutri_buddy_backup_before_step6 -Recurse
Expand-Archive -Path "$HOME\Downloads\nutri_buddy_step6_overlay.zip" -DestinationPath 'C:\dev\projects\nutri_buddy' -Force
```

ZIP'i `Downloads` klasörüne indirmediysen `-Path` değerini kendi dosya yolunla değiştir. ZIP'i `lib` dizinine değil **projenin köküne** aç.

## 2 — Supabase SQL migration

Supabase → SQL Editor → New Query.

`supabase/migrations/202610230002_stage6_meal_builder.sql` dosyasının tamamını kopyala ve **Run** yap.

Bu, `public.logs.recipe_details jsonb` sütununu ekler ve `public.reserve_recipe_request()` fonksiyonunu oluşturur. Eski öğünleri, su geçmişini ve kullanıcıları silmez. Günlük 15 denemelik UTC kota `private.recipe_usage_daily` tablosundadır. Adım 2 ve Adım 5 SQL migration'larını tekrar çalıştırma.

Kontrol SQL:

```sql
select column_name, data_type
from information_schema.columns
where table_schema = 'public'
  and table_name = 'logs'
  and column_name = 'recipe_details';

select to_regprocedure('public.reserve_recipe_request()');
```

İlk sorguda `recipe_details / jsonb`, ikincide fonksiyon adı görünmeli.

## 3 — Supabase Edge Function deploy

Mevcut `analyze-meal` fonksiyonuna DOKUNMA.

Supabase → Edge Functions → **Deploy a new function → Via Editor**

Fonksiyonun adı **`build-meals`** (tire ile ve küçük harf).

VS Code'da `supabase/functions/build-meals/index.ts` dosyasını aç; tamamını Supabase editöründeki `index.ts` içeriğiyle değiştir. **Deploy**.

JWT doğrulaması açık (`Verify JWT = ON`) kalsın. Aynı Supabase projesindeki `GEMINI_API_KEY` secret'ı kullanılacak, yeni API anahtarı ya da Flutter `.env.dev.json` değişikliği gerekmiyor.

Model, Adım 5'te çalışan `gemini-3.5-flash-lite`.

## 4 — Flutter kod üretimi, analiz, testler

```powershell
cd C:\dev\projects\nutri_buddy
flutter pub get
dart run build_runner build
dart format lib test
flutter analyze
flutter test
flutter run -d emulator-5554 --dart-define-from-file=.env.dev.json
```

`MealLog` Freezed modeline ve `MealLogRecord` Isar şemasına yeni opsiyonel tarif alanı eklendiği için **build_runner adımı zorunlu**. Üretilen `.g.dart` ve `.freezed.dart` dosyalarını elle değiştirme. Kod üretimi beklenmedik biçimde atlıyorsa:

```powershell
dart run build_runner clean
dart run build_runner build
flutter analyze
flutter test
```

`flutter clean` veya uygulamayı silme; yerel veriler korunmalı.

## 5 — Uygulama kabul testleri

1. Dashboard → **AI ile tarif oluştur**.
2. Günlük kalan kaloriyi ve makroları doğrula. Kalan değerler bugün kaydedilen öğünlerden düşülür.
3. Malzeme gir (ör. `pirinç, domates, kabak`), öğün türünü seç.
4. Profilden gelen alerji alanını kontrol et; gerekirse düzenle. Alerjen güvenliği garanti edilmez.
5. Gemini ücretsiz katmanında bu girdilerin işlenmesini kabul ediyorsan **açık izin** kutusunu işaretle.
6. **3 tarif öner** → 3 öneri görünmeli; tahmini besin değerleri, malzemeler ve adımları incele.
7. Birine **Alternatif üret** bas; yalnızca seçilen öneri değişmeli.
8. **Öğün günlüğüne ekle** → makroları düzenle → **Onayla ve kaydet**.
9. Dashboard kalori/makroları güncellenmeli, öğün `ai_recipe` kaynağıyla görünmeli.
10. Supabase → `logs` tablosunda `source = ai_recipe` ve `recipe_details` JSON görünüyor mu doğrula (gerekirse öğünleri eşitle).
11. Uygulamayı kapatıp aç, kaydedilmiş öğün üzerindeki kitap simgesinden tarif malzemeleri ve adımlarını aç.
12. İnternetsiz manuel öğün hâlâ çalışmalı; AI tarif üretme internet gerektirir. Çevrimdışıyken kayıtlı tarifin ayrıntıları yerelde görülebilmeli.
13. Mevcut fotoğraf analizi (`analyze-meal`) ve su kaydı da çalışmaya devam etmeli.

## Güvenlik ve mahremiyet

- Yalnızca açık izinden sonra malzeme, dışlanan içerikler ve sayısal beslenme bütçesi Gemini'ye gönderilir; ad, e-posta, doğum tarihi, kilo, tanı veya öğün geçmişi gönderilmez.
- Ücretsiz Gemini API katmanına gönderilen girdiler sağlayıcının ücretsiz hizmet veri kullanım koşullarına tabi olabilir. Hassas/gerçek sağlık verileriyle prototipi test etme.
- Tarif besin değerleri **yaklaşıktır**, tıbbi beslenme önerisi değildir. Alerjen adı kontrolü türevleri veya çapraz bulaşmayı saptama garantisi sunmaz. Özellikle ciddi alerjide AI önerisine güvenme.
- Gemini API anahtarını uygulama kaynak koduna veya GitHub'a ekleme.
- `build-meals` fonksiyonu kullanıcı JWT'si ister, günlük 15 çağrı kotası uygular; kotalar Gemini Free Tier sınırlarını aşabilir.

## Hata ayıklama

- `401`: Supabase oturumu geçersiz/yenilenemedi.
- `404`: `build-meals` doğru adla deploy edilmedi.
- `429`: günlük uygulama kotası veya Gemini kotası.
- `502 / ai_request_failed`: Supabase → Edge Functions → build-meals → Logs; oradaki `upstreamHttpStatus` ve `upstreamErrorStatus` alanlarına bak. Mevcut çalışan fotoğraf analizindeki model adını bozma.
- `503 / quota_unavailable`: SQL migration veya RPC yetkilerini doğrula.
- `invalid_ai_result`: Gemini JSON şeması/model çıktısı incelenmeli.

## Mimarinin kapsamı

- Yeni `meal_builder` özelliği Clean Architecture katmanlarıyla ayrıldı.
- Var olan `MealLogRepository.saveLocally` Isar + outbox akışı yeniden kullanıldı.
- Tarif JSON'u hem Isar `recipeDetailsJson` alanında hem Supabase `logs.recipe_details` sütununda saklanıyor.
- 1 yeni Edge Function, 1 SQL migration ve 4 test dosyası mevcut.
- Flutter veya gerçek API çağrısı bu teslim ortamında çalıştırılmadı; kullanıcı test sonuçlarıyla doğrulanacak.

Adım 6 kullanıcı tarafından kabul edilmeden Adım 7'ye geçilmez.
