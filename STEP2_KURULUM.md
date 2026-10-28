# NutriBuddy — Adım 2 / Database & Models

## Ne var?

- PostgreSQL 7 tablo: users, logs, pets, items, user_items, weight_entries, water_entries
- Her tabloya RLS; yalnızca sahip verileri görülebilir. Ürünler yalnızca aktif olanlar için okunabilir.
- `auth.users` oluşturulduğunda users + pets satırlarını otomatik açan trigger
- Isar 8 koleksiyon (`pending_mutations` yalnızca yerelde)
- Freezed ile 7 immutable domain entity
- Domain'de 7 repository interface
- `IsarMealLogRepository`: yerel kayıt/okuma/soft-delete ve aynı transaction içinde pending mutation
- Riverpod üzerinden açılmış Isar bağlantısı; başlangıç ekranında Adım 2 sağlık kontrolü
- Isar ↔ Domain mapper testi; başlangıç widget testi

## Windows kurulum

Adım 1'in çalışan klasörü: `C:\dev\projects\nutri_buddy`

1. Flutter çalışıyorsa terminalde `q` ile durdur.
2. Mevcut klasörü yedekle:

```powershell
Copy-Item 'C:\dev\projects\nutri_buddy' 'C:\dev\projects\nutri_buddy_backup_step1' -Recurse
```

3. ZIP dosyasını mevcut Flutter proje klasörüne `Expand-Archive -Force` ile aç.
4. **Eski generated dosyaları silmene gerek yok**; kod üretimi dosyaları günceller.

```powershell
cd C:\dev\projects\nutri_buddy
flutter pub get
dart run build_runner build
dart format lib test
flutter analyze
flutter test
flutter run -d emulator-5554
```

Ekran: **Veri mimarisi hazır**, **Aşama 2 / 9**, **Isar: açık (8 koleksiyon)**.

## Supabase kurulumu (SQL Editor)

1. https://supabase.com/dashboard → New project. Bölge tercihini kullanıcı kitlesi ve veri yerleşimi gereksinimlerine göre belirle.
2. SQL Editor'da `supabase/migrations/202610220001_stage2_core.sql` dosyasının tamamını yeni projende bir kez çalıştır.
3. `supabase/tests/schema_checks.sql` sorgularını çalıştır: 7 tablo `rls_enabled=true`; `anon_can_select=false`.
4. Project Settings → API/Connect bölümünden **project URL** ve **publishable key** bilgilerini al.
5. `.env.example.json` dosyasını `.env.dev.json` olarak kopyala ve bu iki bilgiyi yaz.
6. `flutter run -d emulator-5554 --dart-define-from-file=.env.dev.json` ile test et.

**Publishable key** istemci içinde kullanılabilir ama prod projelerde RLS kritik.
**Asla `service_role`, database password, OpenAI API key veya şifrelerini Flutter'a koyma.**

Bu aşamada Supabase kullanıcı kaydı / onboarding yok. RLS kullanıcı testleri ve gerçek bulut CRUD Stage 3 ile devam eder; SQL'in uygulanması bulut senkronizasyonun çalıştığı anlamına gelmez.

## Güvenlik ve offline-first sınırları

- Isar cihazda şifresiz dosyalar tutar; örnek verilerle doğrula. Gerçek kullanıcı sağlık verileri toplamadan önce veri koruma/şifreleme ve kullanım izinleri gerekir.
- `pending_mutations` sadece anahtar/tür bilgileri tutar, health payload'ları ikinci kez kopyalamaz.
- Gönderim kuyruğu şu an **replay yapmaz**. Bağlantı, senkronizasyon, retry/backoff ve çatışma çözümü ayrıca uygulanacak.
- `pets` / `user_items` istemciden yazılamaz. Ödül ve alışverişi sunucu tarafından doğrulanmış işlemlerle yapacağız.
- Giriş/çıkış ve hesap değiştirme durumunda yerel veriyi yalıtma/temizleme Stage 3'te zorunlu.
- Kronik hastalık ve alerji bilgileri hassastır; açık onam ve KVKK uyumluluğunu ilerleyen adımlarda ele alacağız.
- pgvector ve embedding veri modeli Stage 9'da ayrıca tasarlanacak.

## Kabul kriterleri

- [ ] build_runner 8 Isar ve 7 Freezed dosyasını üretir; hata yok.
- [ ] flutter analyze temiz.
- [ ] flutter test tamamen yeşil.
- [ ] Android'de Isar açılır ve Adım 2 ekranı görünür.
- [ ] Supabase migration SQL Editor'da başarılı.
- [ ] RLS temel kontrol sorguları beklenen sonucu verir.

Tüm adımlar doğrulanıp kullanıcı onay vermeden Stage 3'e geçilmez.
