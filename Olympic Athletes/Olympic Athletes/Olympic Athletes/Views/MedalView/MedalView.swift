//
//  MedalView.swift
//  Olympic Athletes
//
//  Created by Mario Matrone on 29/08/23.
//

import UIKit

internal enum Medal {
    case gold
    case silver
    case bronze
}

internal class MedalView: UIView {
    
    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private weak var medalImageView: UIImageView!
    @IBOutlet private weak var counterContainerView: UIView!
    @IBOutlet private weak var medalCounter: UILabel!
    
    override
    public init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required
    public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private var nibName: String {
        return "MedalView"
    }
    
    private var bundle: Bundle {
        return Bundle.main
    }
    
    private func commonInit() {
        self.bundle.loadNibNamed(self.nibName, owner: self, options: nil)
        self.addSubview(self.contentView)
        
        self.contentView.layer.masksToBounds = true
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.counterContainerView.layer.cornerRadius = 6.0
    }
    
    internal func configure(medal: Medal, medalCount: Int) {
        switch medal {
            
        case .gold:
            self.medalImageView.tintColor = .systemYellow
        case .silver:
            self.medalImageView.tintColor = .lightGray
        case .bronze:
            self.medalImageView.tintColor = .systemOrange
        }
        
        self.medalCounter.text = "\(medalCount)"
    }
    
}
