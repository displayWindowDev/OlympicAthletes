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
    /// A list of game with the relative athletes that competed into
    internal var athletesPerGame: [(game: Game, athletes: [Athlete])] = []
    /// A list of athletes with their relative photo data
    internal var athletesImages: [(athlete: Athlete, imageData: Data)] = []
    /// A list of athletes with their relative career results
    internal var athleteResults: [(athlete: Athlete, results: [AthleteResut])] = []
    
    override internal init() {}
}
