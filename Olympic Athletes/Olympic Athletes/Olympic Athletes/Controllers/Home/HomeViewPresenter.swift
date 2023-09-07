//
//  HomeViewPresenter.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 21/08/23.
//

internal protocol HomeViewPresenter: AnyObject {
    init(view: HomeView)
   
    var filteredAthletesPerGame: [(game: Game, athletes: [Athlete])] { get }
    
    func retrieveData()
    func evaluateAthletes(in game: Game) -> [Athlete]
}

internal protocol HomeView: AnyObject {
    func showLoader()
    func hideLoader()
    func reloadData()
    func showErrorAlert()
}
