//
//  IssueView.swift
//  bugBook
//
//  Created by SaTHYa on 05/04/17.
//  Copyright © 2017 Sathya. All rights reserved.
//

import UIKit

class IssueView: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.setTitleCellTheme()
        bodyLabel.setBodyCellTheme()
    }

    
    func setDefaults(title: String, body: String ) {
        titleLabel.text = title
        bodyLabel.text = body
    }
}

extension UILabel {

    

}