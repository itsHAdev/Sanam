# Sanam (سنام)

An iOS app that teaches beginners the fundamentals of stocks investing through **interactive lessons** and a **realistic stock market simulation**, letting them practice buying and selling and learn from their own decisions with zero real financial risk. Built entirely in **SwiftUI** using the **MVVM** architecture.

## Overview

Sanam turns learning how to invest into a hands-on experience instead of dry theory:

- **Realistic stock market simulation** — fictional companies with moving prices and stocks; buy and sell and immediately see the effect of your decisions on your portfolio
- **Interactive lessons (gamification)** — instead of traditional explanations, every investing concept is taught through a short game or simulation the user plays through themselves
- **A safe space to experiment** — an entirely virtual balance, so users can "lose" and learn from mistakes without any real loss

Fully Arabic UI (RTL) with Arabic numerals, and full Light/Dark Mode support.

## Key Features

- **Onboarding** — a welcome flow introducing the app on first launch
- **Stock Simulator** — a list of fictional companies, a detail screen per company with a chart (Swift Charts) across multiple timeframes, and a real data table (high/low, trading volume, number of trades...)
- **Buy & Sell** — a full trading bottom sheet with quantity and balance validation
- **Wallet** — a real balance starting at zero, increased by level-completion rewards, and adjusted with every buy/sell
- **Customizable cards & themes** — a settings screen to pick a card design and appearance (light/dark/system)
- **5 interactive learning levels:**
  1. An interactive 3D cube (SceneKit) explaining core investing concepts
  2. A live investment simulation with a real-time chart and a control slider
  3. A "rumor" game — deciding to buy/sell based on market news
  4. A stock-type game (speculative vs. safe stocks)
  5. Portfolio diversification across multiple sectors
- Every level ends with a congratulations screen and a reward automatically added to the wallet

## Tech Stack

| Technology | Usage |
|---|---|
| SwiftUI | The entire UI |
| Combine | Reactive state management (`ObservableObject`) |
| Swift Charts | Stock charts |
| SceneKit | The 3D cube in level 1 |
| AVFoundation | Sound effects |
| Asset Catalog (Colorsets) | A color system fully adaptive to Light/Dark Mode |

## Architecture (MVVM)

```
Sanam/
├── Model/          # Data structures (Company, Stock, Level, PortfolioSector...)
├── ViewModel/       # State and business logic (an ObservableObject per feature)
├── View/
│   ├── Onboarding/  # Welcome flow
│   ├── Simulator/   # Stock simulator, company details, and trading
│   ├── Wallet/      # Wallet, settings, and card themes
│   └── Levels/      # The 5 interactive levels
├── Component/       # Shared UI elements (buttons, backgrounds...)
├── Resources/       # Mock data and sound files
└── Assets.xcassets  # Images, app icon, and all colors (Light/Dark)
```

## Requirements

- Xcode 26 or later
- iOS 26 or later
- Swift 6

## Getting Started

1. Open `Sanam.xcodeproj` in Xcode
2. Select any iPhone simulator
3. Run ▶️

No external dependencies — the project relies solely on Apple's native frameworks.
