# IceBath ❄️ - Garmin Connect IQ App

**Kış yüzme ve soğuk su banyosu aktiviteleri için profesyonel Garmin uygulaması**

![IceBath Hero](assets/app_banner.png)

![Garmin Connect IQ](https://img.shields.io/badge/Garmin-Connect%20IQ-00A0E3?style=flat-square&logo=garmin)
![Version](https://img.shields.io/badge/version-1.0.0-blue?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)

## 🌊 Özellikler

### Temel Metrikler
- ⏱️ **Süre Takibi** - Gerçek zamanlı aktivite süresi
- ❤️ **Kalp Atışı** - Anlık nabız monitörü
- 🌡️ **Vücut Sıcaklığı** - Hipotermi riski takibi
- 🔥 **Kalori** - Soğuk maruziyeti için artırılmış hesaplama (+40%)
- 📍 **GPS Konum** - Suya girdiğiniz yeri kaydeder

### Gelişmiş Metrikler
- 📊 **HRV** - Kalp atış hızı değişkenliği
- 🫁 **Solunum Hızı** - Nefes kontrolü
- 💪 **Stres Seviyesi** - Garmin stres skoru
- ⚡ **Body Battery** - Enerji seviyesi

### Güvenlik Özellikleri
- ⚠️ **Akıllı Uyarılar** - Kritik değerlerde sesli ve titreşimli alarm
- 🎯 **Hedef Süre** - Özelleştirilebilir zamanlayıcı
- 🔔 **Çoklu Eşik Kontrolü** - Kalp atışı ve sıcaklık limitleri
- 🚨 **Acil Durum Uyarıları** - Hipotermi ve bradikardi tespiti

## 📱 Desteklenen Cihazlar

**66+ Garmin Cihaz Destekleniyor!**

**D2 Havacılık Serisi:**
- D2 Air / Air X10 / Mach 1

**Edge Bisiklet Serisi:**
- Edge 540 / 840 / 1040

**Enduro Serisi:**
- Enduro / Enduro 2 / Enduro 3

**Epix Serisi:**
- Epix 2 / Epix 2 Pro (42mm / 47mm / 51mm)

**Fenix Serisi:**
- Fenix 5 / 5S / 5X (Plus varyantları)
- Fenix 6 / 6S / 6X Pro
- Fenix 7 / 7S / 7X (Pro varyantları)
- Fenix 8 (43mm / 47mm / 51mm)
- Fenix E

**Forerunner Serisi:**
- FR 165 / 165M
- FR 255 / 255M / 255S / 255SM
- FR 265 / 265S
- FR 955 / 965 / 970

**MARQ Lüks Serisi:**
- MARQ 2 / MARQ 2 Aviator

**Venu Serisi:**
- Venu / Venu 2 / 2 Plus / 2S
- Venu 3 / 3S
- Venu Sq / Sq 2 / Sq 2 Music

**Vivoactive Serisi:**
- Vivoactive 3 / 3 Music / 3 LTE
- Vivoactive 4 / 4S / 5

*Not: Vücut sıcaklığı sensörü olan tüm Garmin cihazlar desteklenir. Toplam: 66+ model.*

## 🚀 Kurulum

### Gereksinimler
- Java Runtime Environment (JRE) 1.8+
- Visual Studio Code
- Garmin Connect IQ SDK Manager

### Adımlar

1. **SDK Manager'ı İndirin**
   ```bash
   # developer.garmin.com/connect-iq/sdk adresinden indirin
   # SDK Manager'ı açın ve SDK'yı yükleyin
   ```

2. **VS Code Extension'ı Kurun**
   - VS Code'u açın
   - Extensions → "Monkey C" araması yapın
   - Garmin'in resmi extension'ını yükleyin

3. **Projeyi Klonlayın**
   ```bash
   git clone https://github.com/yourusername/icebath.git
   cd icebath
   ```

4. **Developer Key Oluşturun**
   - VS Code'da `Cmd + Shift + P`
   - "Monkey C: Generate a Developer Key" seçin
   - Güvenli bir konuma kaydedin

5. **Uygulamayı Derleyin**
   - VS Code'da `Cmd + Shift + P`
   - "Monkey C: Build for Device" seçin

## 🎮 Kullanım

### Aktiviteyi Başlatma
1. Garmin cihazınızda uygulamayı açın
2. **SELECT** tuşuna basarak kaydı başlatın
3. Soğuk suya girin ve metriklerinizi takip edin

### Buton Kontrolleri
- **SELECT** - Kaydı başlat/duraklat
- **BACK** - Menüyü aç (Kaydet/İptal/Devam)
- **MENU** - Ayarlar

### Güvenlik Uyarıları
Uygulama aşağıdaki durumlarda sizi uyaracaktır:
- ❤️ Kalp atışı çok yüksek (>160 bpm)
- 💔 Kalp atışı çok düşük (<40 bpm)
- 🌡️ Vücut sıcaklığı düşük (<35°C)
- ⏰ Hedef süreye ulaşıldı

## ⚙️ Ayarlar

Uygulamayı ihtiyaçlarınıza göre özelleştirin:

| Ayar | Varsayılan | Açıklama |
|------|-----------|----------|
| Hedef Süre | 10 dakika | Maksimum aktivite süresi |
| Maks Nabız | 160 bpm | Yüksek nabız eşiği |
| Min Nabız | 40 bpm | Düşük nabız eşiği |
| Min Vücut Sıc. | 35°C | Hipotermi uyarı eşiği |
| Sıcaklık Birimi | Celsius | °C veya °F |
| Uyarıları Aç | Açık | Sesli/titreşimli uyarılar |

## 🏗️ Proje Yapısı

```
IceBath/
├── manifest.xml              # Uygulama manifest
├── source/
│   ├── IceBathApp.mc        # Ana uygulama sınıfı
│   ├── IceBathView.mc       # UI görünümü
│   ├── IceBathDelegate.mc   # Input yönetimi
│   ├── DataManager.mc       # Sensör veri yönetimi
│   ├── SafetyMonitor.mc     # Güvenlik kontrolleri
│   └── LocationManager.mc   # GPS konum takibi
└── resources/
    ├── strings.xml          # İngilizce stringler
    ├── strings/
    │   └── strings.xml      # Türkçe stringler
    ├── settings.xml         # Kullanıcı ayarları
    └── layouts.xml          # UI layout'ları
```

## 🔬 Teknik Detaylar

### Kalori Hesaplama
Soğuk su maruziyeti vücudun metabolizmasını hızlandırır. Uygulama, standart kalori hesaplamasına %40 artış uygular:

```
Soğuk Su Kalorisi = Standart Kalori × 1.4
```

### Güvenlik Algoritması
Uygulama, çoklu parametreleri sürekli izler:
1. Kalp atışı (yüksek/düşük eşikler)
2. Vücut sıcaklığı (hipotermi riski)
3. Aktivite süresi (aşırı maruziyetten korunma)

## ⚠️ Önemli Uyarılar

> **DİKKAT:** Bu uygulama tıbbi bir cihaz değildir. Soğuk su aktiviteleri ciddi sağlık riskleri taşıyabilir. Kullanıcılar kendi sorumluluklarında hareket etmelidir.

**Güvenlik Önerileri:**
- İlk kez yapıyorsanız bir profesyonelle çalışın
- Asla tek başınıza soğuk suya girmeyin
- Vücudunuzu dinleyin ve sınırlarınızı zorlama yin
- Herhangi bir rahatsızlık hissettiğinizde hemen çıkın
- Kronik hastalığınız varsa doktorunuza danışın

## 🌍 Dil Desteği

- 🇬🇧 **English** (Default)
- 🇹🇷 **Türkçe**

*Uygulama cihazınızın dil ayarına göre otomatik olarak dil seçer.*

## 📄 Lisans

MIT License - Detaylar için [LICENSE](LICENSE) dosyasına bakın.

## 🤝 Katkıda Bulunma

Katkılarınızı bekliyoruz! Pull request göndermekten çekinmeyin.

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit yapın (`git commit -m 'Add amazing feature'`)
4. Push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

## 📧 İletişim

Sorularınız veya önerileriniz için issue açabilirsiniz.

## 🙏 Teşekkürler

- Garmin Connect IQ ekibine SDK için
- Wim Hof metoduna ilham için
- Tüm soğuk su topluluğuna

---

**Güvenli ve etkili soğuk su deneyimi için! ❄️🏊‍♂️**
