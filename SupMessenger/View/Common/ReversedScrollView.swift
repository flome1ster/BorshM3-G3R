//
//  ReversedScrollView.swift
//  SupMessenger
//
//  Created by Yaroslav Derbyshev on 16.06.2022.
//

import SwiftUI

struct Stack<Content: View>: View {
    var axis: Axis.Set
    var content: Content
    
    init(_ axis: Axis.Set = .vertical,  @ViewBuilder builder: ()->Content) {
        self.axis = axis
        
        self.content = builder()
    }
    
    var body: some View {
        switch axis {
        case .horizontal:
            HStack {
                content
            }
        case .vertical:
            VStack {
                content
            }
        default:
            VStack {
                content
            }
        }
    }
}

struct ReversedScrollView<Content: View>: View {
    var axis: Axis.Set
    var leadingSpace: CGFloat
    var content: Content
    
    init(_ axis: Axis.Set = .vertical, leadingSpace: CGFloat = 10, @ViewBuilder builder: ()->Content) {
        self.axis = axis
        self.leadingSpace = leadingSpace
        self.content = builder()
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(axis) {
                Stack(axis) {
                    Spacer(minLength: leadingSpace)
                    content
                        
                }
                .frame(
                               minWidth: minWidth(in: proxy, for: axis),
                               minHeight: minHeight(in: proxy, for: axis)
                            )
                .rotationEffect(.radians(.pi))
            }
            .rotationEffect(.radians(.pi))
        }
    }

    
    func minWidth(in proxy: GeometryProxy, for axis: Axis.Set) -> CGFloat? {
        axis.contains(.horizontal) ? proxy.size.width : nil
    }
    
    func minHeight(in proxy: GeometryProxy, for axis: Axis.Set) -> CGFloat? {
        axis.contains(.vertical) ? proxy.size.height : nil
    }
}

struct ReversedScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ReversedScrollView(.vertical){
            ForEach(0..<5) { item in
                            Text("\(item)")
                                .padding()
                                .background(Color.gray.opacity(0.5))
                                .cornerRadius(6)
                        }
        }
    }
}
