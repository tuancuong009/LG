import SwiftUI
import PopupView
struct UnlockProView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: PlanOption = .weekly
    @State private var isHightLightWeek = true
    @State private var isHightLightYear = false
    @State private var alertPurchase = false
    @State private var messageFail = "Purchase Canceled"
    @State private var showCloseButton = false
    @State private var rotate = false
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Top bar
                HStack {
                    if showCloseButton{
                        Button(action: {
                            dismiss()
                        }) {
                            Image("btnClose2").frame(width: 40, height: 40, alignment: .leading)
                        }
                    }
                    else{
                        Color.clear.frame(width: 40, height: 40, alignment: .leading)
                    }
                    
                    Spacer()
                    Menu {
                        Button {
                            // Restore
                        } label: {
                            HStack {
                                Image("icRestore")
                                Text("Restore Purchases")
                                    .font(.appFontMedium(15))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Button {
                            // Help
                        } label: {
                            HStack {
                                Image("icHelp")
                                Text("Need Help?")
                                    .font(.appFontMedium(15))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Divider()
                        
                        Button {
                            // Privacy
                        } label: {
                            HStack {
                                Text("Privacy Policy")
                                    .font(.appFontMedium(15))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Button {
                            // Terms
                        } label: {
                            HStack {
                                Text("Terms of Service")
                                    .font(.appFontMedium(15))
                                    .foregroundColor(.white)
                            }
                        }
                    } label: {
                        Image("btnMore").frame(width: 40, height: 40, alignment: .trailing)
                    }
                }
                .padding(.horizontal)
                
                // Icon
                Image("log_paywall")
                    .rotationEffect(.degrees(rotate ? 10 : -10), anchor: .bottom) // Xoay quanh đáy
                    .animation(
                        .easeInOut(duration: 0.4).repeatForever(autoreverses: true),
                        value: rotate
                    )
                    .onAppear {
                        rotate = true
                    }
                Image("logo_tex_paywall")
                // Feature list
                VStack(alignment: .leading, spacing: 16) {
                    FeatureRow(icon: "ic_unlimit", text: "Unlimited Location Saves")
                    FeatureRow(icon: "ic_location_map", text: "Save, Edit & Share Location")
                    FeatureRow(icon: "ic_rate", text: "Access to Upcoming Features")
                    FeatureRow(icon: "icNoAds", text: "Ad-Free Experience")
                }
                .padding(.horizontal, 40)
                
                // Plan selection
                VStack(spacing: 12) {
                    // Yearly
                    TapScaleButton(action: {
                        isHightLightYear = true
                        isHightLightWeek = false
                        selectedPlan = .yearly
                    }) {
                        PlanRowView(title: "Yearly Plan",
                                    subtitle: "$29.99 per year",
                                    strikethroughPrice: "$311.48",
                                    badge: "SAVE 90%",
                                    isSelected: isHightLightYear,
                                    isHighlighted: isHightLightYear)
                    }
                    
                    // Weekly
                    TapScaleButton(action: {
                        isHightLightYear = false
                        isHightLightWeek = true
                        selectedPlan = .weekly
                    }) {
                        PlanRowView(title: "Weekly Plan",
                                    subtitle: "$5.99 per week",
                                    isSelected: isHightLightWeek,
                                    isHighlighted: isHightLightWeek)
                    }
                }
                .padding(.horizontal)
                
                // Continue button
                Button(action: {
                    dismiss()
                    PurchaseSuccessManagerHandler.shared.isShowing.toggle()
                }) {
                    Text("Continue")
                        .font(.appFontSemibold(20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(
                            Capsule()
                                .strokeBorder(Color(hex: "7FECA1"), lineWidth: 3)
                                .background(Capsule().fill(Color(hex: "10D359")))
                        )
                }
                .padding(.horizontal)
                
                // Footer
                HStack {
                    Image("icProtect")
                    Text("Cancel anytime. Secured by Apple")
                        .font(.appFontMedium(15))
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
        }
        .padding(.top, 0)
        .backgroundImage("bgAll")
        .popup(isPresented: $alertPurchase) {
            AlertPurchaseView(type: .fail, message: messageFail)
        } customize: {
            $0
                .type(.toast)
                .position(.top)
                .autohideIn(2)
                .closeOnTapOutside(true)
                .dragToDismiss(true)
                .backgroundColor(.clear)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                showCloseButton.toggle()
            }
        }
    }
}

enum PlanOption {
    case yearly, weekly
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(icon)
            Text(text)
                .foregroundColor(.white)
                .font(.appFontMedium(18))
            Spacer()
        }
    }
}

struct PlanRowView: View {
    let title: String
    let subtitle: String
    var strikethroughPrice: String? = nil
    var badge: String? = nil
    var isSelected: Bool = false
    var isHighlighted: Bool = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Background + Content
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .foregroundColor(.white)
                        .font(.appFontBold(17))
                    
                    HStack(spacing: 4) {
                        if let old = strikethroughPrice {
                            Text(old)
                                .font(.appFontRegular(15))
                                .foregroundColor(.white40)
                                .strikethrough()
                        }
                        Text(subtitle)
                            .font(.appFontRegular(15))
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
                Image(isSelected ? "radio1" : "radio")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(isHighlighted ? Color.white : Color.clear, lineWidth: isHighlighted ? 2 : 1)
                    .background(
                        isHighlighted ? Color(hex: "A33CFF").opacity(0.16) : Color.white5
                    )
                    .cornerRadius(20)
            )
            
            // Badge icon
            if badge != nil {
                Image("badge_save")
                    .offset(x: -10, y: -10)
            }
        }
    }
}
