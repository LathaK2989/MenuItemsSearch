//
//  ReceipeTableViewCell.swift
//  ReceipeSearch
//
//  Created by Srilatha on 2024-09-10.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var receipeDescription: UILabel!
    @IBOutlet weak var recceipeImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var onReuse: (() -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        onReuse?()
    }
    
}
