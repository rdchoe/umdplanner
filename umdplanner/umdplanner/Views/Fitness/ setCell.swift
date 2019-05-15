//
//   setCell.swift
//  umdplanner
//
//  Created by Robert Choe on 4/25/19.
//  Copyright © 2019 group42. All rights reserved.
//

import Foundation
import MaterialComponents.MaterialButtons
import UIKit

class setCell: UICollectionViewCell {

    @IBOutlet weak var set: MDCButton!
    var max: Int!
    
    @IBAction func setPressed(_ sender: MDCButton) {
        var curr = Int((set.titleLabel?.text)!)!
        curr += 1
        if curr > self.max {
            set.setTitle("0", for: .normal)
        } else {
            set.setTitle(String(curr), for: .normal)
        }
        
    
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    /*
     init()  {
        )
        print("cell set")
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
 */
    
}
