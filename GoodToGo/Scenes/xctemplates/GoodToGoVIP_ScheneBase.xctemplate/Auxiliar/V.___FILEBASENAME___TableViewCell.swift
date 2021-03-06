//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Foundation
//
import RxCocoa
import RxSwift
import RxDataSources
//
import BaseConstants
import AppTheme
import Designables
import DevTools
import BaseDomain
import Extensions
import BaseUI

protocol ___VARIABLE_sceneName___TableViewCellProtocol: GenericTableViewCellProtocol {
    //var rxBehaviorRelay_title: BehaviorRelay<String> { get set }
    //var rxBehaviorRelay_image: BehaviorRelay<UIImage?> { get set }
    //func bindWith(viewModel:VM.___VARIABLE_sceneName___.TableItem)
}

extension V {
    public class ___VARIABLE_sceneName___TableViewCell: DefaultTableViewCell {
        func configWith(viewModel: VM.___VARIABLE_sceneName___.TableItem) {
            self.set(title: viewModel.subtitle)
        }
    }
}

// MARK: - TableViewCellProtocol
extension V.___VARIABLE_sceneName___TableViewCell: ___VARIABLE_sceneName___TableViewCellProtocol {

}
