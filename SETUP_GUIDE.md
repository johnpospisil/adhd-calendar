# ADHD Calendar — Complete Setup Guide

This guide walks you through everything you need to run ADHD Calendar on a simulator or your personal iPhone. No prior iOS development experience required.

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Clone and Open the Project](#2-clone-and-open-the-project)
3. [Xcode Interface Tour](#3-xcode-interface-tour)
4. [Running in the Simulator](#4-running-in-the-simulator)
5. [Running on Your iPhone](#5-running-on-your-iphone)
6. [Project Structure Tour](#6-project-structure-tour)
7. [Common Gotchas](#7-common-gotchas)
8. [Troubleshooting FAQ](#8-troubleshooting-faq)

---

## 1. Prerequisites

### macOS 14 Sonoma or later
- Check: Apple menu → About This Mac
- Xcode 15 requires macOS 14+. If you're on an older macOS, update first via System Settings → Software Update.

### Xcode 15.0 or later
- **Download from the Mac App Store** (search "Xcode") — it's free
- The download is ~8 GB; budget 20–30 minutes
- After install, open Xcode once to accept the license and install additional components
- Check your version: Xcode menu → About Xcode (should say 15.x or later)

### Apple Developer Account
- A **free Apple ID** is sufficient to run the app on a simulator and on your own device (with limitations)
- A **paid Apple Developer account** ($99/year) is needed to distribute the app or use certain capabilities
- Sign in at [developer.apple.com](https://developer.apple.com) or add your Apple ID in Xcode → Settings → Accounts

### Git
- macOS ships with Git. Verify in Terminal: `git --version`
- If missing, install Xcode Command Line Tools: `xcode-select --install`

---

## 2. Clone and Open the Project

### Step 1 — Clone the repository

Open Terminal (Cmd+Space → type "Terminal" → Enter):

```bash
git clone https://github.com/johnpospisil/adhd-calendar.git
cd adhd-calendar
```

### Step 2 — Open in Xcode

```bash
open ADHDCalendar/ADHDCalendar.xcodeproj
```

Xcode will open and index the project (watch the progress bar at the top). This takes 30–60 seconds the first time.

> **Tip:** Never open the `.xcodeproj` by double-clicking in Finder if you have multiple Xcode versions installed — the Terminal command ensures the correct Xcode is used.

---

## 3. Xcode Interface Tour

When the project opens, you'll see four main areas:

```
┌─────────────────────────────────────────────────────────┐
│  Toolbar (top)                                          │
│  [▶ Run] [◼ Stop]  [Scheme selector]  [Device picker]  │
├──────────┬──────────────────────────┬───────────────────┤
│ Navigator│     Editor Area          │  Inspector Panel  │
│ (left)   │     (center)             │  (right)          │
│          │                          │                   │
│ File tree│  Your Swift code         │  Attributes for   │
│ Search   │  SwiftUI preview         │  selected item    │
│ Issues   │                          │                   │
├──────────┴──────────────────────────┴───────────────────┤
│  Debug Area (bottom) — console output, variables        │
└─────────────────────────────────────────────────────────┘
```

### Navigator Panel (left sidebar)
- **File Navigator** (folder icon): Browse the project file tree
- **Search Navigator** (magnifying glass): Search across all files
- **Issue Navigator** (warning triangle): See all build errors and warnings
- **Debug Navigator** (bug icon): CPU/memory usage while running

### Editor Area (center)
- Click any `.swift` file to open it
- Split the editor: Editor menu → Split Right

### Canvas / Preview
- SwiftUI files show a **Canvas** on the right
- Click the **Play button** on the canvas to see a live preview
- If the canvas doesn't appear: Editor menu → Canvas

### Inspector Panel (right sidebar)
- **File Inspector** (document icon): File settings
- **Attributes Inspector** (sliders icon): Visual properties for UI elements

### Toolbar
- **Run button (▶)**: Build and run the app
- **Stop button (◼)**: Stop the running app
- **Scheme selector**: Choose which target to build (ADHDCalendar / Tests)
- **Device picker**: Choose simulator or connected device

---

## 4. Running in the Simulator

### Step 1 — Select a simulator

In the Xcode toolbar, click the device picker (it will say something like "iPhone 15 Pro" or "Any iOS Device").

Select a device from the list, e.g.:
- iPhone 15 Pro (recommended for development)
- iPhone SE (3rd generation) (smallest screen — good for testing layouts)

### Step 2 — Build and Run

Press **Cmd+R** (or click the ▶ button).

Xcode will:
1. Compile all Swift files (~10–30 seconds first time)
2. Launch the iOS Simulator
3. Install and open the app

### Step 3 — Grant Calendar Permissions in the Simulator

The first time the app tries to access your calendar, iOS will show a permission dialog. Tap **Allow Full Access**.

If you accidentally tapped "Don't Allow":
1. In the Simulator menu bar: Features → Home
2. Open the **Settings** app
3. Scroll to **Privacy & Security** → **Calendars**
4. Find **ADHDCalendar** and set it to **Full Access**

### Simulator Tips
- **Rotate**: Cmd+Left / Cmd+Right arrow
- **Home button**: Cmd+Shift+H
- **Screenshot**: Cmd+S (saves to Desktop)
- **Reset all content**: Simulator menu → Device → Erase All Content and Settings

---

## 5. Running on Your iPhone

### Step 1 — Connect your iPhone via USB

Use a Lightning or USB-C cable. On your iPhone, tap **Trust** when prompted.

### Step 2 — Select your device in Xcode

In the Xcode toolbar, click the device picker. Your iPhone should appear (e.g., "John's iPhone"). Select it.

### Step 3 — Set your signing team

1. In the Navigator, click on **ADHDCalendar** (the blue project icon at the very top)
2. Select the **ADHDCalendar** target (not the project)
3. Click the **Signing & Capabilities** tab
4. Under **Team**, select your Apple ID from the dropdown
   - If your Apple ID isn't there: Xcode → Settings → Accounts → + → Apple ID
5. The Bundle Identifier must be unique — change `com.johnpospisil.ADHDCalendar` to something like `com.yourname.ADHDCalendar`

### Step 4 — Enable Developer Mode on your iPhone (iOS 16+)

1. On your iPhone: Settings → Privacy & Security → Developer Mode
2. Toggle **Developer Mode** on
3. Your iPhone will restart
4. After restart, tap **Turn On** in the confirmation dialog

### Step 5 — Trust the certificate on your iPhone

After the first build succeeds:
1. On your iPhone: Settings → General → VPN & Device Management
2. Under **Developer App**, tap your Apple ID
3. Tap **Trust "[your Apple ID]"**
4. Tap **Trust** again in the confirmation dialog

### Step 6 — Run the app

Press **Cmd+R**. The app will appear on your iPhone's home screen.

> **Free account limitation:** Apps signed with a free account expire after 7 days. You'll need to re-run from Xcode to reinstall.

---

## 6. Project Structure Tour

```
ADHDCalendar/
├── ADHDCalendar.xcodeproj/       ← Xcode project definition
│   └── project.pbxproj           ← File references & build settings (don't hand-edit)
│
└── ADHDCalendar/                 ← All app source code
    ├── ADHDCalendarApp.swift     ← App entry point (@main)
    ├── Info.plist                ← Permission descriptions, app metadata
    ├── Assets.xcassets/          ← App icon, accent color, image assets
    │
    ├── Models/                   ← Pure Swift data types (no UI)
    │   ├── ADHDCategory.swift    ← Enum of 10 ADHD-aware categories with colors & icons
    │   ├── CalendarEvent.swift   ← Event model with energyCost & transitionBuffer
    │   └── CalendarDay.swift     ← Day wrapper with density calculation
    │
    ├── Services/                 ← Business logic & external integrations
    │   ├── EventKitService.swift ← Reads/writes Apple Calendar via EventKit framework
    │   └── CategoryService.swift ← Default energy & buffer values per category
    │
    ├── ViewModels/               ← @Observable classes that Views bind to
    │   ├── CalendarViewModel.swift      ← Selected date, events, month navigation
    │   └── EventDetailViewModel.swift   ← Single event view/edit state
    │
    ├── Views/                    ← SwiftUI views (everything you see on screen)
    │   ├── ContentView.swift     ← Root TabView (Today / Month / Add)
    │   ├── Calendar/
    │   │   ├── MonthView.swift   ← Month grid with colored event dots
    │   │   ├── DayView.swift     ← Hourly timeline with time blocks
    │   │   └── WeekStripView.swift ← 7-day horizontal strip
    │   ├── Events/
    │   │   ├── EventCard.swift       ← Card shown in lists
    │   │   ├── EventDetailView.swift ← Full detail sheet
    │   │   └── EventEditView.swift   ← Create/edit form
    │   └── Components/
    │       ├── ADHDColorPalette.swift ← Central color constants
    │       ├── TimeBlockView.swift    ← Colored block in DayView timeline
    │       └── CategoryBadge.swift   ← Pill chip with category icon
    │
    └── Utilities/
        ├── DateExtensions.swift  ← startOfDay, endOfMonth, isToday, displayTime, etc.
        └── ColorExtensions.swift ← Color(hex:) init + all ADHD palette colors
```

---

## 7. Common Gotchas

### Clean Build Folder
If you see strange build errors after changing files:
- **Cmd+Shift+K** (Product → Clean Build Folder)
- Then **Cmd+R** to rebuild

### Delete DerivedData
For persistent issues, nuke the build cache:
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData
```
Then rebuild in Xcode.

### Reset Simulator
If the simulator is misbehaving:
- Simulator menu → Device → Erase All Content and Settings
- Or: `xcrun simctl erase all` in Terminal

### Simulator doesn't appear in device picker
- Xcode → Settings → Platforms → iOS → ensure iOS 17 simulator is installed

### "No such module 'EventKit'" error
- Click on the project → ADHDCalendar target → Build Phases → Link Binary With Libraries
- Ensure **EventKit.framework** is listed

### Preview crashes
- Xcode menu → Editor → Canvas → Refresh Canvas (Cmd+Option+P)
- Or close and reopen the file

### Code signing errors
- Ensure a Team is selected in Signing & Capabilities
- Try: Product → Clean Build Folder, then change Bundle ID to something unique

---

## 8. Troubleshooting FAQ

**Q: Xcode says "Swift compiler error: cannot find type X in scope"**
A: This usually means a file is missing from the build target. Click the project → ADHDCalendar target → Build Phases → Compile Sources, and verify all `.swift` files are listed. If a file is missing, drag it from the Navigator into the Compile Sources list.

---

**Q: The calendar permission dialog never appears**
A: Check that `NSCalendarsFullAccessUsageDescription` is in `Info.plist`. In Simulator, you can reset permissions: Settings → General → Transfer or Reset iPhone → Reset → Reset Location & Privacy.

---

**Q: "ADHDCalendar.app" is damaged and can't be opened (on real device)**
A: This happens when the certificate isn't trusted. Go to Settings → General → VPN & Device Management and trust your developer certificate.

---

**Q: The app launches but shows a blank white screen**
A: Check the Xcode console (Debug Area at the bottom) for error messages. A common cause is a missing `@Observable` import or a force-unwrap crash at launch.

---

**Q: SwiftUI preview shows "Preview update failed"**
A: Press **Cmd+Option+P** to refresh. If that fails, restart Xcode. Persistent preview failures sometimes require deleting DerivedData (see section 7).

---

**Q: My changes aren't appearing after I edited a file**
A: Make sure you saved the file (Cmd+S). Xcode doesn't auto-save before building by default. Enable auto-save: Xcode → Settings → General → Autosave.

---

**Q: "No account for team" error when trying to run on device**
A: Go to Xcode → Settings → Accounts and sign in with your Apple ID. Then select that account as the Team in Signing & Capabilities.

---

**Q: The app runs but calendar events don't load**
A: 
1. Check calendar permissions: iOS Settings → Privacy & Security → Calendars → ADHDCalendar
2. In the Simulator, add a test event via the built-in Calendar app first
3. Check the Xcode console for `EventKitError` messages

---

**Q: Build takes forever**
A: On first build, Xcode compiles everything from scratch (~1–3 minutes). Subsequent builds are incremental and much faster. If every build is slow, check if "Whole Module Optimization" is accidentally enabled in Debug mode.

---

*Still stuck? Open an issue on GitHub with your Xcode version, macOS version, and the full error message.*
