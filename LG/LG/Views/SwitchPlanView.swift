//
//  SwitchPlanView.swift
//  LG
//
//  Created by QTS Coder on 6/8/25.
//


import SwiftUI

struct SwitchPlanView: View {
    @Binding var isPresented: Bool
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var currentPlan: PlanType = .weekly
    @State private var selectedPlan: PlanType? = nil

    var body: some View {
        ZStack{
            VStack(spacing: 24) {
                // Header
                HStack {
                    Text("Switch Plan")
                        .font(.appFontSemibold(20))
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image("btnClose").frame(width: 40, height: 40)
                    }
                }

                // Current Plan
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Plan")
                        .font(.appFontMedium(17))
                        .foregroundColor(.white)
                    
                    PlanRowViewChangeType(plan: currentPlan, isCurrent: true)
                }

                // Other Plans
                VStack(alignment: .leading, spacing: 8) {
                    Text("Other Plans")
                        .font(.appFontMedium(17))
                        .foregroundColor(.white)
                    
                    ForEach(PlanType.allCases.filter { $0 != currentPlan }, id: \.self) { plan in
                        Button {
                            selectedPlan = plan
                        } label: {
                            PlanRowViewChangeType(plan: plan, isSelected: selectedPlan == plan)
                        }
                    }
                }

                // Switch Button
                Button {
                    // Save action
                    withAnimation {
                        isPresented = false
                    }
                } label: {
                    if selectedPlan == nil {
                        Text("Switch")
                            .foregroundColor(.white.opacity(0.3))
                            .font(.appFontSemibold(16))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.05))
                            )
                    }
                    else{
                        Text("Switch")
                            .font(.appFontSemibold(16))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [Color(hex: "9C23FF"), Color(hex: "AA55FF")], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white100)
                            .cornerRadius(25)
                    }
                    
                }
                .disabled(selectedPlan == nil).padding(.bottom, safeAreaInsets.bottom + 10)
            }
        }
        
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white10, lineWidth: 1)
                .backgroundImage("bgPopUp"))
        .cornerRadius(20)
        .padding(.bottom, -(safeAreaInsets.bottom + 10))
    }
}

enum PlanType: String, CaseIterable {
    case weekly = "Weekly"
    case yearly = "Yearly"

    var price: String {
        switch self {
        case .weekly: return "$5.99 / Week"
        case .yearly: return "$29.99"
        }
    }
}

struct PlanRowViewChangeType: View {
    let plan: PlanType
    var isSelected: Bool = false
    var isCurrent: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(plan.rawValue)
                    .font(.appFontMedium(17))
                    .foregroundColor(.white)
                Text(plan.price)
                    .font(.appFontRegular(15))
                    .foregroundColor(.white50)
            }

            Spacer()

            if isCurrent {
            } else if isSelected {
                Image("radio1")
            } else {
                Image("radio")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(isSelected ? Color.init(hex: "A33CFF") : Color.clear, lineWidth: isSelected ? 2 : 1)
                .background(
                    isSelected ? Color(hex: "A33CFF").opacity(0.16) : Color.white5
                )
                .cornerRadius(20)
        )
        
        .cornerRadius(20)
    }
}
