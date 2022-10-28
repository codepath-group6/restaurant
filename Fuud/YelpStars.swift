//
//  YelpStars.swift
//  Fuud
//
//  Created by Larry Urrego on 10/27/22.
//

import Foundation
import UIKit

// To call image
struct Stars {
    
    static let dict = [
        0: Stars.zero,
        1: Stars.one,
        1.5: Stars.oneHalf,
        2: Stars.two,
        2.5: Stars.twoHalf,
        3: Stars.three,
        3.5: Stars.threeHalf,
        4: Stars.four,
        4.5: Stars.fourHalf,
        5: Stars.five
    ]
    
    
    static let zero = UIImage(named: "regular_0")
    static let one = UIImage(named: "regular_1")
    static let oneHalf = UIImage(named: "regular_1_half")
    static let two = UIImage(named: "regular_2")
    static let twoHalf = UIImage(named: "regular_2_half")
    static let three = UIImage(named: "regular_3")
    static let threeHalf = UIImage(named: "regular_3_half")
    static let four = UIImage(named: "regular_4")
    static let fourHalf = UIImage(named: "regular_4_half")
    static let five = UIImage(named: "regular_5")
    
        
}
