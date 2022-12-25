# AntiFraudKit
### Accelerated by Apple SwiftUI

![hero](https://user-images.githubusercontent.com/54872601/209469175-22a5fa36-caa7-4bd3-9c30-a16deb2d7a5b.png)

## Aims
Provide an easy integration and UI for Apple Developers to protect the copyright for their app.

## Features
- Check App Store Purchase Receipt
- Temporary Skip Checking
- Serverless Design
- Anti-Jailbreak

## Version
![GitHub release (latest by date)](https://img.shields.io/github/v/release/1998code/AntiFraudKit-for-Swift?color=g&label=STABLE&style=for-the-badge)
![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/1998code/AntiFraudKit-for-Swift?color=green&include_prereleases&label=BETA&style=for-the-badge)

<img width="250px" src="https://user-images.githubusercontent.com/54872601/209471726-7440ae6d-05b7-44f6-a4a8-606ed96909b1.png" /> <img width="250px" src="https://user-images.githubusercontent.com/54872601/173193069-2eb486b0-1347-4448-ac2b-235b8f2f1bb0.png" />

## Environment
### Xcode Local
Tested on | Latest | Compatible
--------- | ------ | ----------
iOS       | 16     | 16
macOS     | 13     | 13

## Get Started
### Guide
Coming Soon 🤗

### Basic Setup
Coming Soon 🤗

### Major Usage
1. Import the framework
```swift
import AntiFraudKit
```

2. Add States before body or any some View.
Samples:
```swift
@State var appStoreURL: String = "https://apps.apple.com/app/betterappicons/id1532627187"   // Suggest user to download via App Store
@State var purchasedVersion: String = ""                                                    // Return Purchased Version
@State var purchasedDate: String = ""                                                       // Return Purchased Date
@State var maxSkip: Int = 10                                                                // Set Max Skip Times in case your user may not be able to verify at that moment
@State var allowJailbreak: Bool = false                                                     // Prevent user to tweak your app/game in a JB environment
```

## Developer Note
- Please report bugs in Issues section.
- If you want to discuss future roadmap or contribution, please find on Discussions.

## Preview
Light | Dark
------------- | ------------
![IMG_6A0BAFDBBAB2-2](https://user-images.githubusercontent.com/54872601/209469243-618b2135-447f-422e-b676-db7b5c2e6276.jpeg) | ![IMG_6A0BAFDBBAB2-1](https://user-images.githubusercontent.com/54872601/209469241-45522b8e-5dc5-4903-8080-9261f00f56dc.jpeg)

Ask for Signin | Login Error | Skip Alert on macOS
------------- | ------------ | -------------------
<img width="316" alt="CleanShot 2022-12-25 at 21 46 46@2x" src="https://user-images.githubusercontent.com/54872601/209470374-f9f51fe3-21ab-4041-80af-522e76d78283.png"> | <img width="304" alt="CleanShot 2022-12-25 at 21 46 58@2x" src="https://user-images.githubusercontent.com/54872601/209470384-16038742-d7f1-485d-bf31-891fcac51cc8.png"> | <img width="372" alt="CleanShot 2022-12-25 at 22 11 39@2x" src="https://user-images.githubusercontent.com/54872601/209471284-6be2b53a-b4fe-4fe8-9618-ac9222c514a4.png">

## Demo
Path: `./Demo` (Xcode Project in SwiftUI)

## License
MIT
