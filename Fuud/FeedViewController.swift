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
    
    // cities array already sorted based on proximity to user-city-input
    var citiesArray: [String] = []
    
    @IBOutlet weak var restaurantCardView: KolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantCardView.delegate = self
        restaurantCardView.dataSource = self
        getAPIData()
        
        // slow down getCityId API call to happen after fetching Restaurants API
        DispatchQueue.main.asyncAfter(deadline: .now() + 2)
        {
            API.getCityId()
        }
        
        // slow down getNearbyCities API call to happen after fetching Restaurants --> Current City ID
        DispatchQueue.main.asyncAfter(deadline: .now() + 3)
        {
            self.getCitiesAPIData()
        }
        
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
            print("Get API Data called")
        }
    }
    
    // API call for nearby cities
    func getCitiesAPIData() {
        API.getNearbyCities() { (cities) in
            guard let cities = cities else {
                return
            }
            self.citiesArray = cities
            print("Get Cities API Data called")
            print("From FeedViewController.swift: The closest city names array in order is \(self.citiesArray)")
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SegueToDetails" {
        print("preparing Data")
        let r = restaurantsArray[currentIndex - 2]
        let detailViewController = segue.destination as! FeedViewDetailsController
            detailViewController.r = r
        }
        if segue.identifier == "SegueToFavorites" {
            print("favorites segue worked")
//            let r = restaurantsArray[currentIndex - 2]
//            let favoritesVC = segue.destination as! FavoritesViewController
//                favoritesVC.restaurant = r
        }
    }
    
    //function for user to logout
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {return}
        
        delegate.window?.rootViewController = loginViewController
        
    }
}

// View Delegate group
extension FeedViewController: KolodaViewDelegate {
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == .right {
            let selectedRestaurantId = restaurantsArray[currentIndex - 3].id

            let selectedRestaurant = PFObject(className: "Favorite_Restaurants")
            
            selectedRestaurant["User"] = PFUser.current()!
            selectedRestaurant["Restaurant_id"] = selectedRestaurantId
            
            // added this to store restaurant name inside Parse
            selectedRestaurant["Restaurant_name"] = restaurantsArray[currentIndex-3].name
            
            
            // convert NSURL to string in order to save in Parse
            let rest_imageURL: String = restaurantsArray[currentIndex-3].imageURL!.absoluteString
            // store restaurant image url in Parse
            selectedRestaurant["Restaurant_image_url"] = rest_imageURL
            
            
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
    // for now we just had index reset so when user does reach the end, stack resets
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        
        // ******************************** Infinite Scroll using City Name ********************************
        print("current city card stack ran out of cards")
        
        // ******************** Reset the current city to its nearest city ********************
        
        // cities array has to have available cities
        if (citiesArray.count > 0) {
            
            // grab the first (closest) city to Current City
            let closest_city = citiesArray.removeFirst()
            
            print("next city in queue is \(closest_city)")
            
            
            
            
            // Overwrite the current city with new city in UserDefaults for new location
//            UserDefaults.standard.set("Pasadena", forKey: "userLocation")
            
            // CHANGE INTO vvvvvv once I transform the User Input city into a wikiDataId or City Id
            UserDefaults.standard.set(closest_city, forKey: "userLocation")
            
            // **************** Ignore: Checks what is current city *******************
            let current_location = UserDefaults.standard.string(forKey: "userLocation")
            print("current location is \(current_location!)")
            // ****************************************************************************************
            // At this point, new City name is loaded into UserDefaults
            // **************************************************************************************
            
            // ********* get API response for the new City and populate restaurant array ***********
            getAPIData()

            // slows the execution of code inside block to run after getAPIData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45)
            {
                // resets card stack with new location restaurants
                self.restaurantCardView.resetCurrentCardIndex()
                self.restaurantCardView.reloadData()
            }
            print("the number of cards after calling Koloda num of cards is \(kolodaNumberOfCards(koloda))")
            print("card view was reloaded")
            print(citiesArray)
            }
        else {
            print("no more cities... end program")
        }
    }
    
    
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
