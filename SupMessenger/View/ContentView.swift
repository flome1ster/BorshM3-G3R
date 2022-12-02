//
//  ContentView.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 30.05.2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userViewModel : UserViewModel
    @State private var isRegistr = UserDefaults.standard.bool(forKey: "isReg")
    var body: some View {
        NavigationView{
            
            if isRegistr {
                Main()
            }
            else
            {
                SignIn()
                
            }
            
        }.navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
