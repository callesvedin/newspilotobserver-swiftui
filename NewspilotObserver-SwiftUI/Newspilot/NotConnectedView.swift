//
//  NotConnectedView.swift
//  NewspilotObserver
//
//  Created by carl-johan.svedin on 2019-02-27.
//  Copyright © 2019 Infomaker Scandinavia AB. All rights reserved.
//

import UIKit

class NotConnectedView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    private func setupView() {
        self.backgroundColor = UIColor.negation
        let frame = self.frame
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: frame.origin.x, width: frame.size.width, height: frame.size.height))

        label.text = NSLocalizedString("Not connected", comment: "not connected")
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true        

    }
  

}
