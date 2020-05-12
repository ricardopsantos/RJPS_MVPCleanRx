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
    
    struct SampleB_SwiftUITesting: View {
      
        @State var detail: ModalDetail?
        var viewPresentModel: some View {
            Button("Present Model") { self.detail = ModalDetail(body: "Details!")
            }.sheet(item: $detail, content: { detail in self.modal(detail: detail.body) })
        }
        func modal(detail: String) -> some View { Text(detail) }
        struct ModalDetail: Identifiable {
            var id: String { return body }
            let body: String
        }
        
        var body: some View {
            return viewPresentModel
        }
    }
}
