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
    
    required
    internal init(view: HomeView) {
        self.view = view
    }
    
    private let apiClient = APIClient()
    internal var homeData: HomeData? = HomeData()
    
    /// Filter games having athletes that raced into.
    internal var filteredAthletesPerGame: [(game: Game, athletes: [Athlete])] {
        self.homeData?.athletesPerGame.filter({ element in
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
        apiClient.send(AthletesRequest()) { [weak homeData, weak self] response in
            switch response {
            case .success(let athletes):
                athletes.forEach { athlete in
                    homeData?.athletes.append(athlete)
                }
            case .failure:
                self?.view?.showErrorAlert()
            }

            queue.leave()
        }
        
        queue.enter()
        apiClient.send(GamesRequest()) { [weak homeData, weak self] response in
            switch response {
            case .success(let games):
                games.forEach { game in
                    homeData?.games.append(game)
                }
            case .failure:
                self?.view?.showErrorAlert()
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
    internal func retrieveAthletesData(games: [Game], athletes: [Athlete], completion: @escaping RetrieveHomeDataCompletion) {
        
        let queue = DispatchGroup()
        let homeData = HomeData()
        
        athletes.forEach { athlete in
            queue.enter()
            apiClient.fetchImage(AthletePhotoRequest(athleteId: "\(athlete.photoId ?? 0)")) { [weak homeData, weak self] response in
                
                switch response {
                case .success(let imageData):
                    homeData?.athletesImages.append((athlete: athlete, imageData: imageData))
                case .failure:
                    self?.view?.showErrorAlert()
                }

                queue.leave()
            }
        }
        
        athletes.forEach { athlete in
            queue.enter()
            apiClient.send(AthleteResultsRequest(athleteId: "\(athlete.athleteId ?? "")")) { [weak homeData, weak self] response in
                switch response {
                case .success(let results):
                    homeData?.athleteResults.append((athlete: athlete, results: results))
                case .failure:
                    self?.view?.showErrorAlert()
                }

                queue.leave()
            }
        }
        
        games.forEach { game in
            queue.enter()
            apiClient.send(GameAthletesRequest(gameId: game.gameId ?? 0)) { [weak homeData, weak self] response in
                switch response {
                case .success(let athletes):
                    homeData?.athletesPerGame.append((game: game, athletes: athletes))
                case .failure:
                    self?.view?.showErrorAlert()
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
        
        self.retrieveHomeData { [weak self] homeData in
            self?.homeData?.games = homeData.games.sorted { $0.year ?? 0 > $1.year ?? 0 }
            self?.homeData?.athletes = homeData.athletes
            
            self?.retrieveAthletesData(games: homeData.games, athletes: homeData.athletes) { [weak self] homeData in
                self?.view?.hideLoader()
                
                self?.homeData?.athletesImages = homeData.athletesImages
                self?.homeData?.athletesPerGame = homeData.athletesPerGame
                self?.homeData?.athleteResults = homeData.athleteResults
                
                self?.view?.reloadData()
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
                    athlete.photoId == self.homeData?.athletesImages.first(where: { athlete.photoId == $0.athlete.photoId })?.athlete.photoId ?
                    Athlete(athleteId: athlete.athleteId,
                            name: athlete.name,
                            surname: athlete.surname,
                            dateOfBirth: athlete.dateOfBirth,
                            bio: athlete.bio,
                            weight: athlete.weight,
                            height: athlete.height,
                            photoId: athlete.photoId,
                            imageData: self.homeData?.athletesImages.first(where: { athlete.photoId == $0.athlete.photoId })?.imageData,
                            results: self.homeData?.athleteResults.first(where: { athlete.athleteId == $0.athlete.athleteId })?.results) :
                    athlete
                }
            }
        })
        
        athletes = self.sortByResult(athletes: athletes)

        return athletes
    }
    
    /// Sorts the provided array of athletes by their overall score
    /// - Parameter athletes: Array of Athletes to be sorted
    /// - Returns: Sorted array of Athletes
    internal func sortByResult(athletes: [Athlete]) -> [Athlete] {
        
        var sortedAthletes: [Athlete] = []
        var resultsPerAthletes: [(athlete: Athlete, score: Int)] = []
        
        for athlete in athletes {
            guard let results = athlete.results else { break }
            
            for result in results {
                if resultsPerAthletes.contains(where: { $0.athlete == athlete }) {
                    let score: Int = self.evaluateScore(result: result)
                    if let index = resultsPerAthletes.firstIndex(where: { $0.athlete.athleteId == athlete.athleteId }) {
                        resultsPerAthletes[index].score += score
                    }
                    continue
                }

                let score: Int = self.evaluateScore(result: result)
                resultsPerAthletes.append((athlete: athlete, score: score))
            }
        }
        
        resultsPerAthletes.sort { $0.score > $1.score }

        resultsPerAthletes.forEach { element in
            sortedAthletes.append(element.athlete)
        }

        return sortedAthletes
    }
    
    /// Evaluates the athlete score
    /// - Parameter result: Athlete career results
    /// - Returns: Athlete score
    private func evaluateScore(result: AthleteResut) -> Int {
        ((result.gold ?? 0) * 5) + ((result.silver ?? 0) * 3) + (result.bronze ?? 0)
    }
    
}
