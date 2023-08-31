//
//  HomePresenter.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 21/08/23.
//

import Foundation

internal typealias RetrieveHomeDataCompletion = ((_ response: HomeData) -> Swift.Void)

internal class HomePresenter: HomeViewPresenter {    
    
    internal weak var view: HomeView?
    
    required internal init(view: HomeView) {
        self.view = view
    }
    
    private let apiClient = APIClient()
    internal var homeData: HomeData? = HomeData()
    
    /// Filter games having athletes that raced into.
    internal var filteredAthletesPerGame: [(game: Game, athletes: [Athlete])] {
        return self.homeData?.athletesPerGame.filter({ element in
            !element.athletes.isEmpty
        }).sorted { $0.game.year ?? 0 > $1.game.year ?? 0 } ?? []
    }
    
    // MARK: - Home Data
    
    /// Retrieves all available games and athletes
    /// - Parameter completion: RetrieveHomeDataCompletion
    internal func retrieveHomeData(completion: @escaping RetrieveHomeDataCompletion) {
        let queue = DispatchGroup()
        let homeData = HomeData()
        
        queue.enter()
        apiClient.send(AthletesRequest()) { [weak homeData] response in
            switch response {
            case .success(let athletes):
                athletes.forEach { athlete in
                    homeData?.athletes.append(athlete)
                }
            case .failure:
                self.view?.showErrorAlert()
            }

            queue.leave()
        }
        
        queue.enter()
        apiClient.send(GamesRequest()) { [weak homeData] response in
            switch response {
            case .success(let games):
                games.forEach { game in
                    homeData?.games.append(game)
                }
            case .failure:
                self.view?.showErrorAlert()
            }

            queue.leave()
        }
        
        queue.notify(queue: .main) {
            completion(homeData)
        }
        
    }
    
    // MARK: - Athletes Data
    
    /// Retrieve athletes photos, results and games they raced
    /// - Parameter completion: RetrieveHomeDataCompletion
    internal func retrieveAthletsData(games: [Game], athletes: [Athlete], completion: @escaping RetrieveHomeDataCompletion) {
        
        let queue = DispatchGroup()
        let homeData = HomeData()
        
        athletes.forEach { athlete in
            queue.enter()
            apiClient.fetchImage(AthletePhotoRequest(athleteId: "\(athlete.photo_id ?? 0)")) { [weak homeData] response in
                
                switch response {
                case .success(let imageData):
                    homeData?.athletesImages.append((athlete: athlete, imageData: imageData))
                case .failure:
                    self.view?.showErrorAlert()
                }

                queue.leave()
            }
        }
        
        athletes.forEach { athlete in
            queue.enter()
            apiClient.send(AthleteResultsRequest(athleteId: "\(athlete.athlete_id ?? "")")) { [weak homeData] response in
                switch response {
                case .success(let results):
                    homeData?.athleteResults.append((athlete: athlete, results: results))
                case .failure:
                    self.view?.showErrorAlert()
                }

                queue.leave()
            }
        }
        
        games.forEach { game in
            queue.enter()
            apiClient.send(GameAthletesRequest(gameId: game.game_id ?? 0)) { [weak homeData] response in
                switch response {
                case .success(let athletes):
                    homeData?.athletesPerGame.append((game: game, athletes: athletes))
                case .failure:
                    self.view?.showErrorAlert()
                }

                queue.leave()
            }
        }
        
        queue.notify(queue: .main) {
            completion(homeData)
        }
    }
    
    // MARK: - All Data

    /// Retrieves all needed data set
    internal func retrieveData() {
        
        self.view?.showLoader()
        
        self.retrieveHomeData { homeData in
            self.homeData?.games = homeData.games.sorted { $0.year ?? 0 > $1.year ?? 0 }
            self.homeData?.athletes = homeData.athletes
            
            self.retrieveAthletsData(games: homeData.games, athletes: homeData.athletes) { homeData in
                self.view?.hideLoader()
                
                self.homeData?.athletesImages = homeData.athletesImages
                self.homeData?.athletesPerGame = homeData.athletesPerGame
                self.homeData?.athleteResults = homeData.athleteResults
                
                self.view?.reloadData()
            }
        }
    }
    
    /// Evaluate an array of athletes for the game provided
    /// - Parameter game: the game for which evaluate the athletes that raced into
    /// - Returns: Athletes that raced in the provided game
    internal func evaluateAthletes(in game: Game) -> [Athlete] {
        var athletes: [Athlete] = []
        
        self.homeData?.athletesPerGame.forEach({ athletesPerGame in
            if athletesPerGame.game == game {
                
                athletes = athletesPerGame.athletes
                
                athletes = athletes.map { athlete in
                    athlete.photo_id == self.homeData?.athletesImages.first(where: { athlete.photo_id == $0.athlete.photo_id })?.athlete.photo_id ?
                    Athlete(athlete_id: athlete.athlete_id,
                            name: athlete.name,
                            surname: athlete.surname,
                            dateOfBirth: athlete.dateOfBirth,
                            bio: athlete.bio,
                            weight: athlete.weight,
                            height: athlete.height,
                            photo_id: athlete.photo_id,
                            imageData: self.homeData?.athletesImages.first(where: { athlete.photo_id == $0.athlete.photo_id })?.imageData,
                            results: self.homeData?.athleteResults.first(where: { athlete.athlete_id == $0.athlete.athlete_id })?.results) :
                    athlete
                }
            }
        })
        
        athletes = self.sortByResult(athletes: athletes)

        return athletes
    }
    
    internal func sortByResult(athletes: [Athlete]) -> [Athlete] {
        
        var sortedAthletes: [Athlete] = []
        var resultsPerAthlets: [(athlete: Athlete, score: Int)] = []
        
        for athlete in athletes {
            guard let results = athlete.results else { break }
            
            for result in results {
                if resultsPerAthlets.contains(where: { $0.athlete == athlete }) { continue }

                let score: Int = (result.gold ?? 0) + (result.silver ?? 0) + (result.bronze ?? 0)
                resultsPerAthlets.append((athlete: athlete, score: score))
            }
        }
        
        resultsPerAthlets.sort { $0.score > $1.score }

        resultsPerAthlets.forEach { element in
            sortedAthletes.append(element.athlete)
        }

        return sortedAthletes
    }
    
}
