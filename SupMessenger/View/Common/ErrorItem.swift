//
//  ErrorItem.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 17.06.2022.
//

import SwiftUI

struct ErrorItem: View {
    let title: String = "Ошибка"
    let message: String = "Не удалось загрузить данные"
    let action: () -> Void
    var body: some View {
        HStack(spacing: 8){
            VStack(alignment: .leading, spacing: 8) {
                Text(title).font(.system(size: 16))
                Text(message)
            }.frame(maxWidth: .infinity, alignment: .leading)
            Button("Повторить"){
                action()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).foregroundColor(Color("cyan")))
            .foregroundColor(.white)
        }.padding(16)
    }
}

struct ErrorItem_Previews: PreviewProvider {
    static var previews: some View {
        ErrorItem{}
    }
}
