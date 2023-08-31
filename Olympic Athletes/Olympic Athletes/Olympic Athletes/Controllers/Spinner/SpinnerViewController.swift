//
//  SpinnerViewController.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 22/08/23.
//

import UIKit

internal class SpinnerViewController: UIViewController {
    private var spinner = UIActivityIndicatorView(style: .medium)

    override
    internal func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)

        self.spinner.translatesAutoresizingMaskIntoConstraints = false
        self.spinner.startAnimating()
        self.view.addSubview(self.spinner)

        self.spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
