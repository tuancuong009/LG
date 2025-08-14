//
//  OnboardingPage.swift
//  LG
//
//  Created by QTS Coder on 31/7/25.
//


import SwiftUI
import StoreKit
struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
    let showsButton: Bool
    var imageSub: String
}

struct OnboardingView: View {
    @State private var currentPage = 0
    @EnvironmentObject var appVM: AppViewModel
    private let pages: [OnboardingPage] = [
        OnboardingPage(title: "Save & Edit Location",
                       subtitle: "Map displays both your position and elevation.",
                       imageName: "slide2",
                       showsButton: false, imageSub: "title_slide2"),
        
        OnboardingPage(title: "View Archive Map & Location",
                       subtitle: "See your past location saves anytime!",
                       imageName: "slide3",
                       showsButton: false,  imageSub: "title_slide3"),
        
        OnboardingPage(title: "Relive Your Journey",
                       subtitle: "Keep track of every place you’ve been",
                       imageName: "slide4",
                       showsButton: false,  imageSub: "title_slide4"),
        
        OnboardingPage(title: "Give us a Rating",
                       subtitle: "Your early support makes a big difference. A simple rating helps us grow faster and reach more people like you.",
                       imageName: "bgRate",
                       showsButton: true,  imageSub: "title_rateapp"),
    ]
    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        let page = pages[index]
                        if index == pages.count - 1{
                            VStack(spacing: 10) {
                                Spacer()
                                Image(page.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 40)
                                    .padding(.bottom, 20)
                               
                                
                                Image(page.imageSub)
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.bottom, 10)
                                
                                Text(page.subtitle)
                                    .font(.appFontRegular(15.0))
                                    .foregroundColor(.white50)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                Spacer()
                            }
                            .padding()
                            .tag(index)
                        }
                        else{
                            VStack(spacing: 20) {
                                Image(page.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity)
                                    .padding(.bottom, 0)
                                HStack(spacing: 8) {
                                    ForEach(0..<pages.count - 1, id: \.self) { index in
                                        Circle()
                                            .fill(index == currentPage ? Color.white : Color.white.opacity(0.4))
                                            .frame(width: 8, height: 8)
                                    }
                                }
                                
                                Spacer()
                                
                                Image(page.imageSub)
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.bottom, 10)
                                
                                Text(page.subtitle)
                                    .font(.appFontRegular(15.0))
                                    .foregroundColor(.white50)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            .padding(0)
                            .tag(index)
                        }
                        
                    }
                }
               
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
               
                Button(action: {
                    withAnimation {
                        if currentPage < pages.count - 1 {
                            currentPage += 1
                            if currentPage == pages.count - 1{
                                self.requestReview()
                            }
                        } else {
                            appVM.hasSeenOnboarding = true
                            OnboardingsManagerHandler.shared.isShowing = true
                        }
                    }
                }) {
                    Text("Next")
                        .font(.appFontSemibold(16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [Color(hex: "9C23FF"), Color(hex: "AA55FF")], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white100)
                        .cornerRadius(25)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 24)
                Spacer(minLength: 60)
            }
            .backgroundImage("bgAll")
            .navigationBarHidden(true)
            
        }
    
    }
    
    func requestReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
