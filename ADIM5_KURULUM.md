# NutriBuddy — Adım 5: Vision AI & Meal Logger

Mevcut Adım 4 projesinin **üzerine** uygulanacak yama. Android/iOS platform dosyaları korunur.

## 0. Güvenli başlangıç

Proje klasöründe çalışan Flutter komutunu `q` ile durdur. Yedek al:

```powershell
cd C:\dev\projects
Copy-Item .\nutri_buddy .\nutri_buddy_backup_before_step5 -Recurse
```

ZIP dosyasını `Downloads` klasörüne indir, sonra:

```powershell
Expand-Archive `
  -Path "$HOME\Downloads\nutri_buddy_step5_overlay.zip" `
  -DestinationPath "C:\dev\projects\nutri_buddy" `
  -Force
```

## 1. Supabase SQL migration — bunu önce yap

Supabase Dashboard → NutriBuddy projesi → SQL Editor → New Query.

Projedeki `supabase/migrations/202610230001_stage5_vision_details.sql`
dosyasının tamamını VS Code'da kopyalayıp SQL Editor'e yapıştır. **Run**.

Bu migration:
- Var olan `public.logs` tablosuna `vision_details jsonb` ekler.
- Var olan `logs` RLS politikalarını KORUR.
- Sunucu tarafı `private.vision_usage_daily` kotası ve
  `public.reserve_vision_request()` RPC fonksiyonunu oluşturur.
- Bir kullanıcı için günde en fazla 10 Vision çağrısı rezervasyonu tanımlar.
- Mevcut yemek ve su kayıtlarını silmez.

**Adım 2 migration'ını tekrar ÇALIŞTIRMA.**

Kontrol:

```sql
select column_name, data_type
from information_schema.columns
where table_schema='public' and table_name='logs' and column_name='vision_details';

select to_regprocedure('public.reserve_vision_request()') as rate_limit_function;
```

Beklenen: `vision_details | jsonb` ve RPC adı görünüyor.

## 2. OpenAI API anahtarı — mobil uygulamaya yazılmayacak

OpenAI API platformunda API anahtarı oluştur. ChatGPT üyeliğinden ayrı API
faturalandırması gerekebilir. Anahtarı kimseyle paylaşma.

Supabase Dashboard → Edge Functions → Secrets (veya Edge Function Secrets).

Key: `OPENAI_API_KEY`
Value: OpenAI API'den oluşturduğun gizli anahtar.

`.env.dev.json`, `pubspec.yaml`, `lib/`, Git veya sohbet içine **EKLEME**.

## 3. Supabase Edge Function deploy

Supabase Dashboard → Edge Functions → Deploy a new function → Via Editor.
İsim: `analyze-meal`

Proje içindeki `supabase/functions/analyze-meal/index.ts` dosyasının
**tamamını** editöre kopyala ve Deploy function seç.

Fonksiyon yalnızca `auth: 'user'` JWT ile çağrılır. JWT doğrulama ayarı **açık**
(`verify_jwt = true`) kalmalı. `verify_jwt=false` yaparak 401'i gizleme.

Yalnızca istek üzerine fotoğraf Supabase Edge Function üzerinden OpenAI API'ye
gönderilir; orijinal fotoğrafı Supabase Storage'a kaydetmiyoruz.

> Bu işlev GPT-4o-2024-08-06 Structured Outputs + Vision kullanır.
> Görsel analizini çalıştırmak API maliyeti oluşturabilir.

## 4. Flutter kodunu üret ve test et

```powershell
cd C:\dev\projects\nutri_buddy
flutter pub get
dart run build_runner build
dart format lib test
flutter analyze
flutter test
flutter run -d emulator-5554 --dart-define-from-file=.env.dev.json
```

`build_runner`, `meal_log.freezed.dart`, `meal_log_record.g.dart` ve
`meal_sync_providers.g.dart` dahil ilgili dosyaları günceller.

## 5. Uygulama senaryoları

1. Dashboard → **Öğün ekle** → fotoğraf seçmeden "Ev yemeği", 350 kcal,
   20 g protein gibi kurgusal değerler gir → **Öğünü kaydet**. Günlük kcal ve
   makro özetinin değiştiğini doğrula.
2. Uygulamayı kapat/aç; öğün Isar'da ve günlük toplamda durmalı.
3. İnterneti kapat, ikinci MANUEL öğün ekle. İnternetsiz kaydolmalı.
4. İnterneti aç → Dashboard → **Öğünleri eşitle** → Supabase Table Editor →
   `logs` satırlarının kendi test kullanıcına ait olduğunu doğrula.
5. **Galeriden seç** ile yemek fotoğrafı yükle (emülatörde kamera yerine
   galeriyle başlamak daha kolay olabilir) → açık onay kutusunu işaretle →
   **Fotoğrafı analiz et**. Besinleri, toplamları ve bilinmeyen vitaminlerin
   `bilinmiyor` olarak gösterildiğini kontrol et.
6. Porsiyon çarpanını değiştir; kalori ve makro rakamları değişmeli. İstersen
   elle düzelt → **Öğünü kaydet**.
7. Supabase `logs.vision_details` JSON sütununu kontrol et; fotoğrafın kendisi
   burada bulunmamalı. `source = 'vision'` olmalı.
8. Dashboard'da bir öğünü sil → günlük toplam azalsın; eşitlemeden sonra
   Supabase `logs.is_deleted = true` olsun (fiziksel silme değil).

## 6. Kapsam ve sınırlar

- OpenAI vision servisi OFFLINE çalışmaz. Manuel kayıt tamamen offline-first.
- Öğün Isar transaction'ı içinde `pending_mutations` kuyruğuna kaydedilir.
- Senkronizasyon uygulama açıkken ve kullanıcı talebiyle denenir. Sistemde
  arka planda garantili bir işlemci YOK.
- Vitamin değerleri fotoğraftan güvenilir ölçülemez. Belirsiz değerler `null`
  (bilinmiyor) kalır; mevcut AI sayıları da sadece TAHMİNDİR.
- Yalnızca tıklanıp onaylanan fotoğraf transfer edilir. Fotoğraflar cihazda
  uygulama veritabanına ve Supabase'e saklanmaz; üçüncü taraf işleme ve saklama
  politikaları için OpenAI API belgelerini ayrıca incele.
- Isar diskte şifreli değildir. Gerçek hassas sağlık verileriyle üretimde
  kullanmadan önce veri şifreleme, veri silme ve gizlilik uyumluluğu gerekir.
- API anahtarını Flutter istemcisine KESİNLİKLE gömme.
- Test ve analizin sonuçlarını aldıktan sonra Adım 5'i onaylayıp bir sonraki
  aşamaya geçeceğiz. Şimdilik Adım 6'ya geçilmiyor.
