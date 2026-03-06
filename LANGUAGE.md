# Language Configuration

## Default Language: English 🇬🇧

The IceBath app is now configured with **English as the default language**.

## How It Works

Garmin Connect IQ uses a hierarchical language system:

1. **Default Language** (`resources/strings.xml`)
   - English strings
   - Used when device language is not Turkish
   - Fallback for any missing translations

2. **Turkish Language** (`resources/strings-tur/strings.xml`)
   - Turkish strings
   - Automatically used when device language is set to Turkish

## File Structure

```
resources/
├── strings.xml              # English (Default)
├── strings-tur/
│   └── strings.xml          # Turkish
├── settings.xml
└── layouts.xml
```

## Changing Device Language

Users can change their Garmin device language in:
- **Settings** → **System** → **Language**

The app will automatically display in the appropriate language based on the device setting.

## Adding New Languages

To add support for additional languages:

1. Create a new directory: `resources/strings-{lang-code}/`
2. Add `strings.xml` with translated strings
3. Update `manifest.xml` to include the new language

### Language Codes
- `eng` - English (default)
- `tur` - Turkish
- `spa` - Spanish
- `deu` - German
- `fra` - French
- `ita` - Italian
- `por` - Portuguese
- `rus` - Russian
- `jpn` - Japanese
- `kor` - Korean

## Current Translations

### ✅ Fully Translated
- 🇬🇧 English (Default)
- 🇹🇷 Turkish

### 📝 Available for Translation
All UI strings are ready to be translated into additional languages. See `resources/strings.xml` for the complete list of string IDs.
