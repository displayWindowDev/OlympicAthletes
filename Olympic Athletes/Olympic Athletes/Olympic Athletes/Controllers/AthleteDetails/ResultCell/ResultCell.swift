//
//  ResultCell.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 29/08/23.
//

import UIKit

internal class ResultCell: UITableViewCell {
    
    @IBOutlet private weak var gameLabel: UILabel!
    
    @IBOutlet private weak var goldMedal: MedalView!
    @IBOutlet private weak var silverMedal: MedalView!
    @IBOutlet private weak var bronzeMedal: MedalView!
    
    internal func configure(athleteResult: AthleteResut) {
        self.gameLabel.text = athleteResult.city
        
        if athleteResult.gold == 0 {
            self.goldMedal.alpha = 0.0
        } else {
            self.goldMedal.configure(medal: .gold, medalCount: athleteResult.gold ?? 0)
        }
        
        if athleteResult.silver == 0 {
            self.silverMedal.alpha = 0.0
        } else {
            self.silverMedal.configure(medal: .silver, medalCount: athleteResult.silver ?? 0)
        }
        
        if athleteResult.bronze == 0 {
            self.bronzeMedal.alpha = 0.0
        } else {
            self.bronzeMedal.configure(medal: .bronze, medalCount: athleteResult.bronze ?? 0)
        }
        
    }
}
