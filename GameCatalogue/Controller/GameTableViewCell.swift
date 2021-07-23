//
//  GameTableViewCell.swift
//  GameCatalogue
//
//  Created by Team SSG on 22/07/21.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var totalRating: UILabel!
    
    static let identifier = "GameTableViewCell"
        
    static func nib() -> UINib {
        return UINib(nibName: GameTableViewCell.identifier, bundle: nil)
    }
}
