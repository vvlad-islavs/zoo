## Android upload keystore

Создать upload keystore и прописать его в `android/key.properties`.

### 1) Создать keystore

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Положить `upload-keystore.jks` в папку `keystore/`.

### 2) Создать `android/key.properties`

Скопировать `android/key.properties.example` → `android/key.properties` и заполнить:

- `storeFile=../keystore/upload-keystore.jks`
- пароли/alias

### 3) Сборка для Google Play

```bash
flutter build appbundle --release
```

AAB будет в `build/app/outputs/bundle/release/app-release.aab`.

