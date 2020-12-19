//  Copyright © 2020 Saqib Saud. All rights reserved.

import MapKit

class RemarkView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

            frame = CGRect(x: 0, y: 0, width: 40, height: 50)
            centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)

            canShowCallout = true
        }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
  override var annotation: MKAnnotation? {
    willSet {
      guard let artwork = newValue as? Remark else {
        return
      }

      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      
      
      let detailLabel = UILabel()
      detailLabel.numberOfLines = 0
      detailLabel.font = detailLabel.font.withSize(12)
      detailLabel.text = artwork.subtitle
      detailCalloutAccessoryView = detailLabel
    }
  }
}


class Remark: NSObject, MKAnnotation {
    let userName: String
    let remark: String?
    let coordinate: CLLocationCoordinate2D
    
    init(userName: String,
        remark: String,
        coordinate: CLLocationCoordinate2D) {
        self.userName = userName
        self.remark = remark
        self.coordinate = coordinate
        
        super.init()
    }
    
    init(remarkPO: RemarkPO) {
        self.userName = remarkPO.userName ?? ""
        self.remark = remarkPO.note
        let coordinate = remarkPO.coordinate
        self.coordinate = CLLocationCoordinate2D(latitude: coordinate?.latitude ?? 0.0, longitude: coordinate?.longitude ?? 0.0)
        
        super.init()
    }
    
    var title: String? {
        return userName
    }
    
    var subtitle: String? {
        return remark
    }
}
