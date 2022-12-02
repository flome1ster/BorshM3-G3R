//
//  MessageRow.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 15.06.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageRow: View {
    let entity: MessageEntity
    let name: String
    let showDate: Bool
    let showName: Bool
    let showAvatar: Bool
    let avatar: String
    var body: some View {
        HStack (alignment: .bottom, spacing: 12) {
            WebImage(url: URL(string: avatar))
                .onSuccess { image, data, cacheType in
                }
                .resizable()
                .placeholder(Image("user_plaseholder"))
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .isHidden(!showAvatar)
            VStack(alignment: .leading){
                VStack(alignment: .leading){
                    if showName {
                        Text(name).foregroundColor(.gray)
                            .font(.system(size: 12))
                    }
                    Text(entity.text)
                    
                }
                .padding(8)
                .background(Color("grey"))
                .cornerRadius(16, corners: [.topLeft, .topRight, .bottomRight])
                if showDate {
                    Text(formatDate(unix: entity.data)).font(.system(size: 12)).foregroundColor(.gray).padding(-1)
                }
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
    }
}

struct UserRow_Previews: PreviewProvider {
    static var previews: some View {

        MessageRow(entity: MessageEntity(id: 1, userId: 23, text: "Текст сообщения", data: 1655286303, read: "0"),name: "Имя Фамилия", showDate: true, showName: true, showAvatar: true, avatar: "")
    }
}
