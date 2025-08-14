//
//  ContentView.swift
//  LG
//
//  Created by QTS Coder on 31/7/25.
//

import SwiftUI
import PopupView
struct ContentView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject var purchaseManager = PurchaseSuccessManagerHandler.shared
    @StateObject var onboardingManager = OnboardingsManagerHandler.shared
    
    var body: some View {
        MainTabView()
            .fullScreenCover(isPresented: .constant(!appVM.hasSeenOnboarding)) {
                GetStartedView()
            }
            .popup(isPresented: $purchaseManager.isShowing) {
                ProAccountView(isPresented: $purchaseManager.isShowing)
                
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
            .popup(isPresented: $onboardingManager.isSaveLocationSuccess) {
                AlertPopupView(data: AlertPopupData(
                    iconName: "ic_success",
                    title: "Successful",
                    message: "Location successfully saved"
                )) {
                    onboardingManager.isSaveLocationSuccess = false
                }
            }  customize: {
                $0
                    .type(.floater())
                    .position(.center)
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
        
            .popup(isPresented: $onboardingManager.isDisableLocation) {
                AlertPermisonLocationView(onNo:  {
                    onboardingManager.isDisableLocation = false
                }) {
                    onboardingManager.isDisableLocation = false
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            }  customize: {
                $0
                    .type(.floater())
                    .position(.center)
                    .animation(.spring(duration: 0.3))
                    .closeOnTapOutside(false)
                    .dragToDismiss(false)
                    .closeOnTap(false)
                    .allowTapThroughBG(false)
                    .backgroundView({
                        Rectangle()
                            .fill(.ultraThinMaterial).opacity(0.8)
                               .ignoresSafeArea()
                    })
            }
    }
}

#Preview {
    ContentView()
}
