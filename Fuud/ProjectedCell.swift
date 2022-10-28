//
//  ProjectedCell.swift
//  Fuud
//
//  Created by Larry Urrego on 10/27/22.
//

import UIKit

class ProjectedCell: UIView {

    // View used to cast this customer UI
    var view: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var starsImage: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setUp() {
        let view = Bundle.main.loadNibNamed("ProjectedCell", owner: self)![0] as! UIView
        view.frame = self.bounds
        
        addSubview(view)
    }
}
