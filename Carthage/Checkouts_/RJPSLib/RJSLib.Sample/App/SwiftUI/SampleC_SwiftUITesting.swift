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
    
    struct SampleC_SwiftUITesting: View {
      
        var body : some View {
            VStack(alignment: .center, spacing: 20) {
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
