//
//  FeedViewController.swift
//  Fuud
//
//  Created by Sandra Yee on 10/26/22.
//

import UIKit
import AlamofireImage
import Koloda

class FeedViewController: UIViewController {
    
    // array of restaurants sorted through
    var restaurantsArray: [[String:Any?]] = []
    
    @IBOutlet weak var restaurantCardView: KolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantCardView.delegate = self
        restaurantCardView.dataSource = self
        getAPIData()
    }
    
    //Button to use instead of a swipe right
    @IBAction func likePressed(_ sender: Any) {
        restaurantCardView.swipe(.right)
    }
    
    //Button to use instead of a swipe left
    @IBAction func dislikePressed(_ sender: Any) {
        restaurantCardView.swipe(.left)
    }
    
    // API call for restaurants
    func getAPIData() {
        API.getRestaurants() { (restaurants) in
            guard let restaurants = restaurants else {
                return
            }
            self.restaurantsArray = restaurants
            self.restaurantCardView.reloadData()
        }
    }
}

// View Delegate group
extension FeedViewController: KolodaViewDelegate {
    
    //What to do when we run out of cards (This needs to be integrated with infinite scroll
    //along with continuous API calls, but I don't know how to do this at the moment
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        restaurantCardView.reloadData()
    }
    
    // A rough draft test of what to do when a card is clicked. This just leads to Google
    //func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
    //    UIApplication.shared.openURL(URL(string: "https://google.com/")!)
    //}
    
    // Koloda method for what to do when a card is clicked. This creates a pop up with arbitrary text
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        let alert = UIAlertController(title: "Added!", message: "Added to Favorites :)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
    }
}

// View Datasource group
extension FeedViewController: KolodaViewDataSource {
    
    // Koloda method for casting a view. Casting custom designed ProjectedCell. 
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let cell = ProjectedCell()
        let restaurant = restaurantsArray[index]
        
        // Set name and phone of cell label
        cell.nameLabel.text = restaurant["name"] as? String
        cell.phoneLabel.text = restaurant["display_phone"] as? String
        
        // Get reviews
        let reviews = restaurant["review_count"] as? Int
        cell.reviewsLabel.text = String(reviews!)
        
        // Get categories
        let categories = restaurant["categories"] as! [[String: Any]]
        cell.categoryLabel.text = categories[0]["title"] as? String
        
        // Set stars images
        let reviewDouble = restaurant["rating"] as! Double
        cell.starsImage.image = Stars.dict[reviewDouble]!
        
        // Set Image of restaurant
        if let imageUrlString = restaurant["image_url"] as? String {
            let imageUrl = URL(string: imageUrlString)
            cell.restaurantImage.af.setImage(withURL: imageUrl!)
        }
        return cell // sorting
    }

    //Koloda method to set swipe speed
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast // fast swiping
    }

    //Koloda method for determining the number of cards, using count on restaurants array
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return restaurantsArray.count // images count
    }
}
