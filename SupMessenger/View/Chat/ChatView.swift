//
//  ChatView.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 15.06.2022.
//

import SwiftUI
import SDWebImageSwiftUI
struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
struct ChatView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel = ChatViewModel()
    var userId: Int
    var isGroup: Bool
    var name: String = ""
    var avatar: String = ""
    var date = 0
    
    init(msgId: Int, isGroup: Bool, name: String, avatar: String = ""){
        self.userId = msgId
        self.isGroup = isGroup
        self.name = name
        self.avatar = avatar
        if !isGroup {
            viewModel.users.append(UserEntity(id: userId, name: name, role: nil, online: true, avatar: avatar, date: nil, unread: nil))
        }
    }
    
    var body: some View {
        VStack{
            ZStack(alignment: .bottom) {
                ScrollView{
                    LazyVStack(pinnedViews: [.sectionHeaders]){
                        Divider().frame(height: 16).foregroundColor(.white)
                        ForEach(viewModel.messages.indices, id: \.self){ index in
                            let item = viewModel.messages[index]
                            if insertHeaders(position: index) {
                                Section(header:
                                            DateRow(date: viewModel.messages[index - 1].data) ///Не работают почему-то, надо исправить
                                ){}
                                    .rotationEffect(.radians(.pi))
                                    .scaleEffect(x: -1, y: 1, anchor: .center)
                            }
                            if (isGroup ? item.userId != viewModel.myId : item.userId == userId ){
                                let user = viewModel.users.first(where: {$0.id == item.userId})
                                MessageRow(entity: item, name: user?.name ?? "",
                                           showDate: self.isDateVisible(position: index, current: item),
                                           showName: isGroup ? isNameVisible(position: index, current: item) : false,
                                           showAvatar: isAvatarVisible(position: index, current: item),
                                           avatar: user?.avatar ?? "")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .rotationEffect(.radians(.pi))
                                .scaleEffect(x: -1, y: 1, anchor: .center)
                            } else {
                                MyMessageRow(entity: item, showDate: self.isDateVisible(position: index, current: item), isUnread: item.read == "0").frame(maxWidth: .infinity, alignment: .trailing)
                                    .rotationEffect(.radians(.pi))
                                    .scaleEffect(x: -1, y: 1, anchor: .center)
                            }
                        }
                        if viewModel.endReached == false && (!isGroup || viewModel.myId != -1) {
                            if viewModel.error != nil {
                                ErrorItem{
                                    self.viewModel.fetchNext()
                                }
                                .rotationEffect(.radians(.pi))
                                .scaleEffect(x: -1, y: 1, anchor: .center)
                            } else {
                                ProgressView().onAppear{
                                    print("progress")
                                    self.viewModel.fetchNext()
                                }
                            }
                        }
                    }
                }
                .rotationEffect(.radians(.pi))
                .scaleEffect(x: -1, y: 1, anchor: .center)
                .padding(.bottom, 32)
                HStack(alignment: .center) {
                    Button(action: {}){
                        Image("attach")
                    }
                    TextField("Написать сообщение", text: $viewModel.input)
                        .padding(4)
                        .contentShape(Rectangle())
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)//.disabled(viewModel.sendStatus != 0)
                    ///Не работает многострочный текст
                    
                    if viewModel.sendStatus == 0 {
                        Button(action: {
                            viewModel.send()
                        }){
                            Image("send")
                        }.disabled(viewModel.input.isEmpty)
                    } else if viewModel.sendStatus == 1 {
                        ProgressView()
                    } else {
                        
                    }
                }
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 16)
                    .strokeBorder()
                    .foregroundColor(Color.gray))
                .background(RoundedRectangle(cornerRadius: 16).foregroundColor(.white))
                .padding(8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear{
            print("loading")
            self.viewModel.setup(id: userId, isGroup: isGroup)
            print(viewModel.endReached, isGroup, viewModel.myId)
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading){
                BackButton{
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .principal){
                VStack{
                    Text(self.name)
                    Text(isGroup ?
                         "\(viewModel.users.count) участников, \(viewModel.users.filter{ $0.online == true}.count) в сети"
                         : (viewModel.users.first{$0.id == viewModel.userId}?.online ?? false ? "Не в сети" : "Онлайн")
                    )
                    .font(.system(size: 12))
                    .foregroundColor(isGroup ?
                        .gray
                                     : (viewModel.users.first?.online ?? false ? Color("cyan") : .gray))
                }
                .frame(maxWidth: .infinity)
            }
            ToolbarItem(placement: .navigationBarTrailing){
                WebImage(url: URL(string:  (isGroup ? viewModel.users.first{$0.id == viewModel.myId} : viewModel.users.first)?.avatar ?? ""))
                    .onSuccess { image, data, cacheType in
                    }
                    .resizable()
                    .placeholder(Image("user_plaseholder"))
                    .scaledToFill()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
            }
        }
    }
    
    private var toolbar: some View {
        HStack{
            
            Spacer()
            
            
        }.frame(maxWidth: .infinity)
    }
    
    private func insertHeaders(position: Int) -> Bool{
        if position <= 0 { return false}
        
        let pd = viewModel.messages[position - 1].data / 86400
        let cd = viewModel.messages[position].data / 86400
        
        return pd != cd
    }
    
    private func isDateVisible(position: Int, current: MessageEntity) -> Bool {
        if position - 1 < 0 { return true }
        
        let before = viewModel.messages[position - 1]
        if before.userId == userId && current.userId == userId {
            return before.data / 60 != current.data / 60
        } else if before.userId == current.userId {
            let bd = before.data / 60
            let cd = current.data / 60
            return bd != cd || (bd != cd || before.userId != current.userId)
            
            
        } else { return true }
    }
    private func isNameVisible(position: Int, current: MessageEntity) -> Bool {
        if position >= viewModel.messages.count - 1 { return true }
        let after = viewModel.messages[position + 1]
        return after.userId != current.userId
        
    }
    private func isAvatarVisible(position: Int, current: MessageEntity) -> Bool {
        if position - 1 < 0 { return true}
        let before = viewModel.messages[position - 1]
        return before.userId != current.userId
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView( msgId: 123, isGroup: false, name: "")
    }
}
