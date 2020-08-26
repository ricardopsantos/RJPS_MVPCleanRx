//
//  Created by Ricardo Santos on 25/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation

//
//  Created by Ricardo Santos on 25/08/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import DevTools
//
import Domain

public extension GalleryAppModel {
    struct Availability: ModelEntityProtocol {
        public let photos: GalleryAppModel.Photos
        public let stat: String
    }
}

public extension GalleryAppModel {
    struct Photos: ModelEntityProtocol {
        public let page, pages, perpage: Int
        public let total: String
        public let photo: [GalleryAppModel.Photo]
    }
}

public extension GalleryAppModel {
    struct Photo: ModelEntityProtocol {
        public let id, owner, secret, server: String
        public let farm: Int
        public let title: String
        public let ispublic, isfriend, isfamily: Int
    }
}
