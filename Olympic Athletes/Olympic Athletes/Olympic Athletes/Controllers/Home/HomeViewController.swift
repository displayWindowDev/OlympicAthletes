//
//  HomeViewController.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 21/08/23.
//

import UIKit

internal class HomeViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var selectedAthlete: Athlete? = nil
    private lazy var spinnerViewController = SpinnerViewController()

    private lazy var presenter: HomeViewPresenter = {
        return HomePresenter(view: self)
    }()
    
    override
    internal func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Olympic Athletes"
        self.setTableView()
        
        self.presenter.retrieveData()
    }
    
    private func registerTableViewCells() {
        self.tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
    }
    
    private func setTableView() {
        self.registerTableViewCells()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override
    internal func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let athleteDetailsViewController = segue.destination as? AthleteDetailsViewController else { return }
        athleteDetailsViewController.athlete = self.selectedAthlete
    }
    
}

// MARK: - Table View
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    internal func numberOfSections(in tableView: UITableView) -> Int {
        return self.presenter.filteredAthletesPerGame.count
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let homeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }

        let currentGame = self.presenter.filteredAthletesPerGame[indexPath.section].game
        
        let gameAthletes = self.presenter.evaluateAthletes(in: currentGame)
        homeTableViewCell.configure(gameAthletes: gameAthletes)
        homeTableViewCell.homeTableViewCellDelegate = self
        
        return homeTableViewCell
    }

    internal func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(self.presenter.filteredAthletesPerGame[section].game.city ?? "") \(self.presenter.filteredAthletesPerGame[section].game.year ?? 0)"
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280.0
    }

}

// MARK: - HomeView Protocol
extension HomeViewController: HomeView {
    
    internal func showLoader() {
        self.addChild(self.spinnerViewController)
        self.spinnerViewController.view.frame = view.frame
        self.view.addSubview(self.spinnerViewController.view)
        self.spinnerViewController.didMove(toParent: self)
    }
    
    internal func hideLoader() {
        self.spinnerViewController.willMove(toParent: nil)
        self.spinnerViewController.view.removeFromSuperview()
        self.spinnerViewController.removeFromParent()
    }
    
    internal func reloadData() {
        self.tableView.reloadData()
    }
    
    internal func showErrorAlert() {
        let alertController = UIAlertController(title: "Warning", message: "An error occourred fetching the application data.", preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] action in
            self?.presenter.retrieveData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
}

extension HomeViewController: HomeTableViewCellDelegate {
    internal func goToAthleteDetails(athlete: Athlete) {
        self.selectedAthlete = athlete
        self.performSegue(withIdentifier: "toAthleteDetails", sender: nil)
    }
}
