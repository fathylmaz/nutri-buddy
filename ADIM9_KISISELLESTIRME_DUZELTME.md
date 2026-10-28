# NutriBuddy — Adım 9: Kişiselleştirilmiş yanıt düzeltmesi

## Hatanın açıklaması

AI diyetisyen sohbeti ve 8/8 pgvector indeksi çalışıyor. Uygulamada «Bugünün sayısal kalori, makro ve su özetini de paylaş» seçili olduğu halde Gemini günlük sayıları anmadan genel beslenme tavsiyesi verebiliyordu.

Bu paket SADECE `supabase/functions/dietitian-chat/index.ts` dosyasını değiştirir. Önceki embedding (768 boyut) ve kullanıcı JWT düzeltmeleri korunmuştur. Veritabanı, Flutter, Rive, diğer Edge Functions veya kişisel kayıtlarda değişiklik yoktur.

## Windows kurulumu

1. VS Code / PowerShell:

```powershell
cd C:\dev\projects\nutri_buddy
Copy-Item ".\supabase\functions\dietitian-chat\index.ts" ".\supabase\functions\dietitian-chat\index.before_daily_fix.ts" -Force
Expand-Archive -Path "$HOME\Downloads\nutri_buddy_step9_personalization_fix.zip" -DestinationPath "C:\dev\projects\nutri_buddy" -Force
```

2. Supabase Dashboard → Edge Functions → `dietitian-chat` → **Code**. Güncel `supabase/functions/dietitian-chat/index.ts` dosyasını **tamamen** editöre kopyalayıp **Deploy updates** seç. Kullanıcı kimlik doğrulama (JWT) ayarını değiştirme.

3. `index-dietitian-knowledge` fonksiyonuna veya 8/8 embedding verisine dokunma. Flutter kodu değiştirilmediğinden Android uygulamasını yeniden derlemene gerek yok.

## Tekrarlama testi

- Yeni sohbet A: Günlük veri paylaşımı **kapalı** olsun. «Bugünkü beslenme ve su tüketimimi değerlendirebilir misin?» sor. Yanıt günlük sayısal değerlere sahipmiş gibi davranmamalı.
- Yeni sohbet B: Günlük veri paylaşımı **açık** olsun. Aynı soruyu sor. Yanıt başında `Paylaşılan uygulama kayıtları (YYYY-MM-DD): ...` başlığı ve seçtiğin günün kayıtlarından kalori, protein, karbonhidrat, yağ, su, öğün sayısı ve kalori hedefini göstermeli. Bunları Dashboard ile karşılaştır.
- Eğer 0 öğün / 0 su görünüyorsa, önce Dashboard'da o gün kayıt bulunup bulunmadığını kontrol et. 0, hiç tüketim olmadığını değil, kayıt olmadığını gösterebilir.
- Yanıt hâlâ tamamen genel kalırsa Supabase → Edge Functions → `dietitian-chat` → Invocations bölümünde son çağrının HTTP durumunu kontrol et ve güncel fonksiyonun gerçekten deploy edildiğini doğrula.

## Gizlilik ve sınırlar

Günlük değerler yalnızca kullanıcının paylaşım seçeneği açık olduğunda istekle gider. Bu veri uygulama kayıtlarından gelir, klinik olarak doğrulanmış ölçüm değildir. Kullanıcıyı kimliklendiren veya hassas sağlık profili alanları eklenmez. Modelin ürettiği bölüm kanıta dayalı genel kaynak kullanımını sürdürür; sayı özeti modelden bağımsız olarak yerleştirilir. Günlük sayılar bulut sohbet geçmişinde de saklanacağından paylaşım açıkken bunun farkında olun.
