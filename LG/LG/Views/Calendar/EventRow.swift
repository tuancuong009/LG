//
//  EventRow.swift
//  LG
//
//  Created by QTS Coder on 4/8/25.
//

import SwiftUI
struct EventRow: View {
    var onBookmark: ((LocationObj) -> Void)? = nil
    var onDetail: ((LocationObj) -> Void)? = nil
    @Binding var event: LocationObj
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Button {
                onDetail?(event)
            } label: {
                Image("ic_detailgps")
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title)
                        .foregroundColor(.white)
                        .font(.appFontSemibold(17))
                        .multilineTextAlignment(.leading)
                    Text(event.address)
                        .foregroundColor(.white50)
                        .font(.appFontRegular(13))
                        .multilineTextAlignment(.leading)
                }
            }
            Spacer()
            Button(action: {
                event.bookmark.toggle()
                _ = CoreDataManager.shared.updateBookmark(id: event.id, isBookmark: event.bookmark)
                onBookmark?(event)
            }) {
                ZStack {
                    Color.clear
                        .frame(width: 50, height: 50) 
                    Image(event.bookmark ? "fav2" : "fav")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24) // icon nhỏ
                }
            }
        }
        .padding(10)
    }
}
