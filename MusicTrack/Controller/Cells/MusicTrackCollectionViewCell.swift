//
//  MusicTrackCollectionViewCell.swift
//  MusicTrack
//
//  Created by Neosoft on 22/01/24.
//

import UIKit

class MusicTrackCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var musicTrackImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func collectionCellIdentifier() -> String {
            return "MusicTrackCollectionViewCell"
   }

}
