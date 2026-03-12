# 🧠 ADHD Calendar

[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![iOS 17+](https://img.shields.io/badge/iOS-17%2B-blue.svg)](https://developer.apple.com/ios/)
[![Swift 5.9](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-purple.svg)](https://developer.apple.com/swiftui/)

> **A calmer way to manage your schedule** — built specifically for ADHD and AuDHD brains.

---

## What is ADHD Calendar?

ADHD Calendar is an iOS app that reimagines how people with ADHD and AuDHD experience time. Instead of overwhelming grids and tiny text, it offers:

- 🎨 **Sensory-friendly colors** — muted, non-overwhelming palette that adapts to light and dark mode
- ⚡ **Energy cost tracking** — rate each event 1–5 so you can see at a glance how demanding your day is
- ⏱️ **Transition buffers** — automatic reminder padding between events so you're never caught off-guard
- 🏷️ **ADHD-aware categories** — Self Care, Work, Social, Health, Creative, Rest, and more
- 📅 **Multiple views** — Day timeline, Month grid, and Week strip so you always have context
- 🔄 **EventKit integration** — syncs with your existing Apple Calendar

---

## Phase Roadmap

| Phase | Focus | Status |
|-------|-------|--------|
| **Phase 1** | Foundation — models, views, EventKit sync, ADHD categories, energy tracking | ✅ In Progress |
| **Phase 2** | Notifications & Reminders — smart transition alerts, hyperfocus warnings, gentle nudges | 🔜 Planned |
| **Phase 3** | Widgets & Watch — Home Screen widgets, Apple Watch glance, Lock Screen complications | 🔜 Planned |
| **Phase 4** | AI Scheduling — suggest low-energy tasks when tired, protect recovery time | 🔜 Planned |
| **Phase 5** | Accessibility & Polish — VoiceOver, Dynamic Type, haptic feedback, App Store release | 🔜 Planned |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Language | Swift 5.9 |
| UI Framework | SwiftUI |
| Architecture | MVVM + `@Observable` (iOS 17) |
| Calendar Sync | EventKit |
| Minimum iOS | 17.0 |
| Xcode | 15.0+ |

---

## Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/johnpospisil/adhd-calendar.git
cd adhd-calendar

# 2. Open the Xcode project
open ADHDCalendar/ADHDCalendar.xcodeproj

# 3. Select a simulator or device, then press Cmd+R
```

For a full walkthrough including device setup, signing, and troubleshooting, see [SETUP_GUIDE.md](SETUP_GUIDE.md).

---

## Project Structure

```
ADHDCalendar/
├── ADHDCalendar.xcodeproj/   # Xcode project file
├── ADHDCalendar/             # Main app source
│   ├── Models/               # CalendarEvent, CalendarDay, ADHDCategory
│   ├── Services/             # EventKitService, CategoryService
│   ├── ViewModels/           # CalendarViewModel, EventDetailViewModel
│   ├── Views/                # SwiftUI views (Calendar, Events, Components)
│   └── Utilities/            # Date & Color extensions
├── ADHDCalendarTests/        # Unit tests (XCTest)
└── ADHDCalendarUITests/      # UI tests (XCUITest)
```

---

## License

MIT © John Pospisil. See [LICENSE](LICENSE) for details.

This project is open source and contributions are welcome. If you have ADHD/AuDHD and want to shape the roadmap, please open an issue!
