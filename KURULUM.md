# IceBath - Garmin Saat Kurulum Rehberi 🏃‍♂️❄️

## ⚠️ ÖNEMLİ: SDK Uyumluluk Bilgisi

Uygulama SDK 5.2.0 ile geliştirilmiştir ve **70+ Garmin cihazı desteklemektedir**.

### ✅ Desteklenen Cihazlar

**D2 Serisi**: D2 Air, D2 Air X10, D2 Mach 1

**Edge Serisi**: Edge 540, 840, 1040, 1050

**Enduro Serisi**: Enduro, Enduro 2, Enduro 3

**Epix Serisi**: Epix 2, Epix 2 Pro (42mm, 47mm, 51mm)

**Fenix Serisi**: 
- Fenix 5, 5S, 5X (Plus varyantları)
- Fenix 6, 6S, 6X Pro
- Fenix 7, 7S, 7X (Pro varyantları)
- Fenix 8 (43mm, 47mm, 51mm)
- Fenix E

**Forerunner Serisi**: FR165, FR165M, FR255, FR255M, FR255S, FR255SM, FR265, FR265S, FR955, **FR965**, **FR970**

**MARQ Serisi**: MARQ 2, MARQ 2 Aviator

**Venu Serisi**: Venu, Venu 2, Venu 2 Plus, Venu 2S, Venu 3, Venu 3S, Venu Sq, Venu Sq 2

**Vivoactive Serisi**: Vivoactive 3, Vivoactive 4, Vivoactive 4S, Vivoactive 5

---

## Adım Adım Kurulum

### 1️⃣ Saati Bilgisayara Bağlayın

- USB kablosu ile saatinizi Mac'e bağlayın
- Saat "USB Depolama" modunda açılmalı
- Finder'da "GARMIN" diski görünmeli

### 2️⃣ Dosyayı Kopyalayın

**Kaynak dosya:**
```
/Users/onurkapucu/Documents/IceBath/bin/IceBath.prg
```

**Hedef konum:**
```
[GARMIN DISK]/GARMIN/APPS/IceBath.prg
```

> [!IMPORTANT]
> Dosya adı **tam olarak** `IceBath.prg` olmalıdır.

### 3️⃣ Terminal ile Hızlı Kopyalama (Opsiyonel)

```bash
# GARMIN diski bağlı olduğunda
cp /Users/onurkapucu/Documents/IceBath/bin/IceBath.prg /Volumes/GARMIN/GARMIN/APPS/IceBath.prg
```

### 4️⃣ Saati Güvenli Çıkarın

- Finder'da GARMIN diskine sağ tıklayın
- "Eject" seçin
- USB kablosunu çıkarın

### 5️⃣ Saati Yeniden Başlatın

- Saatinizde **LIGHT/POWER** tuşuna 15 saniye basılı tutun
- "Power Off" seçin
- Tekrar açın

### 6️⃣ Uygulamayı Bulun

1. Saat ana ekranında **UP/DOWN** tuşları ile menüde gezinin
2. **Apps** veya **Uygulamalar** bölümüne girin
3. **IceBath** ❄️ uygulamasını bulun ve açın

---

## Sorun Giderme

### ❌ Uygulama Hala Görünmüyor

**Kontrol Listesi:**

- [ ] Dosya `GARMIN/APPS/` klasöründe mi? (APPS klasörü büyük harfle)
- [ ] Dosya adı tam olarak `IceBath.prg` mi?
- [ ] Saati yeniden başlattınız mı?
- [ ] Cihazınız desteklenen listede mi? (Yukarıdaki listeye bakın)
- [ ] Firmware güncel mi? (Garmin Express ile kontrol edin)

### 🔧 Yeni Build Oluşturma

Eğer mevcut dosya çalışmazsa veya güncel bir build istiyorsanız:

```bash
cd /Users/onurkapucu/Documents/IceBath
./build_release.sh
```

Bu script otomatik olarak:
- Developer key'i kontrol eder
- Uyumlu cihazlar için build oluşturur
- Çıktı dosyasını `bin/IceBath.prg` olarak kaydeder

### 🧪 Simulator'da Test

Önce bilgisayarda test edin:

1. VS Code'da `Cmd + Shift + P`
2. "Monkey C: Run" yazın
3. Desteklenen bir cihaz seçin (örn: **Forerunner 970**, **Forerunner 965**, **Fenix 7 Pro** veya **Venu 2**)
4. Simulator açılacak

---

## Uygulama Kullanımı

### İlk Açılış

1. **IceBath** uygulamasını açın
2. Ana ekranda metrikler görünecek:
   - ⏱️ Süre
   - ❤️ Kalp Atışı
   - 🌡️ Vücut Sıcaklığı
   - 🔥 Kalori

### Aktivite Başlatma

- **SELECT** tuşuna basın → Kayıt başlar
- **SELECT** tuşuna tekrar basın → Duraklatır
- **BACK** tuşuna basın → Menü açılır (Kaydet/İptal/Devam)

### Güvenlik Uyarıları

Uygulama sizi şu durumlarda uyaracak:
- ❤️ Kalp atışı çok yüksek (>160 bpm)
- 💔 Kalp atışı çok düşük (<40 bpm)
- 🌡️ Vücut sıcaklığı düşük (<35°C)
- ⏰ Hedef süreye ulaşıldı

---

## Ayarlar

Garmin Connect Mobile uygulamasından veya saat ayarlarından:

| Ayar | Varsayılan | Açıklama |
|------|-----------|----------|
| Hedef Süre | 10 dakika | Maksimum aktivite süresi |
| Maks Nabız | 160 bpm | Yüksek nabız eşiği |
| Min Nabız | 40 bpm | Düşük nabız eşiği |
| Min Vücut Sıc. | 35°C | Hipotermi uyarı eşiği |

---

## SDK Bilgisi

> [!NOTE]
> Bu uygulama SDK 5.2.0 ile geliştirilmiştir ve tüm modern Garmin cihazlarını desteklemektedir (FR970, FR965, Fenix 7, Epix 2, vb.).

### Desteklenen Cihaz Sayısı
- **Toplam**: 70+ Garmin cihazı
- **Seriler**: D2, Edge, Enduro, Epix, Fenix, Forerunner, MARQ, Venu, Vivoactive

---

## Yardım Gerekli mi?

Sorun devam ederse:

1. **Firmware Güncellemesi**
   - Garmin Express'i açın
   - Saatinizi bağlayın
   - Güncellemeleri kontrol edin

2. **Developer Mode** (Gerekirse)
   - Saat: Ayarlar → System → About
   - Software Version'a 5 kez dokunun
   - Developer Mode aktif olmalı

3. **Destek**
   - GitHub Issues: [Sorun bildirin](https://github.com/yourusername/icebath/issues)
   - README: [Detaylı dokümantasyon](README_TR.md)

---

**Güvenli ve etkili soğuk su deneyimi için! ❄️🏊‍♂️**
