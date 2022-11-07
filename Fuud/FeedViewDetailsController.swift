//
//  FeedViewDetailsController.swift
//  Fuud
//
//  Created by Larry Urrego on 10/30/22.
//

import UIKit
import AlamofireImage
import MapKit
import CoreLocation

class FeedViewDetailsController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var detailedView: UIView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starsImage: UIImageView!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    
    
    var r: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantImage.af.setImage(withURL: r.imageURL!)
        nameLabel.text = r.name
        phoneLabel.text = r.phone
        categoryLabel.text = r.mainCategory
        ratingsLabel.text = String(r.reviews) + " reviews"
        starsImage.image = Stars.dict[r.rating]!
        print(r.street)
        addressLabel.text = "\(r.street[0]), \(r.street[1])" as? String
        print("Latitude: \(r.latitude)")
        print("longitude: \(r.longitude)")
        
        // Annotation of map pin to display lat and long + restaurant name and category
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = CLLocationCoordinate2D(latitude: r.latitude, longitude: r.longitude)
        annotation1.title = r.name
        annotation1.subtitle = r.mainCategory
        self.mapView.addAnnotation(annotation1)
        mapView.centerCoordinate = annotation1.coordinate
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
      

    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
