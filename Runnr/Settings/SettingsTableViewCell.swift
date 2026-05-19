//
//  SettingsTableViewCell.swift
//  Runnr
//
//  Created by SDC-USER on 12/01/26.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var cellSymbol: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!

    func configureCell(with data: Settings) {
        self.cellTitle.text = data.title
        self.cellSymbol.image = data.symbol
    }

}
