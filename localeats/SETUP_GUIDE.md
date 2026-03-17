# LocalEats - Flutter App Setup Guide
## Pundra University CSE 3102 Project

---

## 📋 Prerequisites

1. **Flutter SDK** — Install from https://flutter.dev/docs/get-started/install
2. **Android Studio** — For Android emulator + build tools
3. **VS Code** (optional but recommended) with Flutter extension
4. **Firebase Account** — https://console.firebase.google.com

---

## 🔥 Step 1: Firebase Setup

1. Go to https://console.firebase.google.com
2. Click **"Add Project"** → Name it `localeats`
3. Enable **Google Analytics** (optional) → Create project

### Enable these services:
- **Authentication**: Build → Authentication → Get Started → Enable Email/Password
- **Firestore**: Build → Firestore Database → Create database → Start in test mode
- **Storage**: Build → Storage → Get started

### Add Android App:
1. Click **Android icon** (Add app)
2. Package name: `com.localeats.app`
3. Download `google-services.json`
4. Place it in: `localeats/android/app/google-services.json`

---

## 📦 Step 2: Install Dependencies

```bash
cd localeats
flutter pub get
```

---

## 🏃 Step 3: Run the App

```bash
# Check connected devices
flutter devices

# Run on emulator or device
flutter run
```

---

## 📱 Step 4: Build APK

```bash
# Debug APK (for testing)
flutter build apk --debug

# Release APK (for submission)
flutter build apk --release
```

APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🌱 Step 5: Add Sample Data to Firestore

Go to Firebase Console → Firestore → Add collection `vendors`:

```
Document ID: vendor1
Fields:
  name: "Mama's Kitchen"
  cuisine: "Home Chef"
  rating: 4.8
  reviewCount: 127
  distance: 0.8
  minDelivery: 15
  maxDelivery: 25
  commission: 10
  deliveryFee: 40
  menu: [array of menu items]
```

---

## 📁 Project Structure

```
localeats/
├── lib/
│   ├── main.dart              ← App entry point
│   ├── screens/
│   │   ├── splash_screen.dart     ← Screen 1
│   │   ├── login_screen.dart      ← Screen 2
│   │   ├── register_screen.dart   ← Screen 2b
│   │   ├── home_screen.dart       ← Screen 3
│   │   ├── vendor_profile_screen.dart  ← Screen 4+5
│   │   ├── cart_screen.dart       ← Screen 6
│   │   ├── order_tracking_screen.dart  ← Screen 7
│   │   └── profile_screen.dart    ← Screen 8
│   ├── models/
│   │   ├── vendor_model.dart
│   │   └── order_model.dart
│   ├── services/
│   │   ├── auth_service.dart      ← Firebase Auth
│   │   ├── cart_service.dart      ← Cart state
│   │   └── firestore_service.dart ← Firestore
│   └── utils/
│       └── app_colors.dart        ← Color constants
├── pubspec.yaml               ← Dependencies
└── android/app/
    └── google-services.json   ← Firebase config (YOU ADD THIS)
```

---

## ✅ Features Implemented

| Feature | Status |
|---------|--------|
| Splash Screen with animation | ✅ |
| Login with Email/Password | ✅ |
| Register new account | ✅ |
| Home Dashboard | ✅ |
| Category filter | ✅ |
| Vendor cards with ratings | ✅ |
| Vendor Profile with menu | ✅ |
| Add to Cart | ✅ |
| Cart with quantity controls | ✅ |
| Coupon code (LOCALEATS10) | ✅ |
| Order summary & total | ✅ |
| Place Order | ✅ |
| Order Tracking with animation | ✅ |
| Rider info display | ✅ |
| User Profile | ✅ |
| Sign Out | ✅ |
| Firebase Authentication | ✅ |
| Firestore integration | ✅ |

---

## 🎨 Design System

| Element | Value |
|---------|-------|
| Primary Color | #2E8B57 (Community Green) |
| Secondary Color | #FF7F50 (Warm Orange) |
| Background | #F8F9FA |
| Font | Poppins (Google Fonts) |

---

## 🆘 Common Issues

**Problem**: `google-services.json not found`
**Fix**: Download from Firebase Console and place in `android/app/`

**Problem**: `flutter pub get` fails
**Fix**: Run `flutter clean` then `flutter pub get`

**Problem**: Build fails with SDK error
**Fix**: Run `flutter doctor` and fix any issues shown

---

## 📞 Coupon Code for Testing
Use: **LOCALEATS10** for 10% discount in cart

