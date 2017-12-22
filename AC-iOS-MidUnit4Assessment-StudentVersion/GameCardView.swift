//
//  GameCardView.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Lisa J on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class GameCardView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
   
    required init?(coder aDecoder: NSCoder) { //Storyboard init
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("GameCardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }
    func configureSelf(from randomCard: RandomCard) {
        ImageAPIClient.manager.getImage(from: randomCard.cards[0].images.png,

                                         completionHandler: {
                                            self.imageView.image = $0
                                            self.imageView.setNeedsLayout()
                                            self.valueLabel.text = "\(randomCard.cards[0].value)"
                                            self.isHidden = false
        },
                                         errorHandler: {print($0)})
    }

}
