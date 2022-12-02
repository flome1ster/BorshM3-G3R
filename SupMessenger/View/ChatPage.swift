//
//  ChatPage.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 30.05.2022.
//

import SwiftUI
import Combine
import SDWebImageSwiftUI

struct ChatPage: View{
    @ObservedObject var userViewModel = UserViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var item : UserEntity? = nil
    @State var flag: Bool = false
    @State var textfield: String = ""
    // @FocusState private var isFocused
    @State private var cancellables : AnyCancellable?
    var body: some View{
        VStack(spacing: 0){
            GeometryReader{ reader in
                ScrollView{
                    ScrollViewReader{ scrollReader in
                        LazyVGrid(columns: columns, spacing: 0){
                            ForEach(userViewModel.takeMessage, id:\.self){ message in
                                let isRecieved = message.userId == item!.id
                                HStack{
                                    if isRecieved{
                                        WebImage(url: URL(string:  item!.avatar ?? ""))
                                            .onSuccess { image, data, cacheType in
                                            }
                                            .resizable()
                                            .placeholder(Image("user_plaseholder"))
                                            .scaledToFill()
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                    } //ifEnd
                                    VStack(alignment: isRecieved ? .leading : .trailing){
                                        Text(message.text)
                                            .padding(.horizontal)
                                            .padding(.vertical, 12)
                                            .foregroundColor(isRecieved ? Color.black : Color.white)
                                            .background(isRecieved ? Color("grey") : Color("cyan"))
                                            .cornerRadius(10)
                                        Text(formatDate(unix: Int(message.data)))
                                            .foregroundColor(.gray)
                                            .font(.system(size: 10))
                                            .padding(-1)
                                    } //Zstack
                                    .frame(width: reader.size.width * 0.83, alignment: isRecieved ? .leading : .trailing)
                                    .padding(.vertical)
                                } //Hstack
                                .frame(maxWidth: .infinity, alignment: isRecieved ? .leading : .trailing)
                            } .rotationEffect(.degrees(180)) //Rotating ForEach
                        }
                        .padding(.horizontal)
                        .onAppear{
                            userViewModel.getUserMessage(userId: item!.id)
                            print(userViewModel.lastMessageId)
                        }
                    } //ScrollReader
                } //scrollView
                .rotationEffect(.degrees(180)) //Rotating full ScrollView
            } //GeometryReader
            toolbarView() //Toolbar with textfield and buttons
        } //Vstack
        .padding(.top, 1)
        .navigationBarItems(leading: btnBack, trailing: navBarTrlng)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        //.navigationBarHidden(true)
    } //ViewEnd//
    var btnBack : some View {
        HStack{
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image("Back") // set image here
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.black)
                    
                }
            }
            Text(item!.name)
        }
    }
    var navBarLdng: some View{
        Text(item!.name)
    }
    var navBarTrlng: some View{
        HStack{
            WebImage(url: URL(string:  item!.avatar ?? ""))
                    .onSuccess { image, data, cacheType in
                        }
                    .resizable()
            .placeholder(Image("user_plaseholder"))
            .scaledToFill()
            .frame(width: 36, height: 36)
                .clipShape(Circle())
        }
    }
    
    func toolbarView() -> some View{
        VStack{
            HStack{
                Button(action: {}, label: {Image("attach")})
                if #available(iOS 15.0, *) {
                    TextField(text: $userViewModel.textMessage.text,
                              label: {Text("Написать сообщение")
                        .font(.system(size: 14))}
                    )
                    //.focused($isFocused)
                    .frame(width: 250, height: 18)
                } else {
                    TextField("Написать сообщение",text: $userViewModel.textMessage.text)
                        .font(.system(size: 14))
                        .frame(width: 250, height: 18)
                    
                }
                Button(action: {
                    userViewModel.sendMessage(userId: item!.id)
                    self.userViewModel.textMessage.text = ""
                    
                },
                       label: {Image("send")})
            }
            .frame(width: 343, height: 45)
            .background(RoundedRectangle(cornerRadius: 10)
                .strokeBorder()
                .foregroundColor(Color.gray))
        }
        .padding(.vertical)
        .padding(.horizontal)
    }
    let columns = [GridItem(.flexible(minimum: 10))]

    
}

struct ChatPage_Previews: PreviewProvider {
    static var previews: some View {
        ChatPage()
    }
}
