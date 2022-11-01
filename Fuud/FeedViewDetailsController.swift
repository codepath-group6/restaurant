//
//  FeedViewDetailsController.swift
//  Fuud
//
//  Created by Larry Urrego on 10/30/22.
//

import UIKit
import AlamofireImage

class FeedViewDetailsController: UIViewController {
    
    @IBOutlet weak var detailedView: UIView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starsImage: UIImageView!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
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
        // Do any additional setup after loading the view.
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
