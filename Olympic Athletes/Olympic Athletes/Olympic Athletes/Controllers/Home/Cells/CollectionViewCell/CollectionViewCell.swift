//
//  CollectionViewCell.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 22/08/23.
//

import UIKit

internal class CollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var athletePhoto: UIImageView!
    @IBOutlet private weak var athleteInfoLabel: UILabel!
    
    override
    internal func prepareForReuse() {
        self.athletePhoto.image = nil
        self.athleteInfoLabel.text = nil
    }
    
    override
    internal func awakeFromNib() {
        self.athletePhoto.layer.cornerRadius = 75.0
    }
    
    internal func configure(with athleteName: String, athletePhoto: UIImage?) {
        DispatchQueue.main.async {
            self.athletePhoto.image = athletePhoto
        }
        self.athleteInfoLabel.text = athleteName.uppercased()
    }

}
