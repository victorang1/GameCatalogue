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
    @IBOutlet weak var platformCollectionView: UICollectionView!

    private let networkManager = GameNetworkManager()
    var selectedGameId: Int = -1

    private var platforms: [Platform] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        platformCollectionView.delegate = self
        platformCollectionView.dataSource = self
        platformCollectionView.register(PlatformCollectionViewCell.nib(), forCellWithReuseIdentifier: "PlatformCell")

        self.loadDetailData()
    }

    override func viewDidAppear(_ animated: Bool) {
       scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+300)
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
        self.platforms.removeAll()
        self.platforms = responseDetail.platforms
        DispatchQueue.main.async {
            self.photo.kf.setImage(with: URL(string: responseDetail.backgroundImage))
            self.name.text = responseDetail.name
            self.rating.text = "Rating: \(responseDetail.rating)"
            self.ratingSymbol.isHidden = false
            let formattedDate = DateUtil.formatDate(date: responseDetail.released, resultFormat: "DD MMM YYYY")
            self.releaseDate.text = "Released: \(formattedDate)"
            self.gameDescription.text = responseDetail.detailResponseDescription.htmlToString
            self.gameDescription.textContainer.lineFragmentPadding = 0
            self.platformCollectionView.reloadData()
        }
    }
}

extension DetailViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        platformCollectionView.deselectItem(at: indexPath, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isKind(of: UICollectionView.self) {
             return
          }
    }
 }

 extension DetailViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return platforms.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let platformCell = platformCollectionView.dequeueReusableCell(withReuseIdentifier: "PlatformCell", for: indexPath) as? PlatformCollectionViewCell {
            let platform = platforms[indexPath.row]

            let url = URL(string: platform.platform.imageBackground)
            platformCell.photo.kf.setImage(with: url)
            platformCell.name.text = platform.platform.name

            return platformCell
        } else {
            return UICollectionViewCell()
        }
    }
 }
