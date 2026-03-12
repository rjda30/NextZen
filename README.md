# NextZen — Home Inventory Manager

A beautiful iOS app to track everything in your home: appliances, electronics, furniture, warranties, and maintenance reminders.

## Features
- 📦 **Item Management** — Add, edit, and organize household items by room
- 📷 **Barcode Scanner** — Real AVFoundation camera scanner (EAN-13, QR, Code128, UPC-E, and more)
- 🔔 **Maintenance Alerts** — Scheduled reminders for warranties, filters, and upkeep
- 🏠 **Room Organization** — Visually organize items by room with custom icons
- ☁️ **Supabase Sync** — Cloud-backed data with anonymous + email auth
- 📲 **iCloud KV Sync** — Preferences synced across user's devices via NSUbiquitousKeyValueStore
- 💳 **RevenueCat Paywall** — Monthly & yearly Premium subscription
- 🔍 **Search** — Full-text search across all items

## Tech Stack
- SwiftUI + iOS 17+
- [Supabase Swift SDK](https://github.com/supabase/supabase-swift) — Auth + database
- [RevenueCat iOS SDK](https://github.com/RevenueCat/purchases-ios) — In-app purchases
- AVFoundation — Native barcode scanning
- NSUbiquitousKeyValueStore — iCloud preference sync
- XcodeGen — Project file generation

## Setup

### 1. Clone the repo
```bash
git clone https://github.com/YOUR_USERNAME/nextzen-ios.git
cd nextzen-ios
```

### 2. Install XcodeGen (if not already)
```bash
brew install xcodegen
xcodegen generate
```

### 3. Configure API Keys

**Supabase** — Already configured in `NextZen/Services/SupabaseClient.swift`

**RevenueCat** — Replace the placeholder in `NextZen/App/NextZenApp.swift`:
```swift
private let revenueCatAPIKey = "appl_REPLACE_WITH_YOUR_REVENUECAT_KEY"
```
Get your key at [app.revenuecat.com](https://app.revenuecat.com)

### 4. Configure RevenueCat Products
Create the following products in RevenueCat and App Store Connect:
- `nextzen_premium_monthly` — $4.99/month
- `nextzen_premium_yearly` — $29.99/year (7-day free trial)

### 5. Enable iCloud in Xcode
Open the project → Target → Signing & Capabilities → Add **iCloud** capability → enable **CloudKit** and **Key-value storage**

### 6. Run
Open `NextZen.xcodeproj` and run on a device or simulator.

## Supabase Schema
Tables: `rooms`, `items`, `reminders`, `user_profiles`
All protected with Row Level Security (RLS) tied to `auth.uid()`.

## App Store Checklist
- [ ] Replace RevenueCat API key
- [ ] Create App Store Connect products matching product IDs above
- [ ] Enable iCloud capability with your Team ID
- [ ] Add NSCameraUsageDescription (already in project.yml)
- [ ] Set MARKETING_VERSION to 1.0.0 before release
- [ ] Add App Store screenshots (6.5" and 5.5")

## License
MIT
