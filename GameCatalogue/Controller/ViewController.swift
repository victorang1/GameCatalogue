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
    private let searchController = UISearchController()
    
    private let networkManager = GameNetworkManager()
    private var games: [GameModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "List Games"
        
        gameTableView.delegate = self
        gameTableView.dataSource = self
        gameTableView.register(GameTableViewCell.nib(), forCellReuseIdentifier: "GameCell")
        
        initSearchController()
        
        self.loadGameData()
    }
    
    private func loadGameData() {
        networkManager.fetchListGames { [weak self] result in
            switch result {
            case .success(let response):
                let newGames = self?.mapResponseToGames(gameResponses: response.results) ?? []
                self?.games.removeAll()
                self?.games.append(contentsOf: newGames)
                DispatchQueue.main.async {
                    self?.gameTableView.reloadData()
                }
            default:
                self?.showToast(message: "Something went wrong")
            }
        }
    }
    
    private func mapResponseToGames(gameResponses: [GameItemResponse]) -> [GameModel] {
            return gameResponses.map { itemResponse in
                GameModel(id: itemResponse.id, name: itemResponse.name, released: itemResponse.released, image: itemResponse.backgroundImage, rating: itemResponse.rating, ratingsCount: itemResponse.ratingsCount)
        }
    }
    
    private func initSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    @IBAction func didTapAbout() {
        let about = storyboard?.instantiateViewController(identifier: "about") as! AboutViewController
        
        about.title = "About"
        
        navigationController?.pushViewController(about, animated: true)
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
                let newGames = self?.mapResponseToGames(gameResponses: response.results) ?? []
                self?.games.removeAll()
                self?.games.append(contentsOf: newGames)
                DispatchQueue.main.async {
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
                
        let gameId = games[indexPath.row].id
        
        detail.selectedGameId = gameId
        detail.title = "Detail Information"
        
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
                    
            let url = URL(string: game.image)
            gameCell.photo.kf.setImage(with: url)
            gameCell.name.text = game.name
            
            let formattedDate = DateUtil.formatDate(date: game.released, resultFormat: "DD MMM YYYY")
            
            gameCell.releaseDate.text = formattedDate
            gameCell.rating.text = "Rating: \(game.rating)"
            gameCell.totalRating.text = "(\(game.ratingsCount))"
            
            return gameCell
        }
        else {
            return UITableViewCell()
        }
    }
}

