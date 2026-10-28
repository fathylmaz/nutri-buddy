# NutriBuddy — Adım 9: `invalid_embedding` düzeltmesi

## Problem

Supabase `index-dietitian-knowledge` Logs ekranında `[dietitian-index] indexing_stopped invalid_embedding` görünüyor. SQL `total=8, indexed=0`. Bu hata, Gemini `embedContent` çağrısı **başarılı HTTP yanıtı döndürdükten sonra**, vektörün kod tarafından uygun bulunmadığını gösterir. Kesin nedeni görmek için yeni tanılama logları eklenmiştir.

## Ne değişti?

- Google'ın REST örneklerindeki üst-seviye `taskType`, `title` ve `outputDimensionality:768` alanları kullanılır.
- Gemini 768 boyut yerine varsayılan 3072 boyutu döndürürse, modelin Matryoshka özelliğiyle ilk 768 bileşen alınır ve L2 normalize edilir.
- Geçersiz yanıtlar kabul edilmez; yalnızca **boyut**, alanın olup olmadığı ve hata türü loglanır. Anahtar, metin ve sayısal vektör loglanmaz.
- **Her iki fonksiyon güncellenir**: bilgi indeksleyicisi ve sohbet fonksiyonu. Böylece sorgu ve kaynak vektörleri aynı model, boyut ve normalleştirme yöntemiyle hesaplanır.
- Model adı, SQL şeması, JWT ayarı, Flutter kodu değişmez.

## Kurulum (Windows PowerShell)

```powershell
cd C:\dev\projects\nutri_buddy

Copy-Item .\supabase\functions\index-dietitian-knowledge\index.ts .\supabase\functions\index-dietitian-knowledge\index.before_embedding_fix.ts
Copy-Item .\supabase\functions\dietitian-chat\index.ts .\supabase\functions\dietitian-chat\index.before_embedding_fix.ts

Expand-Archive -Path "$HOME\Downloads\nutri_buddy_step9_embedding_fix.zip" -DestinationPath "C:\dev\projects\nutri_buddy" -Force
```

## Supabase Deploy

Dashboard → Edge Functions → `index-dietitian-knowledge` → Code → dosyanın tamamını yapıştır → **Deploy updates**.

Dashboard → Edge Functions → `dietitian-chat` → Code → dosyanın tamamını yapıştır → **Deploy updates**.

`index-dietitian-knowledge`: **Verify JWT with legacy secret OFF**, kod içi `auth: 'secret'`; **yalnızca Supabase secret `apikey` başlığıyla** yönetici testi yapılır. Secret key Flutter'a veya GitHub'a konulmaz.

`dietitian-chat`: **Verify JWT açık**, `auth: 'user'`.

## Test

`index-dietitian-knowledge` → Test → POST, Body `{}`, Headers `apikey` = projenin `default` secret anahtarı → Send Request. (Anahtarı kimseye gönderme.)

Ardından SQL Editor:

```sql
select count(*) as total, count(embedding) as indexed
from public.dietitian_knowledge;
```

Beklenen: `total=8, indexed=8`. Indexleme fonksiyonu `indexed:8` döndürebilir; yeni çağrıda 8 kayıt kalmazsa `indexed:0, complete:true` dönebilir. Bu yüzden **SQL count** asıl kanıttır.

Eğer yine `indexing_failed` çıkarsa Supabase Logs'taki son `[dietitian-index]` kayıtlarını gönder: `invalid_embedding_shape` altında sadece `dimension` ve `hasValues` gibi güvenli alanlar bulunur. `embedding_provider_failed` yeni bir hata olursa HTTP kodunu gönder. Gemini API anahtarını veya secret'ı paylaşma.

## Kaynak

Google Gemini embeddings API: https://ai.google.dev/gemini-api/docs/embeddings
REST şeması: https://ai.google.dev/api/embeddings

Bu paket kaynak kodunu ve ZIP bütünlüğünü kontrol ederek oluşturuldu. Flutter SDK veya uzak Supabase projesinde canlı test yapılmadı.
