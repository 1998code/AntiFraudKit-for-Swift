//
//  ContentView.swift
//  AntiFraudKit Demo
//
//  Created by Ming on 21/12/2022.
//

import SwiftUI
import AntiFraudKit

struct ContentView: View {
    @State var appStoreURL: String = "https://apps.apple.com/app/betterappicons/id1532627187"
    @State var purchasedVersion: String = ""
    @State var purchasedDate: String = ""
    @State var maxSkip: Int = 10
    
    var body: some View {
        ZStack {
            VStack{
                Color.green
                Color.teal
            }.ignoresSafeArea(.all)
            ATFraud(appStoreURL: $appStoreURL, purchasedVersion: $purchasedVersion, purchasedDate: $purchasedDate, maxSkip: $maxSkip)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
