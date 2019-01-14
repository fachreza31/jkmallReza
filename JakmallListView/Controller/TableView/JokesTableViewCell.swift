//
//  JokesTableViewCell.swift
//  JakmallListView
//
//  Created by Fachreza Audrian Naufal on 1/12/19.
//  Copyright © 2019 Fachreza Audrian Naufal. All rights reserved.
//

import UIKit

class JokesTableViewCell: UITableViewCell {

    @IBOutlet weak var jokesText: UILabel!
    
    @IBOutlet weak var jokesButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        jokesText.showAnimatedSkeleton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func hideAnimation(){
        jokesText.hideSkeleton()
    }
    
}
