//
//  Created by Ricardo P Santos on 23/06/2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

protocol GenericPresenter_Protocol {
    var genericView: GenericView { get }
    func view_deinit()
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
}
