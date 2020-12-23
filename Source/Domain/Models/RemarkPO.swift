//  Copyright © 2020 Saqib Saud. All rights reserved.

import Foundation

struct RemarkPO {
    let userName: String?
    var note: String?
    var coordinate: Coordinate?

    init(withUserName userName: String?,
         note: String?,
         latitude: Double?,
         longitude: Double?) {
        self.userName = userName
        self.note = note

        if let latitude =  latitude, let longitude = longitude {
            coordinate = Coordinate(latitude: latitude, longitude: longitude)
        } else {
            coordinate = nil
        }
    }

    init() {
        userName = nil
        note = nil
        coordinate = nil
    }

    struct Coordinate {
        let latitude: Double
        let longitude: Double

        init(withLatitude latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }

        init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
        }
    }
}
