//
//  SignIn.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 30.05.2022.
//
import SwiftUI
struct SignIn: View {
    @EnvironmentObject var userViewModel : UserViewModel
    @State var flag: Bool = false
    var body: some View {
        ZStack{
            //Color("main")
            //  .edgesIgnoringSafeArea(.all)
            /*Image("background")
             .resizable()
             .scaledToFill()
             .ignoresSafeArea(.all)*/
            // .edgesIgnoringSafeArea(.all)
            NavigationLink(destination: Main(),
                           isActive: $userViewModel.isRegistr){
                EmptyView()
            }
            VStack(alignment: .leading, spacing: 8){
                Text("Добро пожаловать в СУП!")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .padding(.vertical, 24)
                Text("Логин")
                    .foregroundColor(.white)
                
                CustomTextField(placeholder: Text("Введите логин"), text: $userViewModel.user.email, error: $flag)
                HStack{
                    Text("Пользователь не найден").foregroundColor(.red)
                }.opacity(flag ? 1 : 0)
                Text("Пароль")
                    .foregroundColor(.white)
                CustomTextField(placeholder: Text("Введите пароль"), text: $userViewModel.user.password, secure: true, error: $flag)
                HStack{
                    Text("Неверный пароль").foregroundColor(.red)
                }.opacity(flag ? 1 : 0)
                VStack (alignment: .leading){
                    CustomButtonOrange(text: "Начать работу"){userViewModel.login() }
                    
                    ForgotButton(text: "Забыли пароль?"){
                        flag.toggle()
                    }
                }
                Spacer()
                HStack{
                    Image("Prava")
                    Spacer()
                    Text("Все права защищены и что-то еще тут написано, может ссылка на права")
                        .foregroundColor(.white)
                }//Hstack
            } // VstackEnd
            .padding()
        } //ZStackEnd
        .background(
            Image("background").resizable().scaledToFill().edgesIgnoringSafeArea(.all)
                )
        .navigationBarHidden(true) //ZStack
        .alert(isPresented: $userViewModel.alert) {
            Alert(title: Text("Ошибка"), message: Text(userViewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}
struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn().environmentObject(UserViewModel())
    }
}

