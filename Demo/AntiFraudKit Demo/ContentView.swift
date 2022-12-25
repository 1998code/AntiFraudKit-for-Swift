//
//  ContentView.swift
//  AntiFraudKit Demo
//
//  Created by Ming on 21/12/2022.
//

import SwiftUI
import AntiFraudKit

struct ContentView: View {
    @State var appStoreURL: String = "https://apps.apple.com/app/betterappicons/id1532627187"   // Suggest user to download via App Store
    @State var purchasedVersion: String = ""                                                    // Return Purchased Version
    @State var purchasedDate: String = ""                                                       // Return Purchased Date
    @State var maxSkip: Int = 10                                                                // Set Max Skip Times in case your user may not be able to verify at that moment
    @State var allowJailbreak: Bool = false                                                     // Prevent user to tweak your app/game in a JB environment
    
    var body: some View {
        ZStack {
            
            // MARK: - Replace with your content
            VStack{
                Color.green
                Color.teal
            }.ignoresSafeArea(.all)
            
            // MARK: - Replace End Here & ATFraud Start
            ATFraud(appStoreURL: $appStoreURL, purchasedVersion: $purchasedVersion, purchasedDate: $purchasedDate, maxSkip: $maxSkip, allowJailbreak: $allowJailbreak)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
