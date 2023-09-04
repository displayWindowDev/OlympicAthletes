//
//  AthleteDetailsViewController.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 28/08/23.
//

import UIKit
import WebKit
import SwiftUI

internal class AthleteDetailsViewController: UIViewController {

    @IBOutlet private weak var athleteImageView: UIImageView!

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var dateOfBirthLabel: UILabel!
    @IBOutlet private weak var weightLabel: UILabel!
    @IBOutlet private weak var heightLabel: UILabel!
    
    @IBOutlet private weak var resultsTableView: UITableView!
    
    @IBOutlet private weak var webViewContainer: UIView!
    @IBOutlet private weak var tableViewHeightContraint: NSLayoutConstraint!
    
    internal var athlete: Athlete? = nil

    private lazy var presenter: AthleteDetailsViewPresenter = {
        return AthleteDetailsPresenter(view: self)
    }()
    
    private var webView: WKWebView!
    private var tableViewHeight: CGFloat {
        52.0 * CGFloat(self.athlete?.results?.count ?? 0)
    }
    
    override
    internal func viewDidLoad() {
        super.viewDidLoad()
                
        self.athleteImageView.layer.cornerRadius = 75.0
        
        self.setTableView()
        self.setWebView()

        if let athlete {
            self.title = "\(athlete.name ?? "") \(athlete.surname ?? "") details"
            self.setDetails(athlete: athlete)
        }
        
        /// P.N. in this exemple a generic video identifier is passed, to show a video relative to the athlete itself a specific id is required for each athlete, maybe from the API
        self.presenter.loadVideo(id: "VdHHus8IgYA")
    }

    override
    internal func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tableViewHeightContraint.constant = self.tableViewHeight
    }
    
    private func setTableView() {
        self.registerTableViewCells()
        self.resultsTableView.delegate = self
        self.resultsTableView.dataSource = self
    }
    
    private func registerTableViewCells() {
        self.resultsTableView.register(UINib(nibName: "ResultCell", bundle: nil), forCellReuseIdentifier: "ResultCell")
    }
    
    private func setDetails(athlete: Athlete) {
        if let imageData = athlete.imageData {
            DispatchQueue.main.async {
                self.athleteImageView.image = UIImage(data: imageData)
            }
        }
        
        self.nameLabel.text = "\(athlete.name ?? "") \(athlete.surname ?? "")"
        self.dateOfBirthLabel.text = "\(athlete.dateOfBirth ?? "")"
        self.weightLabel.text = "\(athlete.weight ?? 0) kg"
        self.heightLabel.text = "\(athlete.height ?? 0) cm"
    }
    
    private func setWebView() {
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.allowsInlineMediaPlayback = true
        webViewConfiguration.allowsPictureInPictureMediaPlayback = true
        
        self.webView = WKWebView(frame: self.webViewContainer.bounds, configuration: webViewConfiguration)
        self.webViewContainer.addSubview(self.webView)
    }
    
    @IBSegueAction private func embedHostingViewController(_ coder: NSCoder) -> UIViewController? {
        UIHostingController(coder: coder, rootView: MarkDownTextView(markdownText: LocalizedStringKey(self.athlete?.bio ?? "")))
    }
    
}

// MARK: - Table View

extension AthleteDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.athlete?.results?.count ?? 0
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let resultCell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as? ResultCell else { return UITableViewCell() }
        guard let athleteResult = self.athlete?.results?[indexPath.row] else { return UITableViewCell() }
                       
        resultCell.configure(athleteResult: athleteResult)

        return resultCell
    }
    
}

extension AthleteDetailsViewController: AthleteDetailsView {
    internal var viewWebView: WKWebView? {
        self.webView
    }
}
