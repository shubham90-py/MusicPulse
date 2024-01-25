//
//  MusicTrackTableViewCell.swift
//  MusicTrack
//
//  Created by Neosoft on 23/01/24.
//

import UIKit

class MusicTrackTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView! {
        didSet {
            coverImageView.layer.cornerRadius = coverImageView.frame.size.width / 2
            coverImageView.clipsToBounds = true
            
        }
    }
    @IBOutlet weak var lblTitleName: UILabel!
    @IBOutlet weak var lblArtisttDetailName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
