# NutriBuddy — Adım 10.16 / Güvenilir Buddy ödül günü

## Bu düzeltme neden gerekli?

İki gün için kayıt ekleyen bir kullanıcı, geçmiş günleri geriye dönük doldurarak her günün XP/altın haklarını kullanabiliyordu. 10.6 düzeltmesi günlük 3 öğün/8 su sınırını koruyordu ama ödül gününü kullanıcının düzenleyebildiği `logged_at` / `recorded_at` değerinden alıyordu.

Bu sürüm, **yeni kazanılacak ödüllerin** gününü sadece Supabase'in atadığı `created_at` değerinden hesaplar. Öğün/su günlüğü ve grafikler yine gerçek kayıt tarihlerini kullanır. Önceden verilmiş ödüllerin günleri, XP, altın ve eşya envanteri değişmez.

**Ürün dengesi:** Üç gün internet olmadan toplanan kayıtlar aynı gün eşitlenirse geçmiş üç güne ayrı ödül verilmez; eşitlendiği sunucu günündeki en çok 3 öğün ve 8 su ödülü alınabilir. Beslenme kayıtlarının tamamı kendi tarihlerinde kalır. Bu, ödül suistimalini sınırlandırmak için bilinçli bir tercihtir.

## Adımlar

1. Uygulama üzerinde aktif test yapmayı geçici olarak durdur. Supabase'de yedek/snapshot alabiliyorsan al.
2. ZIP'i proje köküne çıkart. Aşağıdaki iki dosya oluşmalı:
   - `supabase/migrations/202610270002_stage10_server_reward_day.sql`
   - `supabase/tests/stage10_server_reward_day_checks.sql`
3. **Yalnızca** `supabase/migrations/202610270002_stage10_server_reward_day.sql` dosyasını Supabase SQL Editor'da bir kez çalıştır. SQL Editor'da yalnızca `Success. No rows returned` beklenir.
4. Başarılıysa `supabase/tests/stage10_server_reward_day_checks.sql` dosyasındaki beş sorguyu **ayrı ayrı** çalıştır.
5. İlk doğrulamada iki tablonun `created_at` yazma/güncelleme izinleri `false`; ikincisinde iki alan `true`; üçüncüde boş gün/slot `0`; dördüncüde iki sütun `0`; beşincide günlük günü `2`, ödül günü `1` beklenir.
6. İkinci test hesabıyla bir öğün ve su kaydı ekle, Buddy ödülünü yalnızca bir defa alması gerektiğini doğrula; aynı kayda ikinci kez ödül verilmemeli. Günlük 3/8 kotası dolduysa ek ödül alınmaması normaldir.

## Korunan özellikler

- SQL yalnızca `claim_buddy_rewards()` fonksiyonunu değiştirir ve yetkiyi yeniden uygular. Tablo/veri kaydı güncellemez, silmez.
- Fonksiyonun `auth.uid()`, `FOR UPDATE`, günlük benzersiz slot, ödül tutarı, seviye, streak, çıktı sütunları aynıdır.
- Streak hâlâ kullanıcının olay tarihinden hesaplanır; streak oyunlaştırmasının ayrıca istismar edilebilirliği ileride değerlendirilebilir.
- Günlük limit UTC'ye göre 00:00'da sıfırlanır (Türkiye saatiyle genellikle 03:00).
- Gerçekten çevrimdışı oluşturulmuş bir yerel kaydın zamanını teknik olarak cihazdan doğrulayamıyoruz; bunu güvenilir sunucu ödül günüyle ayırıyoruz.

## Güvenlik ve geri alma

- Migration `BEGIN` / `COMMIT` altında atomiktir. Önkoşullar sağlanmıyorsa hata verip tamamen geri alınır.
- SQL'i yeniden çalıştırmak yerine hata mesajını paylaş.
- Eski fonksiyona dönmek gerekiyorsa yeni migration'ı silme veya ödül kayıtlarına müdahale etme. Yeni kazanılmış ödüller varsa öncelikle denetim sonucu alarak değişikliği planlamak gerekir.
- `created_at` yetkilerini daha sonra kullanıcıya açma; bu yeni ödül güvenliğinin temel şartıdır.
- Canlı Supabase/veritabanı fonksiyonunu burada çalıştırmadım; SQL yapısını ve paket dosyalarını kontrol ettim. Canlı kontrol sonuçlarına göre adımı tamamlayacağız.
