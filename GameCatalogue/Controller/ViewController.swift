//
//  ViewController.swift
//  GameCatalogue
//
//  Created by Team SSG on 22/07/21.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    private let searchController = UISearchController()

    private let networkManager = GameNetworkManager()
    private var games: [GameModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "List Games"

        gameTableView.delegate = self
        gameTableView.dataSource = self
        gameTableView.register(GameTableViewCell.nib(), forCellReuseIdentifier: "GameCell")

        let aboutImage = UIImage(systemName: "person.crop.circle.fill")!
        let favoriteImage = UIImage(systemName: "heart.fill")!

        let aboutBarButtonItem = UIBarButtonItem(image: aboutImage, style: .plain, target: self, action: #selector(didTapAbout))
        let favoriteBarbuttonItem = UIBarButtonItem(image: favoriteImage, style: .plain, target: self, action: #selector(didTapFavorite))

        navigationItem.rightBarButtonItems = [aboutBarButtonItem, favoriteBarbuttonItem]

        initSearchController()
        self.loadGameData()
    }

    private func loadGameData() {
        networkManager.fetchListGames { [weak self] result in
            switch result {
            case .success(let response):
                let newGames = MapperUtil.mapResponseToGameModel(gameResponses: response.results)
                self?.games.removeAll()
                self?.games.append(contentsOf: newGames)
                DispatchQueue.main.async {
                    self?.noDataLabel.isHidden = !newGames.isEmpty
                    self?.gameTableView.isHidden = newGames.isEmpty
                    self?.gameTableView.reloadData()
                }
            default:
                self?.showToast(message: "Something went wrong")
            }
        }
    }

    private func initSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Games"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    @objc func didTapAbout() {
        let about = storyboard?.instantiateViewController(identifier: "about") as! AboutViewController
        about.title = "Profile"
        navigationController?.pushViewController(about, animated: true)
    }

    @objc func didTapFavorite() {
        let favorite = storyboard?.instantiateViewController(identifier: "favorite") as! FavoriteViewController
        favorite.title = "Favorite"
        navigationController?.pushViewController(favorite, animated: true)
    }
}
extension ViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }

        networkManager.searchGames(query: text) { [weak self] result in
            switch result {
            case .success(let response):
                let newGames = MapperUtil.mapResponseToGameModel(gameResponses: response.results)
                self?.games.removeAll()
                self?.games.append(contentsOf: newGames)
                DispatchQueue.main.async {
                    self?.noDataLabel.isHidden = !newGames.isEmpty
                    self?.gameTableView.isHidden = newGames.isEmpty
                    self?.gameTableView.reloadData()
                }
            default:
                self?.showToast(message: "Something went wrong")
            }
        }
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gameTableView.deselectRow(at: indexPath, animated: true)

        let detail = storyboard?.instantiateViewController(identifier: "detail") as! DetailViewController

        let gameId = games[indexPath.row].gameId

        detail.selectedGameId = gameId
        detail.title = "Detail Information"
        detail.detailType = DetailType.network

        navigationController?.pushViewController(detail, animated: true)

    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let gameCell = gameTableView.dequeueReusableCell(withIdentifier: "GameCell") as? GameTableViewCell {
            let game = games[indexPath.row]
            gameCell.bind(game: game)

            return gameCell
        } else {
            return UITableViewCell()
        }
    }
}
