//
//  DetailViewController.swift
//  GameCatalogue
//
//  Created by Team SSG on 22/07/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var ratingSymbol: UILabel!
    @IBOutlet weak var gameDescription: UITextView!
    
    private let networkManager = GameNetworkManager()
    var selectedGameId: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDetailData()
    }

    private func loadDetailData() {
        networkManager.fetchDetailGame(gameId: String(selectedGameId)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleDetailResponse(responseDetail: response)
            default:
                self?.showToast(message: "Something went wrong")
            }
        }
    }
    
    private func handleDetailResponse(responseDetail: DetailResponse) {
        DispatchQueue.main.async {
            self.photo.kf.setImage(with: URL(string: responseDetail.backgroundImage))
            self.name.text = responseDetail.name
            self.rating.text = "Rating: \(responseDetail.rating)"
            self.ratingSymbol.isHidden = false
            let formattedDate = DateUtil.formatDate(date: responseDetail.released, resultFormat: "DD MMM YYYY")
            self.releaseDate.text = "Released: \(formattedDate)"
            self.gameDescription.text = responseDetail.detailResponseDescription.htmlToString
            self.gameDescription.textContainer.lineFragmentPadding = 0;
        }
    }
}
