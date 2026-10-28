# NutriBuddy — Adım 9: dietitian-chat HTTP 401 düzeltmesi

## Bulgu

Supabase Edge Functions → dietitian-chat → Invocations ekranında POST istekleri 401 dönüyor. Geçerli kullanıcı JWT'siyle `withSupabase({auth:'user'})` başarılı olsa bile eski dosyada yanlış kullanıcı alanı okunuyor:

- Hatalı: `ctx.userClaims?.sub`
- Doğru: `ctx.userClaims?.id`

`sub`, ayrı `ctx.jwtClaims?.sub` nesnesindeki alandır. `userClaims` normalize edilmiş kimlik nesnesindeki `id` alanını kullanır. Önceki kod doğrulanmış kullanıcıda bile `not_authenticated` / HTTP 401 dönebilir.

Bu ZIP önceki 768-boyut Gemini embedding düzeltmesini **korur**. Ek olarak ID yoksa güvenli bir tanılama kaydı yazar: `[dietitian-chat] verified_user_id_unavailable`. API anahtarı, JWT, soru veya kullanıcı ID'sini loglamaz.

## 1. Yedekle ve ZIP'i uygula

Flutter uygulamasını kapatman gerekmez. PowerShell:

```powershell
cd C:\dev\projects\nutri_buddy
Copy-Item '.\supabase\functions\dietitian-chat\index.ts' '.\supabase\functions\dietitian-chat\index.before_auth_fix.ts' -Force
Expand-Archive -Path "$HOME\Downloads\nutri_buddy_step9_auth_fix.zip" -DestinationPath 'C:\dev\projects\nutri_buddy' -Force
Select-String -Path '.\supabase\functions\dietitian-chat\index.ts' -Pattern 'const userId='
```

Son komutta `const userId=ctx.userClaims?.id;` görünmeli.

## 2. Supabase fonksiyonunu güncelle

Supabase → Edge Functions → **dietitian-chat** → **Code** → güncellenmiş `index.ts` dosyasının **tamamını** yapıştır → **Deploy updates**.

`index-dietitian-knowledge` fonksiyonunu veya SQL migration'ı yeniden çalıştırma; 8 embedding zaten hazır.

**JWT ayarını bu adımda değiştirme.** Fonksiyonun `withSupabase({auth:'user'})` doğrulaması kullanıcı oturumunu gerektirir.

## 3. Tek sohbet testi

Uygulamada oturum açıkken AI diyetisyene `Sağlıklı beslenmede sebze ve meyve tüketimi neden önemlidir?` diye **bir kez** sor. Yanıt ve kaynaklar görünüyorsa sohbet geçmişini test et.

Hâlâ HTTP 401: Supabase `dietitian-chat` → **Invocations** → en son isteği seç → **response body** içindeki hata koduna bak (örn. `Invalid JWT`, `INVALID_JWT`, `not_authenticated`). JWT/API anahtarı paylaşma.

HTTP 502/503: İstek artık auth katmanını geçmiş olabilir; `dietitian-chat` → Logs bölümünde `[dietitian-chat]` ile başlayan hata kodunu incele.

## Doğrulama sınırı

Paketin bütünlüğü ve kaynak değişikliği kontrol edildi. Gerçek Android/Supabase çalışması senin ortamında doğrulanmalıdır.

Kaynak: https://supabase.github.io/server/interfaces/index.UserClaims.html
