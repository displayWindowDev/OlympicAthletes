//
//  AthleteDetailsPresenter.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 30/08/23.
//

import Foundation

internal class AthleteDetailsPresenter: AthleteDetailsViewPresenter {
    
    internal weak var view: AthleteDetailsView?
    
    required
    internal init(view: AthleteDetailsView) {
        self.view = view
    }
    
    /// Loads into the webView the youtube video with the provided identifier
    /// - Parameter id: youtube video identifier
    internal func loadVideo(id: String) {
        guard let videoURL = URL(string: "https://www.youtube.com/embed/\(id)?playsinline=1") else { return }

        let request = URLRequest(url: videoURL)

        self.view?.viewWebView?.isOpaque = false
        self.view?.viewWebView?.backgroundColor = .clear
        self.view?.viewWebView?.load(request)
    }
    
}
