//
//  FeedViewController.swift
//  Fuud
//
//  Created by Sandra Yee on 10/26/22.
//

import UIKit
import AlamofireImage
import Koloda
import Parse

class FeedViewController: UIViewController {
    
    // array of restaurants sorted through
    var restaurantsArray: [Restaurant] = []
    var currentIndex: Int = 0
    
    @IBOutlet weak var restaurantCardView: KolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restaurantCardView.delegate = self
        restaurantCardView.dataSource = self
        getAPIData()
    }
    
    //Button to use instead of a swipe right
    @IBAction func likePressed(_ sender: Any) {
        
        // send an alert to user that added to favorites
        let alert = UIAlertController(title: "Added to Favorites!", message: "Added \(restaurantsArray[currentIndex - 2].name) to Favorites :)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
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
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("preparing Data")
        let r = restaurantsArray[currentIndex - 2]
        let detailViewController = segue.destination as! FeedViewDetailsController
            detailViewController.r = r
    }
}

// View Delegate group
extension FeedViewController: KolodaViewDelegate {
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == .right {
            let selectedRestaurantId = restaurantsArray[currentIndex - 2].id
            print(restaurantsArray[currentIndex - 2].id)
            let selectedRestaurant = PFObject(className: "Favorite_Restaurants")
            
            selectedRestaurant["User"] = PFUser.current()!
            selectedRestaurant["Restaurant_id"] = selectedRestaurantId
            
            selectedRestaurant.saveInBackground {(success, error) in
                if success {
                    print("Saved favorited restaurant successfully to Parse!")
                    // send an alert to user that added to favorites
                    let alert = UIAlertController(title: "Added to Favorites!", message: "Added \(self.restaurantsArray[self.currentIndex - 3].name) to Favorites :)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                } else {
                    print("Error! Could not save")
                }
                
            }
        }
    }
    
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

        //let controller = storyboard?.instantiateViewController(withIdentifier: "FeedViewDetailsController")
        //controller.detailedView.addSubview(ProjectedCell)
        
        //self.present(controller!, animated: true, completion: nil)
        self.performSegue(withIdentifier: "SegueToDetails", sender: nil)
    }
}

// View Datasource group
extension FeedViewController: KolodaViewDataSource {
    
    // Koloda method for casting a view. Casting custom designed ProjectedCell. 
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let cell = ProjectedCell()
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 20
        let restaurant = restaurantsArray[index]
        currentIndex = index
        //print("This is the current index:\(currentIndex)")
        cell.r = restaurant
        
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
