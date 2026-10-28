# NutriBuddy — Adım 9: Vector AI Dietitian / RAG kurulumu

Bu paket bir **overlay**'dir: `C:\dev\projects\nutri_buddy` içindeki mevcut 8 aşamayı korur ve yalnızca yeni Adım 9 kaynaklarını ekler; dashboard ve pubspec.yaml dosyalarını günceller. Isar şemasına ve Rive karakterine dokunmaz.

## 0) Yedek ve dosyaları kur

Flutter uygulamasını çalışan terminalde `q` ile durdur.

```powershell
cd C:\dev\projects
Copy-Item .\nutri_buddy .\nutri_buddy_backup_before_step9 -Recurse
Expand-Archive -Path "$HOME\Downloads\nutri_buddy_step9_overlay.zip" -DestinationPath 'C:\dev\projects\nutri_buddy' -Force
cd C:\dev\projects\nutri_buddy
```

## 1) Supabase SQL migration — ZORUNLU

Supabase Dashboard > SQL Editor > New Query:

`supabase/migrations/202610260001_stage9_vector_dietitian.sql`

Dosyanın **tamamını** yapıştır > Run. Bu işlem:

- `extensions.vector(768)` içeren kaynak tablosunu,
- sohbet ve mesaj tablolarını, kullanıcıya özel RLS politikalarını,
- gerçek pgvector benzerlik RPC'sini,
- kullanıcı başına günlük 12 istek kotasını,
- yalnızca yetkili sunucu rolünün çalıştırabildiği atomik sohbet kayıt RPC'sini,
- sekiz kurumsal kaynağın kısa Türkçe özetini

oluşturur. Mevcut kullanıcı/öğün/su/karakter tablolarını değiştirmez.

**ÖNEMLİ:** Kaynakların SQL'e eklenmesi yetmez; embedding indeksleme yapılmazsa RAG araması sonuç döndürmez. Bir sonraki adım zorunludur.

## 2) RAG kaynaklarını Gemini embedding ile indeksle — ZORUNLU

Supabase Dashboard > Edge Functions > Create Function > Via Editor. Fonksiyon adı **`index-dietitian-knowledge`** olsun.

`supabase/functions/index-dietitian-knowledge/index.ts` dosyasının *tamamını* editöre yapıştır ve deploy et.

**Bu fonksiyon yöneticilere özeldir.** Supabase Dashboard'da yalnızca bu fonksiyon için `Verify JWT` ayarını **OFF** yap; sunucudaki `withSupabase({auth:'secret'})` kontrolü yine zorunlu olarak Supabase projesinin **`default` secret API key** değerini `apikey` başlığında doğrular. JWT doğrulamasını `dietitian-chat` ya da çalışan diğer işlevler için kapatma. `index-dietitian-knowledge`'ı Flutter'a çağırma; secret key'i hiçbir Dart dosyasına, GitHub'a veya sohbete yazma.

Edge Function'ı Dashboard Test aracıyla **POST** olarak dene. Başlıklara projenin yalnızca yöneticilerin görebildiği **secret API key** değerini `apikey` anahtarıyla ekle. (Gerekirse Settings > API Keys bölümünden `default` adlı Supabase secret key'i kullan.) Gövde `{}`. Gizli anahtarı bana gönderme.

Beklenen örnek sonuç (gerçek sayılar değişebilir):

```json
{"indexed":8,"complete":true}
```

Ücretsiz Gemini kota veya API kısıtlaması olursa Edge Function Logs'a bak; güvenli `indexing_failed` hatası görebilirsin. Düzeltme sonrası yeniden POST işlemi, **yalnızca embedding'i boş kalanları** indeksler; eskilerini tekrar işlemez.

Supabase SQL Editor'da doğrula:

```sql
select count(*) as total, count(embedding) as indexed
from public.dietitian_knowledge;
```

**Beklenen: total=8, indexed=8.** `supabase/tests/stage9_dietitian_checks.sql` dosyasını da isteğe bağlı kontrol amacıyla çalıştırabilirsin.

## 3) AI sohbet Edge Function'ını deploy et — ZORUNLU

Edge Functions > Create Function > Via Editor, isim: **`dietitian-chat`**.

`supabase/functions/dietitian-chat/index.ts` dosyasının tamamını yapıştır > Deploy.

**Verify JWT = ON** kalsın. Bu fonksiyon `withSupabase({auth:'user'})` kullanır; oturum açmış kullanıcının JWT'si gereklidir. `GEMINI_API_KEY` mevcut Adım 5/6 secret'ından okunur; yeni anahtar veya Flutter'a secret eklemiyoruz.

`dietitian-chat` şunları yapar: Gemini 768 boyutlu soru embedding'i, RLS denetimli pgvector kaynak araması, kaynaklarla sınırlandırılmış Gemini Flash-Lite yanıtı, sunucu denetimli alıntılar ve yalnızca kullanıcıya ait sohbet kaydı.

## 4) Flutter derleme ve test

```powershell
cd C:\dev\projects\nutri_buddy
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d emulator-5554 --dart-define-from-file=.env.dev.json
```

`build_runner` **gerekmez**; Adım 9 yeni Freezed veya Isar codegen modeli eklemiyor.

## 5) Android kabul testleri

1. Dashboard üstündeki **sohbet balonu** simgesinden AI Beslenme Asistanı sayfasını aç.
2. Onay kutusu **işaretli değilken** soru gönderme butonu pasif olmalı.
3. Onayla; **günlük özet paylaşımı kutusunu kapalı bırak**. "Lifli yiyecekler hangileri?" sorusunu gönder.
4. Yanıt ve gerçek WHO/CDC/NIH kaynak düğmeleri gelmeli, kaynak URL'leri `https://` olmalı.
5. Yeni sohbet aç; geçmiş sohbetini tekrar aç ve yanıtın korunduğunu kontrol et.
6. Yeni bir soruda günlük özet paylaşımını açıkça aç; yalnızca sayısal kalori, protein, yağ, karbonhidrat, su, öğün sayısı ve hedef kalori gönderilir. Alerji, hastalık, profil adı, tam öğün isimleri gönderilmez (kullanıcı soru metnine kendisi eklerse hariç).
7. Sohbeti sil; mesajlar tekrar görünmemeli. RLS'yi doğrulamak için başka bir hesapla giriş yapıp ilk hesaba ait sohbetlere erişim olmadığını kontrol et.
8. Buddy/Rive, Vision AI, AI tarif oluşturucu, su ve grafik ekranlarının çalıştığını doğrula.

## Hata rehberi

- `HTTP 401` → Oturum/JWT, doğru proje, `dietitian-chat` JWT ayarı.
- `HTTP 503 knowledge_not_indexed` → İndeksleme eksik. SQL ile `indexed` kontrol et.
- `HTTP 503 vector_search_failed` → pgvector boyutu, RPC ve migration.
- `HTTP 429 daily_quota_exceeded` → UTC gününde 12 çağrı sınırı doldu. Test spam'i yapma.
- `HTTP 502 ai_unavailable` → Gemini model/embedding sağlayıcısı erişimi veya kota. Edge Logs içindeki güvenli sağlayıcı HTTP durumunu incele.
- `history_save_failed` → Mesaj RPC yetkileri veya migration'ın eksik uygulanması.
- `flutter analyze` / `flutter test` hataları → Terminal çıktısını gönder, Adım 9 içinde düzelteceğiz.

## Sınırlar ve veri gizliliği

- Sohbet **bulut üzerinden** çalışır, çevrimdışıyken yeni yanıt üretmez. Isar'a sohbet cache'i bu sürümde eklenmez.
- Kullanıcının yazdığı soru ve önceki sohbetin **son sekiz mesajı** Gemini'ye gönderilebilir. Kullanıcı ayrıca işaretlemediği sürece günlük beslenme özeti gönderilmez. Sohbetler kullanıcının Supabase hesabında kalıcıdır ve silinebilir; üçüncü taraf Gemini'nin veri işleme kuralları ayrıca geçerlidir. Ücretsiz API kullanımında hassas bilgileri sohbete yazmaktan kaçın.
- Model tıbbi teşhis, ilaç veya takviye dozlama sistemi değildir. Alerjen ve çapraz bulaşma güvenliğini garanti etmez. Model yanıtları hatalı olabilir.
- RAG kaynakları **canlı web'den çekilmiyor**; SQL migration'daki kurumsal kaynaklardan hazırlanmış kısa notlardır. Üretim ortamında doğruluk/güncelleme ve yeni kaynak ekleme süreci gerekir.
- Kaynakların sağlandığı ancak modelin kullanmadığı yanıtlar için arayüz 'doğrulanmış kaynak belirtilmedi' mesajı gösterir; uydurma kaynak üretmez.
- Uygulama katmanında 3–900 karakter doğrulaması, sunucuda JWT doğrulaması, günlük kota ve RLS vardır. Yine de üretime çıkmadan önce klinik içerik moderasyonu, denetim ve gizlilik politikası incelemesi gerekir.

### Resmî teknik kaynaklar

- Supabase pgvector: https://supabase.com/docs/guides/database/extensions/pgvector
- Supabase Edge Functions Auth: https://supabase.com/docs/guides/functions/auth
- Gemini embeddings: https://ai.google.dev/api/embeddings
- WHO Healthy diet: https://www.who.int/news-room/fact-sheets/detail/healthy-diet
- CDC Steps for Losing Weight: https://www.cdc.gov/healthy-weight-growth/losing-weight/index.html
- NIH ODS Vitamin D: https://ods.od.nih.gov/factsheets/VitaminD-HealthProfessional/
