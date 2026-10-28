# NutriBuddy — Adım 5 / Gemini 2.5 Flash ücretsiz geliştirici API geçişi

**Bu bir Adım 5 düzeltmesidir. Adım 6'ya geçilmemiştir.**

## Neyi değiştirdik?

- Yalnızca `supabase/functions/analyze-meal/index.ts` dosyası değişiyor.
- Mobil Flutter kodu, Isar, Supabase `logs` şeması ve `analyze-meal` fonksiyon adı **aynı** kalıyor.
- OpenAI API yerine Gemini `gemini-2.5-flash` kullanılacak.
- Yanıt hala `{ "analysis": { ... } }` biçiminde. Çıktıda besin değerleri tahminidir.
- Kullanıcı kimliği doğrulaması, günlük 10 analiz çağrısı için `reserve_vision_request` RPC kotası ve görüntü türü kontrolü korunuyor.

## 1 — Google AI Studio hesabı ve API anahtarı

1. https://aistudio.google.com/app/apikey sayfasını aç, Google hesabınla giriş yap.
2. Varsa ücretsiz katmandaki projeyi seç, yoksa `nutri-buddy-dev` adlı bir proje oluştur.
3. `Create API key` seçeneğiyle yeni anahtar oluştur. Projenin **Free Tier** durumunu ve hesap limitlerini kontrol et. Kredi kartı/ücretli katman açma.
4. Anahtarı **hiçbir sohbete gönderme** ve Flutter `.env.dev.json` veya Git deposuna ekleme.
5. Kullanım kotasını AI Studio üzerinde görebilirsin: https://aistudio.google.com/usage

Güncel fiyatlar: https://ai.google.dev/gemini-api/docs/pricing

**Gizlilik:** Gemini API ücretsiz katmanında istemler, fotoğraflar ve yanıtlar model/ürün geliştirmede ve insan incelemesinde kullanılabilir. Gerçek kullanıcılara ait sağlık verileri, kişisel bilgiler, yüzler ve tanımlanabilir görüntüler göndermeyin. Sadece kurgusal/test yemek fotoğrafları kullanın. Üretim sürümünde farklı veri işleme koşullarına sahip çözüm gerekir.

## 2 — Supabase Secrets

Supabase Dashboard → kendi NutriBuddy projen → `Edge Functions` → `Secrets`.

- `Key`: `GEMINI_API_KEY`
- `Value`: Google AI Studio'dan aldığın API anahtarın
- Kaydet.

Önceki `OPENAI_API_KEY` varsa **kullanılmıyor**. Daha sonra Supabase Secrets'ten silebilirsin. Anahtarları kesinlikle Android uygulamasında saklama.

## 3 — Kodu mevcut projene aktar

Flutter çalışıyorsa `q` ile durdur; PowerShell'de:

```powershell
cd C:\dev\projects\nutri_buddy
Copy-Item .\supabase\functions\analyze-meal\index.ts .\supabase\functions\analyze-meal\index.openai.backup.ts -ErrorAction SilentlyContinue
Expand-Archive `
  -Path "$HOME\Downloads\nutri_buddy_step5_gemini_patch.zip" `
  -DestinationPath "C:\dev\projects\nutri_buddy" `
  -Force
```

ZIP içindeki asıl dosya `supabase/functions/analyze-meal/index.ts` olacaktır. Ek olarak Markdown rehberi var.

## 4 — Supabase Edge Function güncelle

Supabase Dashboard → Edge Functions → `analyze-meal`.

- Fonksiyon daha önce **oluşturulmadıysa** yeni `analyze-meal` fonksiyonunu `Via Editor` ile oluştur.
- Daha önce oluşturduysan fonksiyonun **Edit Code** seçeneğine gir.
- Projedeki `supabase/functions/analyze-meal/index.ts` dosyasının tamamını (`Ctrl+A`, `Ctrl+C`) Supabase editöründeki koda yapıştır.
- `Deploy` / `Deploy updates` ile yayımla.
- `Verify JWT` seçeneğini **açık** tut. 401 hatası için bunu devre dışı bırakma.

**SQL:** Adım 5 `202610230001_stage5_vision_details.sql` migration dosyasını önceden başarıyla çalıştırdıysan tekrar çalıştırma. Henüz çalıştırmadıysan ana Adım 5 kurulumundaki SQL migration'ı **bir kez** çalıştır; günlük kota RPC'si buna bağlıdır.

## 5 — Android'de test

```powershell
cd C:\dev\projects\nutri_buddy
flutter analyze
flutter test
flutter run -d emulator-5554 --dart-define-from-file=.env.dev.json
```

Uygulamada hesabına giriş → Öğün ekle → kişisel bilgi içermeyen test yemek fotoğrafını seç → analizi onayla → `Fotoğrafı analiz et`.

- Sonuçta yemek adı, kcal, makrolar ve tahmini porsiyon görünmeli.
- Kullanıcı besinleri düzelterek onaylamadan öğün Isar'a eklenmemeli.
- Manuel öğün kaydı internetsiz çalışmaya devam etmeli.
- Supabase `Edge Functions → analyze-meal → Invocations / Logs` panelinden çağrıyı incele.

Sorun kodları: `server_not_configured` (GEMINI_API_KEY eksik), `provider_quota_exceeded` (Google ücretsiz kota aşıldı), `daily_quota_exceeded` (NutriBuddy'nin günlük kullanıcı kotası), `ai_request_failed` (Gemini API reddetti), `invalid_ai_result` (yanıt beklenen formatta değil). Hata loglarında anahtar ve fotoğrafları paylaşma.

## Bilinen sınırlamalar

- Google'ın Free Tier kotaları model ve projeye göre farklılık gösterir; sınırsız değildir.
- Kod ve ZIP kaynak kontrolü yerel olarak yapıldı; gerçek Supabase deploy ve Gemini isteği henüz çalıştırılmadı.
- Fotoğraftan hesaplanan kcal/makro/lif/vitaminler kesin besin değerleri değildir.
- Ücretsiz Gemini API prototip içindir; gerçek sağlık verileri için uygun kabul edilmemelidir.
