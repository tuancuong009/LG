//
//  EditLocationPopup.swift
//  LG
//
//  Created by QTS Coder on 5/8/25.
//
import SwiftUI
struct EditLocationPopup: View {
    @Binding var isPresented: Bool
    let event: LocationObj
    @Binding  var locationName: String
    @State private var isEditLocationName = false
    @FocusState private var isLocationFocused: Bool
    var onEditSuccess: ((String) -> Void)? = nil
    var body: some View {
        VStack(spacing: 20) {
            // Title + Close
            HStack {
                Text("Edit Location Title")
                    .font(.appFontSemibold(20))
                    .foregroundColor(.white)
                Spacer()
                Button {
                    withAnimation {
                        isPresented = false
                    }
                } label: {
                    Image("btnClose")
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                TextField("Enter Location name", text: $locationName, onEditingChanged: { editing in
                    if editing {
                        isEditLocationName = true
                    } else {
                        isEditLocationName = false
                    }
                })
                .focused($isLocationFocused)
                .submitLabel(.done) // set return key
                .onSubmit {
                    // Handle submit action here if needed
                }
                .keyboardType(.alphabet)
                .autocapitalization(.words)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke( isEditLocationName ? Color.init(hex: "9C23FF") : Color.white15))
                .foregroundColor(.white)
                .font(.appFontMedium(15))
                .overlay(
                    HStack {
                        Spacer()
                        if isLocationFocused && !locationName.isEmpty {
                            Button(action: {
                                locationName = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white50)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
            }
            .padding(.horizontal, 0)

            // Save Button
            Button {
                // Save action
                _ = CoreDataManager.shared.updateLocationTitle(id: event.id, title: locationName)
                onEditSuccess?(locationName)
                withAnimation {
                    isPresented = false
                }
            } label: {
                if locationName.trimmed.isEmpty{
                    Text("Save Location")
                        .foregroundColor(.white.opacity(0.3))
                        .font(.appFontSemibold(16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(locationName.isEmpty ? 0.05 : 0.15))
                        )
                }
                else{
                    Text("Save Location")
                        .font(.appFontSemibold(16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [Color(hex: "9C23FF"), Color(hex: "AA55FF")], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white100)
                        .cornerRadius(25)
                }
                
            }
            .disabled(locationName.trimmed.isEmpty)
            .padding(.bottom, 40)

        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                .backgroundImage("bgPopUp").cornerRadius(20)
        )
        .padding(.horizontal, 0)
        .padding(.bottom, -50)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isLocationFocused = true
            }
        }
    }
}
