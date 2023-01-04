//
//  Created by Ming on 11/6/2022.
//

import SwiftUI
import StoreKit
import Network

@available(iOS 16, watchOS 9.0, macOS 13.0, *)
public struct ATFraud: View {
    
    @Binding var appStoreURL: String
    @Binding var purchasedVersion: String
    @Binding var purchasedDate: String
    @Binding var maxSkip: Int
    @Binding var allowJailbreak: Bool
    
    @State var showCheckingSheet: Bool = false
    @State var err: String = ""
    
    @AppStorage("currentSkip") var currentSkip: Int = 0
    @State var skip: Bool = false
    
    @State var showAlertBox: Bool = false
    
    public init(appStoreURL: Binding<String>, purchasedVersion: Binding<String>, purchasedDate: Binding<String>, maxSkip: Binding<Int>, allowJailbreak: Binding<Bool>) {
        _appStoreURL = appStoreURL
        _purchasedVersion = purchasedVersion
        _purchasedDate = purchasedDate
        _maxSkip = maxSkip
        _allowJailbreak = allowJailbreak
    }
    
    public var body: some View {
        if (purchasedVersion == "" || purchasedDate == "") && !skip {
            ZStack {
                Color.gray.opacity(0.01)
                ProgressView()
            }
            .background(.ultraThinMaterial)
            .ignoresSafeArea(.all)
            .task {
#if os(iOS)
                showCheckingSheet = true
                checkJailbreak()
                Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                    checkJailbreak()
                }
#elseif os(macOS)
                showCheckingSheet = true
#endif
                
                if purchasedVersion == "" && purchasedDate == "" {
                    await verifyPurchase()
                }
            }
            .sheet(isPresented: $showCheckingSheet) {
                Group{
#if os(iOS)
                    NavigationView {
                        sheet
                    }
                    .presentationDetents([.fraction(0.15)])
                    .interactiveDismissDisabled()
#elseif os(macOS)
                    sheet
                        .interactiveDismissDisabled()
#endif
                }
                .alert(isPresented: $showAlertBox) {
                    Alert(title: Text("Anti-Fraud Checking"),
                          message: Text("You have skipped \(currentSkip) times. You can skip \(maxSkip) times. \(maxSkip-currentSkip) times left."),
                        primaryButton: .cancel(Text("Purchase Now"), action: {
#if os(iOS)
                            UIApplication.shared.open(URL(string: appStoreURL)!)
#elseif os(macOS)
                            NSWorkspace.shared.open(URL(string: appStoreURL)!)
#endif
                        }),
                        secondaryButton: .default(Text("Skip Once"), action: {
                            if currentSkip < maxSkip {
                                currentSkip += 1
                                showCheckingSheet = false
                                skip = true
                            }
                        })
                    )
                }
            }
        }
    }
    
    public var sheet: some View {
        VStack {
            #if os(macOS)
            HStack {
                Text("Anti-Fraud Checking...")
                    .bold()
                sheetAction
            }
            #endif
            HStack {
                VStack(alignment: .leading) {
                    Label("App Store Receipt", systemImage: "purchased.circle")
                }
                Spacer()
                if err != "" || purchasedVersion != "" || purchasedVersion != "" {
                    Label(purchasedVersion != "" && purchasedVersion != "" ? "OK" : err,
                          systemImage: purchasedVersion != "" && purchasedVersion != "" ? "checkmark.diamond.fill" : "xmark.diamond.fill")
                    .foregroundColor(purchasedVersion != "" && purchasedVersion != "" ? .teal : .red)
                    .padding(.trailing,5)
                } else {
                    ProgressView()
                }
            }
#if os(iOS)
            .padding()
#endif
#if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                heroImg
            }
#endif
        }
#if os(iOS)
        .toolbar {
            ToolbarItemGroup(placement:.navigationBarLeading) {
                Text("Anti-Fraud Checking...")
                    .bold()
            }
            ToolbarItemGroup(placement:.navigationBarTrailing) {
                sheetAction
            }
        }
#elseif os(macOS)
        .padding()
#endif
    }
    
    public var heroImg: some View {
        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1655720408861-8b04c0724fd9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2832&q=80")) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            ProgressView()
        }
    }
    
    public var sheetAction: some View {
        Group {
            if currentSkip < maxSkip {
                Button(action: {
                    print("pass")
                    showAlertBox = true
                    print(showAlertBox)
                }) {
                    HStack {
                        Text("Skip Once").bold()
                        Image(systemName: "goforward.plus")
                    }.font(.caption)
                }
                .tint(.accentColor)
                .buttonStyle(.bordered)
            } else {
                // MARK: Purchase Suggestion
                Link(destination: URL(string: appStoreURL)!) {
                    HStack {
                        Text("Purchase Now").bold()
                        Image(systemName: "a.square.fill")
                    }
                    .font(.caption)
                }
            }
        }
    }
    
    public func verifyPurchase() async {
        do {
            let result: VerificationResult<AppTransaction> = try await AppTransaction.shared
            switch result {
                
            case .unverified(_, let verificationError):
                err = "\(verificationError)"
                
            case .verified(let appTransaction):
                purchasedVersion = appTransaction.originalAppVersion
                purchasedDate = appTransaction.originalPurchaseDate.formatted(.dateTime.day().month().year())
                currentSkip = 0
                showCheckingSheet = false
            }
        }
        catch {
            err = "Invalid"
//            await verifyPurchase()
        }
    }

#if os(iOS)
    public func checkJailbreak() {

        if !allowJailbreak {
            if FileManager.default.fileExists(atPath: "/Applications/Cydia.app") || UIApplication.shared.canOpenURL(URL(string: "cydia://package/com.example.package")!) {
                exit(0)
            } else {
                print("SAFE")
            }
        } else {
            print("Allow JB happen!")
        }
    }
#endif

}

