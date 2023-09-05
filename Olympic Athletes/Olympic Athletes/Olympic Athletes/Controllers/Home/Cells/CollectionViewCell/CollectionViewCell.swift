//
//  CollectionViewCell.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 22/08/23.
//

import UIKit

internal class CollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    
    @IBOutlet private weak var athletePhoto: UIImageView!
    @IBOutlet private weak var athleteNameLabel: UILabel!
    @IBOutlet private weak var athleteSurnameLabel: UILabel!

    @IBOutlet private weak var goldMedalView: MedalView!
    @IBOutlet private weak var silverMedalView: MedalView!
    @IBOutlet private weak var bronzeMedalView: MedalView!

    override
    internal func awakeFromNib() {
        super.awakeFromNib()

        self.containerView.layer.cornerRadius = 125.0
        self.athletePhoto.layer.cornerRadius = 75.0
    }

    override
    internal func prepareForReuse() {
        self.athletePhoto.image = nil
        self.athleteNameLabel.text = nil
        self.athleteSurnameLabel.text = nil
        
        self.goldMedalView.alpha = 1.0
        self.silverMedalView.alpha = 1.0
        self.bronzeMedalView.alpha = 1.0
    }
    
    internal func configure(with athlete: Athlete, athletePhoto: UIImage?) {
        DispatchQueue.main.async {
            self.athletePhoto.image = athletePhoto
        }
        
        self.athleteNameLabel.text = athlete.name
        self.athleteSurnameLabel.text = athlete.surname?.uppercased()
        
        var goldMedals: Int = 0
        var silverMedals: Int = 0
        var bronzeMedals: Int = 0

        athlete.results?.forEach({ result in
            goldMedals += result.gold ?? 0
            silverMedals += result.silver ?? 0
            bronzeMedals += result.bronze ?? 0
        })
        
        if goldMedals == 0 {
            self.goldMedalView.alpha = 0.0
        } else {
            self.goldMedalView.configure(medal: .gold, medalCount: goldMedals)
        }
        
        if silverMedals == 0 {
            self.silverMedalView.alpha = 0.0
        } else {
            self.silverMedalView.configure(medal: .silver, medalCount: silverMedals)
        }
        
        if bronzeMedals == 0 {
            self.bronzeMedalView.alpha = 0.0
        } else {
            self.bronzeMedalView.configure(medal: .bronze, medalCount: bronzeMedals)
        }
    }

}
