//
//  NoticiaTableViewCell.swift
//  99News
//
//  Created by Ricardo Silverio de Souza on 15/12/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit

class NoticiaTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgFoto: UIImageView!
    @IBOutlet weak var txtTitulo: UILabel!
    @IBOutlet weak var txtResumo: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
