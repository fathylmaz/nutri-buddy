# NutriBuddy — Gemini 404 NOT_FOUND model düzeltmesi

## Teşhis
Gemini 2.5 Flash yeni projelerde sınırlı erişime sahip. Supabase `analyze-meal` çağrısı Gemini tarafında `404 NOT_FOUND` ve `model_not_found_or_unavailable` döndürüyor. Bu paket yalnızca Edge Function içindeki model adresini `gemini-3.5-flash-lite` olarak günceller. OpenAI/Gemini anahtarları, JWT, kota, veritabanı ve Flutter dosyaları değiştirilmez.

## Kurulum
1. Supabase Edge Function `analyze-meal` açıkken mevcut sürümden yedek al.
2. Windows PowerShell:
```powershell
cd C:\dev\projects\nutri_buddy
Copy-Item .\supabase\functions\analyze-meal\index.ts .\supabase\functions\analyze-meal\index.before_model_fix.ts
Expand-Archive -Path "$HOME\Downloads\nutri_buddy_step5_gemini_model_fix.zip" -DestinationPath "C:\dev\projects\nutri_buddy" -Force
Select-String -Path .\supabase\functions\analyze-meal\index.ts -Pattern 'gemini-3.5-flash-lite'
```
3. Supabase Dashboard -> Edge Functions -> analyze-meal -> Code ekranında güncellenmiş `index.ts` tamamını yapıştır ve **Deploy updates** yap. JWT doğrulaması açık kalsın.
4. Flutter'ı yeniden derlemene gerek yok; uygulamadaki fotoğraf analizini bir kez dene.
5. Hata devam ederse Supabase Invocations / Logs içerisindeki `upstreamHttpStatus`, `upstreamErrorStatus`, `category` bilgilerini gönder. Aynı 404 olursa API anahtarına gerçekten hangi modellerin açık olduğunu `GET /v1beta/models` ile listeleyerek seç.

## Güvenlik
`GEMINI_API_KEY` sadece Supabase Secrets içinde kalmalı. Fotoğraf, JWT, API anahtarı veya kişisel profil bilgilerini günlüklerde paylaşma. Ücretsiz Gemini katmanı hassas sağlık verileri için uygun değildir; anonim test yemek görselleri kullan.

## Doğrulama notu
Paket içerik bütünlüğü kontrol edildi, Flutter ve gerçek Gemini isteği bu ortamda yürütülmedi.
