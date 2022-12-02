//
//  BackButton.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 17.06.2022.
//

import SwiftUI

struct BackButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: {action()}){
            Image("Back")
        }
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        BackButton{}
    }
}
