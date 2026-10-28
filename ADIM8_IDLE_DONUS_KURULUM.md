# NutriBuddy Adim 8 - One-Shot sonrasi Idle'a donus

Bu paket su dosyalari gunceller/ekler:
- `lib/features/buddy/presentation/widgets/buddy_mascot.dart`
- `lib/features/buddy/domain/usecases/buddy_animation_timing.dart`
- `test/buddy/buddy_animation_timing_test.dart`

Buddy'nin Rive `Happy` ve `Energetic` animasyonlari One-Shot olmali. Mevcut Rive `Happy -> Idle` (happy=false AND energetic=false) ve `Energetic -> Idle` (happy=false AND energetic=false) gecislerini SILMEYIN.

Animasyon kaynaklari bugunku surelerde: Happy 100 kare / 60fps, Energetic 64 kare / 60fps. Dart kontrolu sirasiyla yaklasik 1800 ms ve 1200 ms sonra Boolean girdilerini false yapar. Rive Editor'da sureleri degistirirseniz `buddy_animation_timing.dart` degerlerini de uyarlayin.

## Kurulum

1. Editor'daki son One-Shot degisikliklerini kaydedin; eski RML'yi push etmeyin.
2. `cd C:\dev\projects\nutri_buddy`
3. Flutter uygulamasi calisiyorsa `q` ile kapatin.
4. `Copy-Item .\lib\features\buddy\presentation\widgets\buddy_mascot.dart .\buddy_mascot.before_idle_patch.dart.bak`
5. ZIP dosyasini `Expand-Archive -Path "$HOME\Downloads\nutri_buddy_step8_idle_return_patch.zip" -DestinationPath "C:\dev\projects\nutri_buddy" -Force` ile acin.
6. `rive pull .\design\rive\nutri_buddy` (sorulursa lokal yedek alinmis oldugundan `y`)
7. `rive .\design\rive\nutri_buddy --verify` ve `rive .\design\rive\nutri_buddy --once`
8. `Copy-Item -Path ".\design\rive\nutri_buddy\build\nutri_buddy.riv" -Destination ".\assets\rive\nutri_buddy.riv" -Force`
9. `dart format lib test`, `flutter analyze`, `flutter test`
10. `flutter run -d emulator-5554 --dart-define-from-file=.env.dev.json`

## Beklenen

- Idle animasyonu surekli devam eder.
- Happy ve Energetic sadece bir kez oynar; sonrasinda Idle'a doner.
- Celebrate Trigger eskisi gibi bir kez oynar, uygun duruma doner.
- Mood metni gunluk kayit durumunu gostermeye devam eder.
- Terminal: `[Buddy/Rive] One-Shot bitti: Idle durumuna donuluyor.`

NOT: Bu ortamda Flutter SDK ve kullanicinin son guncel Rive Editor dosyasi olmadigi icin Android'e ait uygulamali test yapilamadi. Paket sadece daha onceki tanilama dart dosyasi temel alinarak gelistirildi. O dosyada kullanicinin baska yerel duzenlemesi varsa ustune yazmadan once diff kontrol edin.
