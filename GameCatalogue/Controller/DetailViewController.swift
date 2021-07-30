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
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var gameDescription: UITextView!
    @IBOutlet weak var platformCollectionView: UICollectionView!

    private var detailData: DetailResponse?
    private var detailDataDB: GameModel?

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private let networkManager = GameNetworkManager()
    var selectedGameId: Int = -1
    var detailType: DetailType = DetailType.network

    private var platforms: [Platform] = []
    private lazy var repository = AppRepository(context: context)

    override func viewDidLoad() {
        super.viewDidLoad()

        platformCollectionView.delegate = self
        platformCollectionView.dataSource = self
        platformCollectionView.register(PlatformCollectionViewCell.nib(), forCellWithReuseIdentifier: "PlatformCell")

        switch detailType {
        case .network:
            self.loadDetailData()
        case.favorite:
            self.loadDetailDataFromDatabase()
        }
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
        self.detailData = responseDetail
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
            self.checkBarButtonItem()
        }
    }

    private func checkBarButtonItem() {
        let isFavorite = repository.isFavorite(gameId: selectedGameId)
        if isFavorite {
            navigationItem.rightBarButtonItem = getRemoveBarButtonItem()

        } else {
            navigationItem.rightBarButtonItem = getAddBarButtonItem()
        }
    }

    private func getRemoveBarButtonItem() -> UIBarButtonItem {
        let favoriteImage = UIImage(systemName: "heart.fill")!
        return UIBarButtonItem(image: favoriteImage, style: .done, target: self, action: #selector(removeFromFavorite))
    }

    private func getAddBarButtonItem() -> UIBarButtonItem {
        let notFavoriteImage = UIImage(systemName: "heart")!
        return UIBarButtonItem(image: notFavoriteImage, style: .done, target: self, action: #selector(addToFavorite))
    }

    private func loadDetailDataFromDatabase() {
        repository.getFavorite(gameId: selectedGameId) { game in
            DispatchQueue.main.async {
                self.photo.kf.setImage(with: URL(string: game.image))
                self.name.text = game.name
                self.rating.text = "Rating: \(game.rating)"
                self.ratingSymbol.isHidden = false
                let formattedDate = DateUtil.formatDate(date: game.released, resultFormat: "DD MMM YYYY")
                self.releaseDate.text = "Released: \(formattedDate)"
                self.gameDescription.text = game.description.htmlToString
                self.gameDescription.textContainer.lineFragmentPadding = 0
                self.hidePlatforms()
            }
        }
    }

    private func hidePlatforms() {
        self.platformLabel.isHidden = true
        self.platformCollectionView.isHidden = true
    }

    @objc func addToFavorite() {
        if repository.addToFavorite(insertedModel: detailData!) {
            showToast(message: "Added to favorite")
            checkBarButtonItem()
        }
    }

    @objc func removeFromFavorite() {
        repository.removeFromFavorite(gameId: detailData?.gameId ?? 0) {
            self.showToast(message: "Removed from favorite")
            self.checkBarButtonItem()
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
