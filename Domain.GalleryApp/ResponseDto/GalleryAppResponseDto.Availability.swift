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

public extension GalleryAppResponseDto {
    struct Availability: ResponseDtoProtocol {
        public let photos: GalleryAppResponseDto.Photos
        public let stat: String
    }
}

public extension GalleryAppResponseDto {
    struct Photos: ResponseDtoProtocol {
        public let page, pages, perpage: Int
        public let total: String
        public let photo: [GalleryAppResponseDto.Photo]
    }
}

public extension GalleryAppResponseDto {
    struct Photo: ResponseDtoProtocol {
        public let id, owner, secret, server: String
        public let farm: Int
        public let title: String
        public let ispublic, isfriend, isfamily: Int
    }
}
