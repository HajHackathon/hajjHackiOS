//
//  CustomeTableViewCell.swift
//  HackthonTest
//
//  Created by Qahtan on 8/1/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit
class CustomTableViewCell: UITableViewCell {
    var hajje: Hajji? {
        didSet{
            if let hajje = hajje {
            caseIfo.text = "\(hajje.caseS)"
            }
        }
    }
    let caseIfo: UILabel = {
        let lab = UILabel()
        lab.text = "Hart Attcak"
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(caseIfo)
        caseIfo.topAnchor.constraint(equalTo: topAnchor).isActive = true
        caseIfo.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        caseIfo.leftAnchor.constraint(equalTo: leftAnchor,constant: 20).isActive = true
        caseIfo.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
