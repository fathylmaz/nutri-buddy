# NutriBuddy — Gemini HTTP 502 / ai_request_failed Tanılama

Bu paket Adım 5'teki `supabase/functions/analyze-meal/index.ts` dosyasının **yalnızca hata tanılamasını** günceller. Gemini API modelini, JSON şemasını, Flutter kodunu, kullanıcı kayıtlarını, Supabase SQL'ini ve Edge Function'ın istemci hata kodlarını değiştirmez. Sunucu loguna hassas veri, fotoğraf, API anahtarı, prompt veya sağlayıcının ham hata mesajını yazmaz.

## 1. Yerel dosyayı yedekleyip güncelle

```powershell
cd C:\dev\projects\nutri_buddy
Copy-Item ".\supabase\functions\analyze-meal\index.ts" ".\supabase\functions\analyze-meal\index.before_gemini_502_diagnostic.ts"
Expand-Archive -Path "$HOME\Downloads\nutri_buddy_step5_gemini_502_diagnostic.zip" -DestinationPath "C:\dev\projects\nutri_buddy" -Force
```

## 2. Supabase'deki fonksiyonu dağıt

Supabase Dashboard → Edge Functions → `analyze-meal` → Code/Editor bölümünde `supabase/functions/analyze-meal/index.ts` içeriğinin **tamamını** yapıştır ve güncellemeleri deploy et. VS Code dosyasının değişmesi tek başına buluttaki fonksiyonu güncellemez. `Verify JWT` ayarını kapatma. `GEMINI_API_KEY` secrets içinde kalmalı; anahtarı kaynak koda ekleme.

## 3. Tam bir kez test et

Emülatörde giriş yap, kişisel bilgi içermeyen bir yemek fotoğrafını bir kez analiz et. Beklenen hata hâlâ `HTTP 502 / ai_request_failed` olabilir; değişiklik esasen sunucu Log'una ek bilgi yazdırır.

Supabase Dashboard → Edge Functions → `analyze-meal` → **Logs** sekmesini aç. `Gemini upstream rejected request` kaydını bul. Yalnızca şu üç alanı paylaş:

- `upstreamHttpStatus` (ör. 400, 403, 404, 500)
- `upstreamErrorStatus` (ör. INVALID_ARGUMENT, PERMISSION_DENIED)
- `category` (ör. schema_or_generation_config_rejected)

API anahtarını, JWT'yi, fotoğrafı, kişisel verileri paylaşma.

## 4. Olası durumlar

| Kayıt | Sonraki kontrol |
|---|---|
| 400 + `schema_or_generation_config_rejected` | `responseJsonSchema` şemasını sadeleştirip Gemini çağrısını test et |
| 400 + `invalid_request` | Sağlayıcı yanıtının alan düzeyindeki sebebini güvenli biçimde izole et |
| 401 veya 403 | Gemini API anahtarı, Google AI Studio projesi/erişimi ve ülke/plan koşulları |
| 404 | API anahtarının erişebildiği model adını kontrol et |
| 429 | Gemini kota / ücretsiz katman limiti |
| 500 / 502 / 503 | Gemini tarafında geçici arıza; rastgele tekrar isteme |

## Kontroller

- Kaynak TypeScript sözdizimi Node 22 `--experimental-strip-types --check` ile kontrol edildi.
- Kullanıcıya dönen `ai_request_failed` yanıtı ve HTTP 502 davranışı korunuyor.
- Gerçek Gemini ve Supabase API çağrısı bu ortamda gerçekleştirilmedi.
