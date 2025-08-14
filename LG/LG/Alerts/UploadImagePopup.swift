//
//  UploadImagePopup.swift
//  LG
//
//  Created by QTS Coder on 4/8/25.
//


import SwiftUI

struct UploadImagePopup: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    var onGalleryTap: () -> Void
    var onCameraTap: () -> Void
    var onDissmiss: () -> Void
    
    var body: some View {
        
        VStack(spacing: 10) {
            HStack {
                Text("Upload Image")
                    .font(.appFontSemibold(20))
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    onDissmiss()
                }) {
                    Image("btnClose")
                }
            }.padding(.bottom, 10)

            HStack(spacing: 16) {
                UploadOptionButton(
                    title: "Add from Gallery",
                    iconName: "ic_upload_photo",
                    background: Color.white.opacity(0.05),
                    action: onGalleryTap
                )
               
                UploadOptionButton(
                    title: "Take a Photo",
                    iconName: "ic_camera_photo",
                    background: Color.white.opacity(0.05),
                    action: onCameraTap
                )
            }
            .padding(.bottom, safeAreaInsets.bottom + 10)
            
            
        }
        
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white10, lineWidth: 1)
                .backgroundImage("bgPopUp"))
        .cornerRadius(20)
        .padding(.bottom, -(safeAreaInsets.bottom + 10))
    }
}

struct UploadOptionButton: View {
    let title: String
    let iconName: String
    let background: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Image(iconName)
                    .foregroundColor(.white)

                Text(title)
                    .foregroundColor(.white)
                    .font(.appFontMedium(15))
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading) // 👈 Căn trái toàn bộ
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

