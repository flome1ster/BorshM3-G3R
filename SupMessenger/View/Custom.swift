//
//  Custom.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 30.05.2022.
//

import SwiftUI
struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    @Binding var error: Bool
    init(placeholder: Text, text: Binding<String>,secure: Bool = false, error: Binding<Bool> = .constant(false)){
        self.placeholder = placeholder
        self._text = text
        _error = error
    }
    var secure: Bool = false
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder.foregroundColor(Color("g")).padding(.leading)
            }
            if self.secure {
                SecureField("", text: $text).padding().contentShape(Rectangle()).foregroundColor(.gray)
            } else {
                TextField("", text: $text).padding().contentShape(Rectangle()).foregroundColor(Color("g"))
            }
        }
        .foregroundColor(.gray)
        .background(RoundedRectangle(cornerRadius: 16)
            .stroke(error ? .red : .white, lineWidth: 1)
            .background(RoundedRectangle(cornerRadius: 16).foregroundColor(.white))
            
        )
        
        
    }
    
}
struct CustomButtonOrange: View {
    let text: String
    let action: () -> Void
    var body: some View {
        Button(action: action){
            Text(text)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(16)
            .foregroundColor(Color("cyan"))
            
            
        }
    }
}

struct WatchButton: View {
    let text: String
    let action: () -> Void
    var body: some View {
        Button(action: action){
            Text(text)
            .padding()
            .frame(width: 134, height: 44)
            .background(Color("orange"))
            .cornerRadius(4)
            .foregroundColor(Color.white)
            
        }
    }
}

struct CustomButtonFrame: View {
    let text: String
    let action: () -> Void
    var body: some View {
        Button(action: action){
            Text(text)
            .padding()
            .frame(width: 343, height: 44)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color("g"), lineWidth: 1)
            )
            .foregroundColor(Color("orange"))
            
        }
    }
}
struct ForgotButton: View {
    let text: String
    let action: () -> Void
    var body: some View {
        Button(action: action){
            Text(text)
            .padding()
            
            .foregroundColor(.white)
            
        }
    }
}
