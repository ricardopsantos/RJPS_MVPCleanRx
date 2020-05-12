//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import UIKit
import RJPSLib
import Foundation
import SwiftUI

// swiftlint:disable all

///
/// Imperative: With imperative programming, we’re directly telling the program (or app) what to do and how to do it.
/// You’re coding: “Put this button here, then download that piece of data, make a decision with if, and finally assign that value to a text label.”
///
/// Declarative: With declarative programming, we’re merely telling the program (or app) what to do, but not how.
/// We’re building the logic of a program, without describing its control flow. The actual implementation is up to the program or its frameworks.
///
/// https://fuckingswiftui.com
///

extension AppView {
    
    struct SampleA_SwiftUITesting: View {
        @State var imageName: String = "cloud.heavyrain.fill"
        @State var isShowing: Bool    = true // toggle state

        var someListSample1: some View {
            List {
                    Text("List2.Item_1")
                    Image(systemName: "clock")
                    Text("List2.Item_2")
                    Image(systemName: "clock")
                    Text("List2.Item_3")
                }
        }
        var someLabel: some View { return Text("Hello World").bold().italic().underline().lineLimit(2) }
        var someImage: some View { return Image(systemName: imageName).foregroundColor(.red).font(.title) }
        var someBtn: some View { return Button(action: {
            print("Tap!")
            }, label: {
                Image(systemName: "clock")
                Text("Click Me")
                Text("Subtitle")
            }).foregroundColor(Color.white).padding().background(Color.blue).cornerRadius(5)
        }
        
        var toggleView: some View {
            return Toggle(isOn: $isShowing) {
                if isShowing {
                    Text("Toggle On")
                } else {
                    Text("Toggle Off")
                }
            }
        }
        
        var viewHorizontalStack: some View {
            HStack(alignment: .center, spacing: 10) {
            someLabel
            Divider()
            someImage
            Divider()
            someLabel
            }
        }
        
        var viewVerticalStack: some View {
            VStack(alignment: .center, spacing: 10) {
            someBtn
            Divider()
            someBtn
            }
        }
        
        var body : some View {
            VStack(alignment: .center, spacing: 20) {
            viewHorizontalStack
            Divider()
            viewVerticalStack
            Divider()
            toggleView
            Divider()
            Section(header: Text("List.Section.Header"), footer: Text("List.Section.Footer")) { Text("List1.Item_1") }
            someListSample1
            Divider()
            TabView {
                    Text("First View")
                        .font(.title)
                        .tabItem({ Text("First") })
                        .tag(0)
                    Text("Second View")
                        .font(.title)
                        .tabItem({ Text("Second") })
                        .tag(1)
                }
            }
        }
        
    }
}

