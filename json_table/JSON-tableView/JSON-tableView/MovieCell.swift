//
//  MovieCell.swift
//  JSON-tableView
//
//  Created by 박세라 on 2022/03/11.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
