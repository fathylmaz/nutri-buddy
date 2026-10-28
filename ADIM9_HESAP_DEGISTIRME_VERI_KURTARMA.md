# NutriBuddy — Hesap değişimi, buluttan geçmişi geri yükleme ve çıkış yönlendirmesi

Bu paket, önceki 9 aşamadan sonraki veri kaybı riskini azaltmak için hazırlanmıştır.

## Doğrulanmış kök neden

Önceki uygulama `signOutAndClear()` ile oturum sahibinin Isar verilerini, bekleyen mutasyonları da kapsayacak şekilde siliyordu. Su/öğün/kilo eşitlemesi ise yalnızca **yükleme** yapıyordu; başka hesapla girişten sonra cloud kayıtları tekrar **indirilmiyordu**. Profil sayfası Navigator üzerinden açıldığından çıkış sonrası ekranda kalabiliyordu.

## Güvenli kurulum

1. Flutter terminalinde `q` ile çalışmayı durdur. Android emülatörde NutriBuddy'yi veya verilerini silme.
2. PowerShell'de proje yedeği al:

```powershell
cd C:\dev\projects
Copy-Item .\nutri_buddy .\nutri_buddy_backup_before_account_restore -Recurse
```

3. ZIP'i Downloads klasörüne indir. **Tek satırlık** komutla projeye aç:

```powershell
Expand-Archive -Path "$HOME\Downloads\nutri_buddy_account_restore_logout_fix.zip" -DestinationPath "C:\dev\projects\nutri_buddy" -Force
```

4. Derle, test et, uygulamayı başlat:

```powershell
cd C:\dev\projects\nutri_buddy
dart format lib test
flutter analyze
flutter test
flutter run -d emulator-5554 --dart-define-from-file=.env.dev.json
```

Yeni Supabase migration, yeni secret veya JWT ayarı gerekmez.

## İlk kurtarma testi

1. Eski/orijinal hesapla giriş yap. Dashboard otomatik olarak **sadece o hesaba ait** `logs`, `water_entries`, `weight_entries` satırlarını geri almayı dener. Yerel bekleyen kayıtları önce buluta göndermeye çalışır; gönderme başarısız olsa bile **asla yerel kayıtları silmez**.
2. Dashboard → Öğün günlüğü → **Buluttaki geçmişimi geri getir** butonuna bas. Başarı mesajında yeni eklenen öğün, su ve kilo sayısı görünür. Düğme tekrar basıldığında, zaten yerel kayıtlı satırlar yeniden çoğaltılmaz.
3. Öğünleri ve suyu Dashboard'da, eski ölçümleri **Analizler ve Grafikler** ekranında kontrol et. Başka tarihlerdeki kayıtların bugünün Dashboard toplamına eklenmemesi doğrudur; 7/30/90 gün aralığından kontrol et.
4. Test için küçük bir su/öğün kaydı ekle; çıkış yap; giriş ekranına dönmelisin. Eski hesapla yeniden giriş yap: kayıtlar görünmeye devam etmeli. Ardından ikinci test hesabı ile giriş yap: ilk hesabın öğünleri ve grafikleri görünmemeli.

## Eski kayıtlar hiç görünmezse

Supabase **Table Editor** kısmında ayrı ayrı `logs`, `water_entries`, `weight_entries` tablolarını aç. **Eski hesabın `user_id` değerine filtre uygula** (Authentication → Users sayfasından kullanıcı ID bulunur), `is_deleted = false` kayıtları denetle. İlgili kayıtlar Supabase'de duruyorsa uygulama bunları indirebilmelidir. Kayıtlar ne Supabase'de ne de yerel Isar'da varsa önceki çıkış sırasında kaybolmuş olabilir; paket yoktan veri üretemez. SQL Editor'da DELETE/TRUNCATE komutu çalıştırma.

## Güvenlik sınırları ve teknik notlar

- İstemciye service-role/secret API anahtarı koyulmaz; Supabase JWT, ilgili kullanıcının `user_id` filtresi ve mevcut RLS uygulanır.
- Eşitlenmemiş yerel kayıtlar her zaman korunur; uzaktaki yeni revizyonlar yalnızca beklemeyen yerel kayıtlara uygulanır.
- Veriler cihazda hesabın `userId` alanına göre ayrılır. Çıkışta artık yerel sağlık kayıtları silinmez. Paylaşılan/fiziksel olarak güvensiz cihazlarda at-rest şifreleme ve **isteğe bağlı güvenli önbellek temizleme** üretim öncesi ayrıca ele alınmalıdır.
- Bu, mevcut uygulamaya yönelik *geri yükleme* düzeltmesidir. Çok cihazlı eşzamanlı değişikliklerde tam konflikt çözümü, uçtan uca RLS testleri ve büyük veri kümesi performansı ayrıca sınanmalıdır.
- Paket kaynakları mevcut aşama ZIP'lerinden birleştirilerek hazırlanmıştır. Kullanıcının yerel projesinde bu arada elle yapılmış farklılıklar varsa yedekten diff kontrolü yapılmalıdır.
- Geliştirme ortamında Flutter SDK/Android SDK burada bulunmadığı için ZIP bütünlüğü ve statik kontroller dışında `flutter analyze`/`flutter test` henüz yürütülemedi.
