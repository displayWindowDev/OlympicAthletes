//
//  HomeTableViewCell.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 22/08/23.
//

import UIKit

internal protocol HomeTableViewCellDelegate: AnyObject {
    func goToAthleteDetails(athlete: Athlete)
}

internal class HomeTableViewCell: UITableViewCell {

    @IBOutlet private weak var athletesCollectionView: UICollectionView!
    
    internal weak var homeTableViewCellDelegate: HomeTableViewCellDelegate?
    private var gameAthletes: [Athlete] = []

    private func setCollectionView() {
        self.athletesCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")

        self.athletesCollectionView.delegate = self
        self.athletesCollectionView.dataSource = self
        
        let layout = CarouselFlowLayout()
        layout.itemSize = CGSize(width: 250.0, height: 250.0)
        layout.scrollDirection = .horizontal
        
        layout.sideItemAlpha = 0.5
        layout.sideItemScale = 0.5
        layout.spacingMode = .overlap(visibleOffset: 64.0)
        
        self.athletesCollectionView.delegate = self
        self.athletesCollectionView.dataSource = self
        self.athletesCollectionView.setCollectionViewLayout(layout, animated: true)
        self.athletesCollectionView.showsHorizontalScrollIndicator = false
    }
    
    internal func configure(gameAthletes: [Athlete]?) {
        self.gameAthletes = gameAthletes ?? []
        self.athletesCollectionView.reloadData()
    }
    
    override
    internal func awakeFromNib() {
        super.awakeFromNib()
        
        self.setCollectionView()
    }
    
}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gameAthletes.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let athleteCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        guard let imageData = self.gameAthletes[indexPath.item].imageData else { return UICollectionViewCell() }
        
        let athleteName = "\(self.gameAthletes[indexPath.item].name ?? "") \(self.gameAthletes[indexPath.item].surname ?? "")"
        athleteCell.configure(with: athleteName, athletePhoto: UIImage(data: imageData))
        
        return athleteCell
    }

    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.homeTableViewCellDelegate?.goToAthleteDetails(athlete: self.gameAthletes[indexPath.item])
    }
    
    /// To adapt the cell size to its content:
    /// In the collection view size inspector, select "Custom" "Estimate Size" and insert (250, 250)
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250.0, height: 250.0)
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets.init(top: 0.0, left: 16.0, bottom: 16.0, right: 16.0)
    }
    
}
