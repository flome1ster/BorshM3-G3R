//
//  MyMessageRow.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 15.06.2022.
//

import SwiftUI

struct MyMessageRow: View {
    let entity: MessageEntity
    let showDate: Bool
    let isUnread: Bool
    var body: some View {
        
        VStack(alignment: .trailing){
            
            Text(entity.text)
                .foregroundColor(isUnread ? Color("red") : .white)
                //.foregroundColor(.white)
                .padding(8)
                .background( isUnread ? Color("lightred") : Color("cyan"))
                //.background(Color("cyan"))
                .cornerRadius(16, corners: [.topLeft, .topRight, .bottomLeft])
            
            
            if showDate {
                Text(formatDate(unix: entity.data)).font(.system(size: 12)).foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
    }
}

struct MyMessageRow_Previews: PreviewProvider {
    static var previews: some View {

        MyMessageRow(entity: MessageEntity(id: 1, userId: 23, text: "Текст сообщения", data: 1655286303, read: "0"),showDate: true, isUnread: false)
    }
}
