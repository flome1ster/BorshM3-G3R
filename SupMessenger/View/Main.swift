//
//  Main.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 30.05.2022.
// 567263

import SwiftUI
import SDWebImageSwiftUI


struct PersonView: View{
    @EnvironmentObject var userViewModel : UserViewModel
    var body: some View{
        VStack{
        Text("Hello, user")
            Spacer()
            Button(action: {
                
                userViewModel.isRegistr = false
                UserDefaults.standard.set(userViewModel.isRegistr, forKey: "isReg")
            }, label: {
                Text("Выйти из аккаунта")
                    .foregroundColor(.red)
                    .font(.system(size: 20))
            })
           Text("После нажатия перезайдите в приложение")
            Spacer()
        }
    }
}
struct DialogView: View{
    @EnvironmentObject var userViewModel : UserViewModel
    @State var query: String = ""
    var body: some View{
        List{
            if #available(iOS 15.0, *) {
                ForEach(userViewModel.listMessage, id:\.self){item in
                    NavigationLink(destination: LazyView(ChatView(msgId: item.id, isGroup: false, name: item.name, avatar: item.avatar ?? ""))) {
                        HStack{
                            WebImage(url: URL(string:  item.avatar ?? ""))
                                .onSuccess { image, data, cacheType in
                                }
                                .resizable()
                                .placeholder(Image("user_plaseholder"))
                                .scaledToFill()
                                .frame(width: 50, height: 50, alignment: .center)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .foregroundColor(item.online ? .green : .red)
                                        .frame(width: 9, height: 9)
                                        .offset(x: 20, y: 20)
                                )
                            VStack(alignment: .leading){
                                Text(item.name)
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                                
                                Text(item.role ?? "")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                
                            } .padding(.leading)
                            Spacer()
                            VStack(spacing: 10){
                                if(item.date != 0){
                                    Text(convertDateToHourMin(dateValue: Int(item.date ?? 0)))
                                        .font(.system(size: 10))
                                }
                                
                                
                                if item.unread != 0 {
                                    Text(String(item.unread!))
                                        .font(.system(size: 10))
                                        .foregroundColor(Color("cyan"))
                                        .frame(maxWidth: 32, maxHeight: 19)
                                        .background(Color("lightcyan"))
                                        .cornerRadius(10)
                                } //ifEnd
                            }//vstack
                        } //HstackScroll
                    } //navigationLinkEnd
                } //ForEachEnd
                .listRowSeparator(.hidden)
            } else {
                ForEach(userViewModel.listMessage, id:\.self){item in
                    NavigationLink(destination: ChatView(msgId: item.id, isGroup: false, name: item.name, avatar: item.avatar ?? "")) {
                        HStack{
                            WebImage(url: URL(string:  item.avatar ?? ""))
                                .onSuccess { image, data, cacheType in
                                }
                                .resizable()
                                .placeholder(Image("user_plaseholder"))
                                .scaledToFill()
                                .frame(width: 50, height: 50, alignment: .center)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .foregroundColor(item.online ? .green : .red)
                                        .frame(width: 9, height: 9)
                                        .offset(x: 20, y: 20)
                                )
                            VStack(alignment: .leading){
                                Text(item.name)
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                                
                                Text(item.role ?? "")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                
                            } .padding(.leading)
                            Spacer()
                            VStack(spacing: 10){
                                if(item.date != 0){
                                    Text(convertDateToHourMin(dateValue: Int(item.date ?? 0)))
                                        .font(.system(size: 10))
                                }
                                
                                
                                if item.unread != 0 {
                                    Text(String(item.unread!))
                                        .font(.system(size: 10))
                                        .foregroundColor(Color("cyan"))
                                        .frame(maxWidth: 32, maxHeight: 19)
                                        .background(Color("lightcyan"))
                                        .cornerRadius(10)
                                } //ifEnd
                            }//vstack
                        } //HstackScroll
                    } //navigationLinkEnd
                } //ForEachEnd
            } /// Compability end
        }//list
        //.searchable(text: $query)
        .listStyle(.plain)
        .onAppear{userViewModel.getListMes()}
    }
}
struct GroupView: View{
    @EnvironmentObject var userViewModel : UserViewModel
    @State var query: String = ""
    var body: some View{
        List{
            if #available(iOS 15.0, *) {
                ForEach(userViewModel.groupMessage, id:\.self){item in
                    NavigationLink(destination: ChatView(msgId: item.id, isGroup: true, name: item.name)) {
                        HStack{
                            Image("groups_placeholder")
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading){
                                Text(item.name)
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                                //Text(item.count)
                                // .font(.system(size: 14))
                                // .foregroundColor(.gray)
                            } .padding(.leading)
                            Spacer()
                            if item.unread != 0 {
                                Text(String(item.unread))
                                    .font(.system(size: 10))
                                    .foregroundColor(Color("cyan"))
                                    .frame(maxWidth: 32, maxHeight: 19)
                                    .background(Color("lightcyan"))
                                    .cornerRadius(10)
                                
                            }
                        } //HstackScroll
                    }
                } //ForEachEnd
                
                .listRowSeparator(.hidden)
            } else {
                ForEach(userViewModel.groupMessage, id:\.self){item in
                    NavigationLink(destination: ChatView(msgId: item.id, isGroup: true, name: item.name)) {
                        HStack{
                            Image("groups_placeholder")
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading){
                                Text(item.name)
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                                //Text(item.count)
                                // .font(.system(size: 14))
                                // .foregroundColor(.gray)
                            } .padding(.leading)
                            Spacer()
                            if item.unread != 0 {
                                Text(String(item.unread))
                                    .font(.system(size: 10))
                                    .foregroundColor(Color("cyan"))
                                    .frame(maxWidth: 32, maxHeight: 19)
                                    .background(Color("lightcyan"))
                                    .cornerRadius(10)
                                
                            }
                        } //HstackScroll
                    }
                }
            }
            
        }//list
        //.searchable(text: $query)
        .listStyle(.plain)
        .onAppear{userViewModel.getListGroup()}
    }
}
struct Main: View{
    @State var tapped = 1
    @State var istap = 1
    @State var flag: Bool = false
    @State var query: String = ""
    @State private var selectedView = 0
    let tabBarName = ["Диалоги","","Группы"]
    let tabBarImage = ["Dialog", "Person", "Group"]
    @ObservedObject var userViewModel = UserViewModel()
    var body: some View{
        VStack{
            Text("")
            ZStack{
                switch selectedView{
                case 0:
                    DialogView()
                case 1:
                    PersonView()
                case 2:
                    GroupView()
                default:
                    PersonView()
                }
            } //Zstack 567263
            Spacer()
            HStack{
                ForEach(0..<3) { num in
                    Button(action: {
                        selectedView = num
                    }, label:{
                        Spacer()
                        if num == 1 {
                            VStack{
                                Circle()
                                    .frame(width: 55, height: 55)
                                    .foregroundColor(Color("cyan"))
                                    .overlay(
                                        Image(tabBarImage[num])
                                            .foregroundColor(.white)
                                    )
                            } .offset(y: -5)
                        }
                        else{
                            VStack{
                                Image(tabBarImage[num])
                                    .foregroundColor(selectedView == num ? (Color("cyan")) : .black)
                                Text(tabBarName[num])
                                    .font(.system(size: 14))
                                    .foregroundColor(selectedView == num ? (Color("cyan")) : .black)
                            }
                        }
                        Spacer()
                    }) //buttonEnd
                }//ForeachEnd
            }//HStackEnd
            .frame(height: 66)
            .frame(maxWidth: .infinity)
            .cornerRadius(15)
            
            
        }
        .navigationBarHidden(true)
    }
    
}



struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
