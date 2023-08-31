//
//  HomeData.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 21/08/23.
//

import Foundation

public class HomeData: NSObject {
    /// All games
    internal var games: [Game] =  []
    /// All athletes
    internal var athletes: [Athlete] = []

    internal var athletesPerGame: [(game: Game, athletes: [Athlete])] = []
    internal var athletesImages: [(athlete: Athlete, imageData: Data)] = []
    internal var athleteResults: [(athlete: Athlete, results: [AthleteResut])] = []
    
    override internal init() {}
}
