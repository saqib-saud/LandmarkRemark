//  Copyright © 2020 Saqib Saud. All rights reserved.

import MapKit

class Remark: NSObject, MKAnnotation {
    let userName: String
    let note: String?
    let coordinate: CLLocationCoordinate2D
    
    init(userName: String,
        remark: String,
        coordinate: CLLocationCoordinate2D) {
        self.userName = userName
        self.note = remark
        self.coordinate = coordinate
        
        super.init()
    }
    
    init(remarkPO: RemarkPO) {
        self.userName = remarkPO.userName ?? ""
        self.note = remarkPO.note
        let coordinate = remarkPO.coordinate
        self.coordinate = CLLocationCoordinate2D(latitude: coordinate?.latitude ?? 0.0, longitude: coordinate?.longitude ?? 0.0)
        
        super.init()
    }
    
    var title: String? {
        return userName
    }
    
    var subtitle: String? {
        return note
    }
}
