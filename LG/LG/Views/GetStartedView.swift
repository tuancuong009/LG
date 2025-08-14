import SwiftUI

struct GetStartedView: View {
    @State private var showOnboarding = false
    @Environment(\.openURL) var openURL
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    var body: some View {
        NavigationStack {
            VStack {
                Image("slide1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                
                Spacer()
                
                Image("title_slide1")
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom, 10)
                
                Text("Explore, save, and share any location with precision.")
                    .font(.appFontRegular(15.0))
                    .foregroundColor(.white50)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button(action: {
                    showOnboarding = true
                }) {
                    Text("Get Started!")
                        .font(.appFontSemibold(16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [Color(hex: "9C23FF"), Color(hex: "AA55FF")], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white100)
                        .cornerRadius(25)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 24)
                
                termsText
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 13)
                    .padding(.top, 16)
                    .padding(.bottom, safeAreaInsets.bottom + 10)
            }
            .backgroundImage("bgAll")
            .navigationDestination(isPresented: $showOnboarding) {
                OnboardingView()
            }
           
            .ignoresSafeArea()
        }
    }

    var termsText: some View {
        VStack(spacing: 4) {
            Text("By clicking “Get Started” you agree to LocaChanger")
                .font(.appFontRegular(13))
                .foregroundColor(.white50)
            
            HStack(spacing: 4) {
                Text("Terms of Service")
                    .font(.appFontMedium(13))
                    .foregroundColor(.white100)
                    .onTapGesture {
                        openURL(URL(string: CONFIG.TERMS)!)
                    }

                Text("and")
                    .font(.appFontRegular(13))
                    .foregroundColor(.white50)

                Text("Privacy Policy")
                    .font(.appFontMedium(13))
                    .foregroundColor(.white100)
                    .onTapGesture {
                        openURL(URL(string: CONFIG.PRIVACY)!)
                    }
            }
            .font(.footnote)
        }
        .multilineTextAlignment(.center)
    }



}
