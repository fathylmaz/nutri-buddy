# NutriBuddy — Adım 8 Buddy widget testi düzeltmesi

## Düzeltme kapsamı
- `test/buddy/buddy_page_test.dart`: Lazy `ListView` içinde ekran dışında kalan `buddy-shop` butonunu `scrollUntilVisible` ile görünür alana kaydırır; yalnızca bir test güncellenir.
- `lib/features/buddy/presentation/widgets/buddy_mascot.dart`: Gerçek `.riv` dosyası henüz ekli olmadığından kullanılan üç eski Rive state machine input çağrısına geçici, satır düzeyinde `deprecated_member_use` istisnası ekler. Çalışma davranışı değişmez; özgün Rive dosyası eklenirken Data Binding'e geçirilecektir.

## Windows PowerShell

```powershell
cd C:\dev\projects\nutri_buddy

# İsteğe bağlı mevcut dosyaların yedeği
Copy-Item test\buddy\buddy_page_test.dart test\buddy\buddy_page_test.dart.bak
Copy-Item lib\features\buddy\presentation\widgets\buddy_mascot.dart lib\features\buddy\presentation\widgets\buddy_mascot.dart.bak

Expand-Archive `
  -Path "$HOME\Downloads\nutri_buddy_step8_test_fix.zip" `
  -DestinationPath "C:\dev\projects\nutri_buddy" `
  -Force

dart fix --apply --code=curly_braces_in_flow_control_structures
dart format lib test
flutter analyze
flutter test test/buddy/buddy_page_test.dart
flutter test
```

## Beklenen
`flutter analyze` → `No issues found!` ve `flutter test` → `All tests passed!`.

Kod üretimi (`build_runner`) bu yamada gerekmiyor. Uygulamayı veya veritabanını silmeyin.

Not: Yamanın dosya yapısı ve sözdizimsel düzenlemesi incelendi. Flutter SDK bu ortamda çalıştırılamadığı için test sonucu bilgisayarınızda doğrulanmalıdır.
