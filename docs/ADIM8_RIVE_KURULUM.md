# NutriBuddy Buddy — Ozgun Karakter ve Rive Animasyon Projesi

Bu paket **kaynak RML ve katmanli ozgun SVG tasarimidir**. Bu arsivde gercek `.riv` dosyasi
bulunmuyor: derleme Rive CLI ile senin Windows bilgisayarinda yapilacak.

## 1. Tasarim
- `assets/brand/buddy_character_sheet.png`: dort ifadeli konsept sayfasi.
- `assets/brand/nutri_buddy_preview.png`: RML icin sade vektor maskot gorsel onizlemesi.
- `assets/brand/nutri_buddy_layers.svg`: vektor kaynak ve isimlendirilmis cizim katmanlari.
- `design/rive/nutri_buddy/scene.rml`: Rive Markup Language kaynak sahnesi.
- `design/rive/nutri_buddy/rive.yaml`: Rive CLI proje ayari.

RML sahnesinde Buddy artboardu, gorsel nesneler ve 4 animasyon zaman cizelgesi vardir:
`Idle`, `Happy`, `Energetic`, `Celebrate`. `BuddyMachine` simdilik **Idle** durumunu oynatir.
Diger ucu Rive Editor'da state machine input ve gecislerini tamamlamayi gerektirir.

## 2. Rive CLI kurulumu (Windows)
Resmi kaynak: https://rive.app/docs/cli/getting-started ve https://rive.app/agents

Tarayicidan resmi `https://rive.app/downloads` sayfasindan CLI yi kurabilirsin.
Alternatif olarak **resmi kurulum betigini inceleyip guveniyorsan** PowerShell'de:

```powershell
irm https://releases.rive.app/cli/install.ps1 | iex
```

PowerShell'i kapatip ac; `rive doctor` komutunu calistir.

## 3. Projeyi derle ve dogrula

Paketin icinde ayrica `tools/build_buddy_rive.ps1` yardimci betigi var.
Alternatif olarak asagidaki CLI komutlarini dogrudan kullanabilirsin.

```powershell
cd C:\dev\projects\nutri_buddy
rive .\design\rive\nutri_buddy --verify
rive .\design\rive\nutri_buddy --once
rive inspect .\design\rive\nutri_buddy --summary
```

Rive CLI surumune gore `--once` destegi degisirse `rive .\design\rive\nutri_buddy`
komutu da projeyi canli onizleme ve otomatik derleme ile calistirir.

Derlenen dosya normalde `design/rive/nutri_buddy/build/nutri_buddy.riv` yoluna yazilir.

**Onemli:** Bu RML bu ortamda Rive CLI ile derlenememistir. `--verify` hata
verirse bildirimi paylas; kaynak RML'yi ona gore duzeltelim.

## 4. Gercek interaktif Rive davranislari — Editor adimi

Rive Editor ile calismak icin once Rive hesabina `rive login` ile baglanip
`rive push .\design\rive\nutri_buddy` komutuyla kaynak projeyi Editor hesabina gonderebilirsin.
`Buddy` artboardunda `BuddyMachine` state
machine mevcut. `Idle` baslangic durumudur. `Happy`, `Energetic`, `Celebrate`
timeline'lari bulunmaktadir.

* `happy` adli **Boolean** input ekle (Flutter kodu ayni adi kullaniyor).
* `energetic` adli **Boolean** input ekle.
* `celebrate` adli **Trigger** input ekle.
* Yeni animation state'ler: `Happy` -> Happy timeline, `Energetic` -> Energetic
  timeline, `Celebrate` -> Celebrate timeline.
* `Idle` -> `Happy`: `happy == true` ve `energetic == false`.
* `Happy` -> `Idle`: `happy == false` ve `energetic == false`.
* Her durumdan `Energetic`: `energetic == true`.
* `Energetic` -> `Happy`: `energetic == false` ve `happy == true`.
* `Energetic` -> `Idle`: her iki Bool false.
* Her normal durumdan `Celebrate`: `celebrate` trigger.
* `Celebrate` -> `Idle` veya uygun mutluluk durumu: animasyon bittikten sonra;
  exit time %100 ve 120-180ms blend. 1 kez oynayan `Celebrate` kilitli kalmamali.

Rive'in **Data Binding** ozelligi bugunku yeni projeler icin tavsiye edilir.
Mevcut Flutter `buddy_mascot.dart` kodumuz ise `stateMachine.boolean/trigger`
yoluyla baglaniyor (deprecated uyumluluk). Bu asamada oncelikle uyumlu
`happy`, `energetic`, `celebrate` inputlarini test ediyoruz. Daha sonra
Data Binding'e gecip Flutter tarafini birlikte yenileyebiliriz.

State Machine ismini `BuddyMachine`, artboard ismini `Buddy` olarak tut.
State machine dosyanin varsayilan state machine'i olmali.

## 5. Final `.riv` dosyasini Flutter'a koy

```powershell
Copy-Item `
  .\design\rive\nutri_buddy\build\nutri_buddy.riv `
  .\assets\rive\nutri_buddy.riv -Force
flutter pub get
flutter analyze
flutter test
flutter run -d emulator-5554 --dart-define-from-file=.env.dev.json
```

Uygulama `assets/rive/nutri_buddy.riv` bulundugunda native Rive oynaticisini
yukler. Dosya gercek Rive binary formatinda degilse animasyonlu Flutter
fallback gorunur; `.svg`/`.png` dosyasinin adini `.riv` yapma.

## 6. Kabul testleri

1. Karakter gorunuyor, Idle hafif nefes/ziplama animasyonu oynuyor.
2. Gunluk su ya da ogun kaydi varsa Happy hareketi.
3. Hem su hem ogun varsa Energetic hareketi.
4. Karaktere dokununca Celebrate animasyonu oynuyor, sonra Idle/mood durumuna donuyor.
5. Magazadaki leaf hat / gozluk / atki Flutter overlay olarak gorunuyor.
6. Ekrandan cikip girince animasyon oynuyor; cihazda takilmiyor.
7. `flutter analyze` temiz, `flutter test` tum testler basarili.

Tumu dogrulanana dek Adim 8'in Rive kismi **tamamlandi** sayilmamali.
