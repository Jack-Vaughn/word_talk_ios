//
//  WordTableViewCell.swift
//  Word Talk Test
//
//  Created by Jack Vaughn on 4/14/20.
//  Copyright © 2020 vaughn0523. All rights reserved.
//

import UIKit

class WordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
