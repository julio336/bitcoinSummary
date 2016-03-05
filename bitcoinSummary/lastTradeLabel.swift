//
//  lastTradeLabel.swift
//  bitcoinSummary
//
//  Created by Julio Ahuactzin on 04/03/16.
//  Copyright © 2016 Julio Ahuactzin. All rights reserved.
//

import UIKit

class lastTradeLabel: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override var text: String? {
        didSet {
            print("Text changed from \(oldValue) to \(text)")
        }
    }

}
