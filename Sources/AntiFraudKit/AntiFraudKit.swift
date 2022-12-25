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
    
    @State var showCheckingSheet: Bool = true
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
                checkJailbreak()
                Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                    checkJailbreak()
                }
                if purchasedVersion == "" && purchasedDate == "" {
                    await verifyPurchase()
                }
            }
            .sheet(isPresented: $showCheckingSheet) {
                sheet
                    .presentationDetents([.fraction(0.15)])
                    .interactiveDismissDisabled()
            }
        }
    }
    
    var sheet: some View {
        NavigationView {
            VStack {
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
            }.padding()
            .toolbar {
                #if os(iOS)
                ToolbarItemGroup(placement:.navigationBarLeading) {
                    Text("Anti-Fraud Checking...")
                        .bold()
                }
                ToolbarItemGroup(placement:.navigationBarTrailing) {
                    if currentSkip < maxSkip {
                        Button(action: {
                            currentSkip += 1
                            showAlertBox = true
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
                #endif
            }
            .alert(isPresented: $showAlertBox) {
                Alert(title: Text("Anti-Fraud Checking"),
                      message: Text("You have skipped \(currentSkip) times. You can skip \(maxSkip) times. \(maxSkip-currentSkip) times left."),
                        primaryButton: .cancel(Text("Purchase Now"), action: {
                            UIApplication.shared.open(URL(string: appStoreURL)!)
                        }),
                        secondaryButton: .default(Text("Skip Once"), action: {
                            showCheckingSheet = false
                            skip = true
                        }))
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
            await verifyPurchase()
        }
    }

    public func checkJailbreak() {
        if !allowJailbreak {
            if FileManager.default.fileExists(atPath: "/Applications/Cydia.app") ||
                FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
                FileManager.default.fileExists(atPath: "/bin/bash") ||
                FileManager.default.fileExists(atPath: "/usr/sbin/sshd") ||
                FileManager.default.fileExists(atPath: "/etc/apt") ||
                UIApplication.shared.canOpenURL(URL(string: "cydia://package/com.example.package")!) {
                exit(0)
            } else {
                print("SAFE")
            }
        } else {
            print("Allow JB happen!")
        }
    }
}

