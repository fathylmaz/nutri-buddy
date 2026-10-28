# NutriBuddy Rive CLI 1.7.0 — RML düzeltmesi

Hata: `scene.rml:115:1 [rml] AnimationState has no property "name"`.

`AnimationState` öğesindeki `name="Idle"` kaldırıldı. Gerçek `LinearAnimation` adı ve dört animasyonun tamamı korundu.

## Kurulum

PowerShell:

```powershell
cd C:\dev\projects\nutri_buddy
Copy-Item .\design\rive\nutri_buddy\scene.rml .\scene.before_rive_fix.rml.bak
Expand-Archive -Path "$HOME\Downloads\nutri_buddy_step8_rive_rml_fix.zip" -DestinationPath "C:\dev\projects\nutri_buddy" -Force
rive .\design\rive\nutri_buddy --verify
```

Yedeği Rive proje klasörünün dışında ve `.bak` uzantısıyla tutuyoruz; CLI'nın ikinci bir sahne gibi okumasını engelliyoruz.

Başarılıysa:

```powershell
rive .\design\rive\nutri_buddy --once
```

CLI'den yeni hata gelirse tam çıktısını paylaş. Paket yalnızca RML tanımı düzeltir, `.riv` dosyası içermez. RML XML yapısı ve animasyon referansları kontrol edildi; Rive CLI ikili dosyası bu çalışma ortamında olmadığından gerçek derleme burada çalıştırılamadı.
