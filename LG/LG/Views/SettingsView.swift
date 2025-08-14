//
//  SettingsView.swift
//  LG
//
//  Created by QTS Coder on 1/8/25.
//

import SwiftUI
import PopupView
struct SettingsView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var showPro = false
    @State private var showSwitchPlan = false
    @State private var showSafari = false
    @State private var showSafariTerm = false
    var body: some View {
        NavigationStack{
            ZStack{
                Color.init(hex: "0E1621").ignoresSafeArea()
                ScrollView (showsIndicators: false){
                    VStack(spacing: 24) {
                        // Title
                        Text("Settings")
                            .font(.appFontSemibold(32))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal).padding(.top, -20)
                        Button {
                            showPro = true
                        } label: {
                            ProUpgradeCard()
                        }
                        VStack(spacing: 0) {
                            HStack {
                                Image("st_premium")
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Pro Plan")
                                        .foregroundColor(.white)
                                        .font(.appFontSemibold(15))
                                
                                    Text("Subscription Valid Until Dec 01, 2025")
                                        .foregroundColor(.gray)
                                        .font(.appFontRegular(12))
                                }
                               

                                Spacer()

                                Menu {
                                    Button {
                                        // Action
                                        showSwitchPlan.toggle()
                                    } label: {
                                        HStack{
                                            Image("st_switch")
                                            Text("Switch Plan").font(.appFontMedium(15)).foregroundColor(.white)
                                        }
                                    }
                                    
                                    Button {
                                        // Delete action
                                    } label: {
                                        HStack{
                                            Image("st_subs")
                                            Text("Manage Subscription").font(.appFontMedium(15)).foregroundColor(.white)
                                        }
                                    }
                                } label: {
                                    Image("btnMore").frame(width: 40, height: 40, alignment: .leading)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 14)
                            
                        }
                        .background(Color.white5)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Main Settings Section
                        VStack(spacing: 0) {
                            Button {
                                ShareManager.shared.requestReview()
                            } label: {
                                SettingsRow(icon: "st_rate", iconColor: .purple, title: "Rate our App")
                            }
                            Divider().background(Color.gray.opacity(0.4))
                            
                            Button {
                                
                                
                                if let windowScene = UIApplication.shared
                                    .connectedScenes
                                    .compactMap({ $0 as? UIWindowScene })
                                    .first,
                                   let window = windowScene.windows.first, let vc = window.rootViewController {
                                    ShareManager.shared.share(.text(CONFIG.CONTENT_SHARE), from: vc)
                                }
                            } label: {
                                SettingsRow(icon: "st_share", iconColor: .pink, title: "Share App")
                            }
                           
                            Divider().background(Color.gray.opacity(0.4))
                            Button {
                                let message =
                                    """
                                    <b>Write your message below:</b><br><br><br><br>
                                    
                                    
                                    
                                    
                                    
                                    
                                    <b>Diagnostic Information</b>
                                    <br>App Version: \(Bundle.mainAppVersion ?? "1.0")
                                    <br>Platform: iOS
                                    <br>UserId: \(UUID().uuidString)
                                    <br>Device: \(UIDevice.current.modelName)
                                    <br>OS Version: \(UIDevice.current.systemVersion)
                                    """
                                if let windowScene = UIApplication.shared
                                    .connectedScenes
                                    .compactMap({ $0 as? UIWindowScene })
                                    .first,
                                   let window = windowScene.windows.first, let vc = window.rootViewController {
                                    ShareManager.shared.shareViaEmailSetting(subject: CONFIG.SUBJECT_CONTACT, body: message, email: CONFIG.EMAIL_CONTACT, from: vc)
                                }
                            } label: {
                                SettingsRow(icon: "st_contact", iconColor: .orange, title: "Contact us")
                            }
                            
                        }
                        .background(Color.white5)
                        .cornerRadius(12)
                        .padding(.horizontal)

                        // Legal Section
                        VStack(spacing: 0) {
                            Button {
                                showSafari.toggle()
                            } label: {
                                SettingsRow(icon: "st_privacy", iconColor: .gray, title: "Privacy Policy")
                            }
                           
                            Divider().background(Color.gray.opacity(0.4))
                            Button {
                                showSafariTerm.toggle()
                            } label: {
                                SettingsRow(icon: "st_term", iconColor: .gray, title: "Terms of Service")
                            }
                            
                        }
                        .background(Color.white5)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.bottom, safeAreaInsets.bottom + 40)
                        
                    }
                    .navigationBarHidden(true)
                    .ignoresSafeArea(.keyboard)
                    .fullScreenCover(isPresented: $showPro) {
                        UnlockProView()
                    }
                    .sheet(isPresented: $showSafari) {
                        SafariView(url: URL(string: CONFIG.PRIVACY)!)
                    }
                    .sheet(isPresented: $showSafariTerm) {
                        SafariView(url: URL(string: CONFIG.TERMS)!)
                    }
                    .popup(isPresented: $showSwitchPlan) {
                        SwitchPlanView(isPresented: $showSwitchPlan)

                    }  customize: {
                        $0
                            .type(.floater())
                            .position(.bottom)
                            .animation(.spring(duration: 0.3))
                            .closeOnTapOutside(true)
                            .closeOnTap(false)
                            .allowTapThroughBG(false)
                            .backgroundView({
                                Rectangle()
                                    .fill(.ultraThinMaterial).opacity(0.8)
                                       .ignoresSafeArea()
                            })
                    }
                    .padding(.vertical)
                }
            }
        }
        
       
    }
}

// MARK: - Upgrade Card
struct ProUpgradeCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image("logo_st")
                Text("LocaChanger")
                    .font(.appFontBold(20))
                    .foregroundColor(.white)
            }

            Text("🚀 Upgrade to Pro for unlimited access and exclusive features! ✨")
                .font(.appFontRegular(17))
                .foregroundColor(.white)

            Text("Get Unlimited Access")
                .font(.appFontSemibold(17))
                .foregroundColor(Color.init(hex: "220C3C"))
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(25)
            
        }
        .padding()
        .background(
            LinearGradient(colors: [Color.purple, Color.blue], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    var icon: String
    var iconColor: Color
    var title: String

    var body: some View {
        HStack {
            Image(icon)
            Text(title)
                .foregroundColor(.white)
                .font(.appFontMedium(15))

            Spacer()

            Image("icDetail")
        }
        .padding(.horizontal)
        .padding(.vertical, 14)
    }
}

