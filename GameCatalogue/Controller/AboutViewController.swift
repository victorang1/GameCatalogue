//
//  AboutViewController.swift
//  GameCatalogue
//
//  Created by Team SSG on 23/07/21.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        initImage()
        initTextData()
    }

    private func initImage() {
        let image: UIImage = UIImage(named: "profile")!
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        profileImage.image = image
    }

    private func initTextData() {
        nameLabel.text = "Victor"
        emailLabel.text = "angvictor91@gmail.com"
    }
}
