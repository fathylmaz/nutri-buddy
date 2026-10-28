# NutriBuddy — Adım 8: Buddy Gamification / Rive entegrasyonu

## Kurulum sırası

1. Projeni yedekle. Emülatördeki uygulamayı SİLME; Isar kayıtları kaybolabilir.
2. `nutri_buddy_step8_overlay.zip` dosyasını `C:\dev\projects\nutri_buddy` içine `Expand-Archive ... -Force` ile aç.
3. Supabase SQL Editor'da **yalnızca** `supabase/migrations/202610240001_stage8_buddy_rewards.sql` dosyasını çalıştır. Bu, ödül işlemleri, katalog ve sunucu tarafı RPC'leri kurar. Eski migration'ları yeniden çalıştırma.
4. `supabase/tests/stage8_buddy_checks.sql` dosyasını SQL Editor'da kontrol amaçlı çalıştır (yalnızca SELECT).
5. Terminal:

```powershell
cd C:\dev\projects\nutri_buddy
flutter pub get
dart run build_runner build
dart format lib test
flutter analyze
flutter test
flutter run -d emulator-5554 --dart-define-from-file=.env.dev.json
```

## Test akışı

- Dashboard sağ üstündeki **pati** simgesiyle Buddy'yi aç.
- Animasyonlu maskot görünmeli, XP ve altın görünmeli.
- **Ödülleri eşitle**: Sunucudaki gerçek öğün/su kayıtlarından hak edilen ödülleri tek seferlik alır. İlk çağrıda daha önceki son 90 güne ait kayıtlar için puan verilebilir. Aynı kayıt için ikinci kez puan verilmez.
- Bir öğün/su kaydı ekleyip eşitle, sonra Buddy'ye dönüp yenile. XP gelişimini kontrol et.
- **Mağaza**: Yeterli altınla öğe satın al ve `Kullan` de. Kazanılmış altın sadece sunucu üzerinden harcanır.
- Uygulamayı kapatıp aç: son XP değeri, Isar sayesinde çevrimdışı görünmeli.
- Emülatör internetini kapat: Buddy ve animasyon görünmeli; yeni ödül çevrimdışı uydurulmaz, bulut geldiğinde güncellenir.
- Başka hesaba giriş yap: XP diğer hesabın cache'inden okunmamalı.

## Rive karakter varlığı

Paket, **Rive 0.14.x runtime entegrasyonu ve animasyonlu Flutter yedek karakteri** içerir. Üçüncü parti bir `.riv` dosyasının kullanım/yeniden dağıtım hakkını varsaymadığımız için hazır Rive çizimi içermez.

Özgün maskotunu https://rive.app üzerinde çizip `assets/rive/nutri_buddy.riv` olarak export et. İsteğe bağlı State Machine girişleri: `happy` (Bool), `energetic` (Bool), `celebrate` (Trigger). Bir asset geldiğinde Rive otomatik etkinleşir; asset eksik veya bozuk olduğunda Flutter maskotu görünür. `assets/rive/` yolu `pubspec.yaml` içerisinde bildirilmiştir.

Gerçek Rive çizimini, ruhsatını ve State Machine animasyon geçişlerini test etmek de Adım 8'in **tam kabul kriteridir**; bunu yapmadan özgün Rive sanat varlığının tamamlandığını iddia etmiyoruz.

## Ödül güvenliği

- `pets`, `items`, `user_items` istemciden doğrudan yazılamaz (RLS).
- `claim_buddy_rewards()` kayıt kimliği üzerinden idempotent ödül verir, aynı kaydı tekrar ödüllendirmez. Günlük tavan: 3 öğün / 8 ölçülü su kaydı (UTC günü).
- `buy_buddy_item` ve `equip_buddy_item` sahiplik ve bakiye kontrolünü atomik yapar.
- Bu, kötüye kullanıma tamamen dayanıklı bir anti-cheat sistemi değildir: sunucuya sahte öğün/su kayıtları gönderen kullanıcılar puan kazanabilir. Gerçek ürün aşamasında kayıt güvenilirliği ve oran sınırları ayrı kontrol edilmelidir.
- Ödül kuralları tıbbi/sıvı alımı tavsiyesi değildir. Daha çok yemek veya su tüketmeye teşvik edilmemelidir.

## Bilinen kapsam sınırları

- Yeni puanlar yalnızca sunucuya eşitlenmiş 90 günlük kayıtlar için hesaplanır.
- Yerel cache, oturum sırasında çevrimdışı XP'yi gösterir; gerçek seviye/altın sunucunun otoritesindedir.
- Katalog ve donanım görseli Rive dosyası olmadan Flutter ikonlarıyla temsil edilir.
- Yeni SQL migration'u mutlaka çalıştırılmalıdır; eksikse `claim_buddy_rewards` RPC bulunamaz.
