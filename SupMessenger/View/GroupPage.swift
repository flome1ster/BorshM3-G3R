//
//  GroupPage.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 01.06.2022.
//

import SwiftUI
import SDWebImageSwiftUI
struct GroupPage: View {
    @ObservedObject var userViewModel = UserViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var item2: MessageEntity? = nil
    @State var item : GroupEntity? = nil
    @State var item3 : UserEntity? = nil
    @State var flag: Bool = false
    @State var textfield: String = ""
   // @FocusState private var isFocused
    @State var namee: String = ""
    var body: some View{
        VStack(spacing: 0){
            GeometryReader{ reader in
                ScrollView{
                    ScrollViewReader{ scrollReader in
                        LazyVGrid(columns: columns, spacing: 0){
                            ForEach(userViewModel.takeMessage, id:\.self){ message in
                                let isRecieved = message.userId != userViewModel.groupMeta.userId
                                
                                HStack{
                                    HStack(alignment: .bottom){
                                        isRecieved ?
                                        WebImage(url: URL(string:  userViewModel.listMessage.first(where: {$0.id == message.userId})?.avatar ?? ""))
                                            .onSuccess { image, data, cacheType in
                                            }
                                            .resizable()
                                            .placeholder(Image("user_plaseholder"))
                                            .scaledToFill()
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                            .offset(y: -15)
                                        : nil
                                        VStack(alignment: isRecieved ? .leading : .trailing){
                                            if isRecieved{
                                                Text(userViewModel.listMessage.first(where: {$0.id == message.userId})?.name ?? "Deleted user")
                                                    .font(.system(size: 10))
                                                    .padding(.bottom, 1)
                                            }
                                            
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
                                        }
                                        .frame(width: reader.size.width * 0.7, alignment: isRecieved ? .leading : .trailing)
                                        .padding(.vertical)
                                        
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: isRecieved ? .leading : .trailing)
                                
                            } .rotationEffect(.degrees(180)) //Rotating ForEach
                            
                        } //LazyVGrid
                        .padding(.horizontal)
                        .onAppear{
                            userViewModel.getGroupUsers(id: item!.id){
                                userViewModel.getGroupMessage(userId: item!.id)
                            }
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
                    Image("Back")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.black)
                    
                }
            }
            Text(item!.name)
        }
    }
    var navBarTrlng: some View{
        HStack{
            
            Image("groups_placeholder")
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
                //    .focused($isFocused)
                    .frame(width: 250, height: 18)
                } else {
                   TextField("Написать сообщение",
                    text: $userViewModel.textMessage.text)
                       .font(.system(size: 14))
                }
                
                Button(action: {
                    userViewModel.sendGroupMessage(userId: item!.id)
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


struct GroupPage_Previews: PreviewProvider {
    static var previews: some View {
        GroupPage()
    }
}
