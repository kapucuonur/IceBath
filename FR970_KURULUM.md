# IceBath - Garmin Forerunner 970 Kurulum Rehberi 🏃‍♂️❄️

## ✅ Artık Resmi Olarak Destekleniyor!

FR970 artık SDK 5.2.0 güncellemesi ile **resmi olarak desteklenmektedir**!

### 📦 Kullanılacak Dosya

```
📁 Konum: bin/IceBath.prg
📊 Boyut: ~373 KB
🎯 Hedef: Tüm desteklenen cihazlar (FR970 dahil)
```

---

## Adım Adım Kurulum

### 1️⃣ Saati Bilgisayara Bağlayın

- USB kablosu ile FR970'i Mac'e bağlayın
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

> **NOT**: Artık özel build dosyası gerekmez, standart `IceBath.prg` dosyasını kullanabilirsiniz.

### 3️⃣ Saati Güvenli Çıkarın

- Finder'da GARMIN diskine sağ tıklayın
- "Eject" seçin
- USB kablosunu çıkarın

### 4️⃣ Saati Yeniden Başlatın

- FR970'de **LIGHT** tuşuna 15 saniye basılı tutun
- "Power Off" seçin
- Tekrar açın

### 5️⃣ Uygulamayı Bulun

1. Saat ana ekranında **UP/DOWN** tuşları ile menüde gezinin
2. **Apps** bölümüne girin
3. **IceBath** ❄️ uygulamasını bulun ve açın

---

## Terminal ile Hızlı Kopyalama

Eğer terminal kullanmayı tercih ederseniz:

```bash
# GARMIN diski bağlı olduğunda
cp /Users/onurkapucu/Documents/IceBath/bin/IceBath.prg /Volumes/GARMIN/GARMIN/APPS/IceBath.prg
```

---

## Sorun Giderme

### ❌ Uygulama Hala Görünmüyor

**Kontrol Listesi:**

- [ ] Dosya `GARMIN/APPS/` klasöründe mi? (APPS klasörü büyük harfle)
- [ ] Dosya adı `IceBath.prg` mi? (test_fr970_ öneki kaldırıldı mı?)
- [ ] Saati yeniden başlattınız mı?
- [ ] FR970 firmware güncel mi? (Garmin Express ile kontrol edin)

### 🔧 Alternatif: Yeni Build Oluşturma

Eğer mevcut dosya çalışmazsa:

1. VS Code'da projeyi açın
2. `Cmd + Shift + P` tuşlarına basın
3. "Monkey C: Build for Device" yazın
4. **Forerunner 970** seçin
5. Yeni oluşan `bin/IceBath.prg` dosyasını kopyalayın

### 🧪 Simulator'da Test

Önce bilgisayarda test edin:

1. VS Code'da `Cmd + Shift + P`
2. "Monkey C: Run" yazın
3. **Forerunner 970** seçin
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

## Yardım Gerekli mi?

Sorun devam ederse:

1. **Firmware Güncellemesi**
   - Garmin Express'i açın
   - FR970'i bağlayın
   - Güncellemeleri kontrol edin

2. **Developer Mode**
   - Saat: Ayarlar → System → About
   - Software Version'a 5 kez dokunun
   - Developer Mode aktif olmalı

3. **Destek**
   - GitHub Issues: [Sorun bildirin](https://github.com/yourusername/icebath/issues)
   - README: [Detaylı dokümantasyon](README_TR.md)

---

**Güvenli ve etkili soğuk su deneyimi için! ❄️🏊‍♂️**
