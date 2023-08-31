//
//  AthleteDetailsViewPresenter.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 30/08/23.
//

import WebKit

internal protocol AthleteDetailsViewPresenter: AnyObject {
    init(view: AthleteDetailsView)
   
    func loadVideo(id: String)
}

internal protocol AthleteDetailsView: AnyObject {
    var viewWebView: WKWebView? { get }
}
