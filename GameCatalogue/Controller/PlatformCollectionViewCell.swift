//
//  PlatformCollectionViewCell.swift
//  GameCatalogue
//
//  Created by Team SSG on 23/07/21.
//

import UIKit

class PlatformCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!

    static let identifier = "PlatformCollectionViewCell"

    static func nib() -> UINib {
        return UINib(nibName: PlatformCollectionViewCell.identifier, bundle: nil)
    }
}
