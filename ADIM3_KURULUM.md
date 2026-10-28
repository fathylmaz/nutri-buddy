# NutriBuddy — Adım 3: Supabase Auth + Dinamik Onboarding

> Mevcut çalışan Adım 2 Flutter projesine eklenir. Adım 2 Supabase SQL migration **tekrar çalıştırılmaz**.

## Neler eklendi?

- Domain: `AuthRepository`, `ProfileService` sözleşmeleri, `NutritionCalculator` kullanımı
- Data: `SupabaseAuthRepository`, `IsarUserRepository`, `OfflineFirstProfileService`, `UserProfileMapper`, hesap çıkışı temizleyicisi
- Presentation: AuthGate, kayıt / giriş ekranı, 3 adımlı onboarding, BMR / TDEE / makro özeti
- Test: Günlük hedef hesaplama, mapper, giriş sayfası, mevcut stage testleri
- Supabase şema uyumluluğu: Adım 2'deki `users` kayıt tetikleyicisi ve yetkiler kullanılır

## Önemli: veri koruma sınırları

1. **Gerçek kullanıcı veya tıbbi veriyle prod kullanıma hazır değildir.** Isar yerel dosyası şifreli değil. Şimdilik yalnızca örnek/test verisi kullanın. Üretimde şifreli yerel depolama, kimlik doğrulama güvenliği, KVKK/GDPR gereksinimleri, açık ve geri çekilebilir onam, hesap silme ve veri dışa aktarma mekanizması tamamlanmalı.
2. **API key:** `.env.dev.json` içindeki yalnızca `SUPABASE_URL` ve `SUPABASE_PUBLISHABLE_KEY`. `secret`, `service_role`, OpenAI şifresi veya veritabanı şifresi mobil istemciye eklenmez. `.env.dev.json` `.gitignore` içinde gizli tutulmalıdır (yayınlanmamalı). Publishable key sır değil; RLS zorunlu güvenlik kontrolüdür.
3. **Offline-first sınırı:** Profil önce Isar'a kayıt edilir ve bekleyen değişiklik işaretlenir. Supabase bağlantısı varsa aynı anda `UPDATE` denenir. Başarısızsa profili yerel olarak tutar; kullanıcı özet ekranındaki **Bulut eşitlemesini dene** düğmesiyle yeniden gönderebilir. Otomatik arka plan tekrar denemesi, çatışma çözümü ve çok cihazlı gerçek zamanlı tam sync **henüz yok**.
4. **Oturum:** Yeni hesap açmak / giriş yapmak internet gerektirir. Süresi dolmamış önceki oturum ve daha önce önbelleğe alınmış profil çevrimdışı görüntülenebilir. Oturum geçersizse tekrar çevrimiçi giriş gerekir.
5. **Çıkış:** Eşitlenmeyen yerel değişiklikler varsa kullanıcı uyarılır; çıkışta hesabın tüm yerel verileri silinir. Bu güvenli disk silme değildir.
6. **Tıbbi kullanım:** Mifflin-St Jeor yalnızca yetişkin tahminidir. Otomatik agresif kilo kaybı yoktur. Kalori tabanları klinik onay yerine geçmez. Gebelik/emzirme, kronik hastalık veya yeme bozukluğu geçmişinde kişiselleştirilmiş tıbbi öneri verilmez.
7. Adım 4 dashboard, Adım 5 fotoğraf, Adım 6 tarif, Adım 7 analitik, Adım 8 Buddy, Adım 9 AI diyetisyen **eklenmedi**.

## Windows kurulum

1. Uygulamayı çalıştıran terminalde `q` tuşuna bas.
2. **Yedek al** (ikinci kez zaten yapılmışsa benzersiz klasör kullan):

```powershell
cd C:\dev\projects
Copy-Item .\nutri_buddy .\nutri_buddy_backup_before_step3 -Recurse
```

3. ZIP'i Downloads'a kaydet ve üstüne aç:

```powershell
Expand-Archive `
  -Path "$HOME\Downloads\nutri_buddy_step3_overlay.zip" `
  -DestinationPath "C:\dev\projects\nutri_buddy" `
  -Force
```

4. Hâlihazırda çalışan `pubspec.yaml` sürümlerini koruyun; **yeni paket kurmak gerekmiyor**. Önceki aşamanın `build_runner: 2.16.2` satırı kalmalı.

```powershell
cd C:\dev\projects\nutri_buddy
flutter pub get
dart run build_runner build
dart format lib test
flutter analyze
flutter test
flutter run -d emulator-5554 --dart-define-from-file=.env.dev.json
```

5. Supabase Dashboard → **Authentication → Providers → Email** bölümünde e-posta sağlayıcısının etkin olduğundan emin ol. E-posta doğrulaması açıksa kayıt sonrası gelen doğrulama bağlantısını açıp **Giriş yap** sekmesinden oturum aç. Supabase ücretsiz plandaki e-posta gönderim kısıtlarını göz önünde bulundur; geliştirme/test için ayrı bir e-posta kullan.

## Kullanım / kabul kontrolü

1. Test e-posta ve şifreyle kayıt; doğrulama gerekiyorsa tamamla ve giriş yap.
2. Üç adımlı onboarding bilgilerini test değerleriyle doldur. 18 yaş altı profilin engellendiğini kontrol et.
3. Özet ekranında enerji ve gram cinsinden hedefler görünsün.
4. Supabase → Table Editor → `public.users` tablosunda test hesabının kendi kaydında hedef, kilo, aktivite güncellensin. `auth.users` kullanıcıları SQL Editor'dan doğrudan değiştirme.
5. İnternet bağlantısını emülatörden kapatıp **Bilgilerimi düzenle** üzerinden test değişikliği yap. Özet ekranında eşitlenmemiş değişiklik uyarısını gör. İnterneti açıp **Bulut eşitlemesini dene** seç ve Supabase'de değişikliği doğrula.
6. Çıkış yapınca giriş ekranına dön; tekrar girince buluttaki profil bilgileri yüklenebilsin.
7. `flutter analyze` temiz, `flutter test` tüm testler başarılı ve Android `flutter run` çalışır.

## Sorun giderme

- `Email not confirmed`: e-posta kutusunda doğrulama bağlantısını kullan.
- `Invalid login credentials`: e-posta/şifreyi kontrol et.
- Kayıt sırasında `Database error saving new user`: Adım 2'deki `private.on_auth_user_created` fonksiyonu ve `nutri_buddy_auth_user_created` tetikleyicisi var mı kontrol et.
- Profil yalnızca yerelde: ağ, oturum ve RLS güncelleme izinleri kontrol edilmeli. Önceki Adım 2 SQL'i **yeniden çalıştırma**.
- Testlerin başarısız olması: `dart run build_runner build` komutu tamamlandı mı? Generated `.g.dart`/`.freezed.dart` dosyalarını elle değiştirme.

## Supabase ek SQL gerekiyor mu?

Hayır. Adım 2'nin `public.users` tablosu gerekli sütunlara ve `authenticated` kullanıcısı için `UPDATE` sütun izinlerine sahip. Yeni `CREATE TABLE`/`ALTER TABLE` komutu yok. İstersen `supabase/tests/stage3_checks.sql` dosyasını SQL Editor'de **yalnızca görüntüleme amacıyla** çalıştırabilirsin.
