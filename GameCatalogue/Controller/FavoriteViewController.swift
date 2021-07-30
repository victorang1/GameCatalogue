//
//  FavoriteViewController.swift
//  GameCatalogue
//
//  Created by Team SSG on 30/07/21.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private lazy var repository = AppRepository(context: context)

    private var games: [GameModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Your Favorites Games"

        gameTableView.delegate = self
        gameTableView.dataSource = self
        gameTableView.register(GameTableViewCell.nib(), forCellReuseIdentifier: "GameCell")

        loadFavoriteData()
    }

    private func loadFavoriteData() {
        repository.getFavorites { favorites in
            self.games.removeAll()
            self.games = favorites
            if favorites.isEmpty {
                self.gameTableView.isHidden = true
                self.noDataLabel.isHidden = false
            } else {
                self.gameTableView.isHidden = false
                self.noDataLabel.isHidden = true
            }
            self.gameTableView.reloadData()
        }
    }
}

extension FavoriteViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gameTableView.deselectRow(at: indexPath, animated: true)

        let detail = storyboard?.instantiateViewController(identifier: "detail") as! DetailViewController

        let gameId = games[indexPath.row].gameId

        detail.selectedGameId = gameId
        detail.title = "Detail Information"
        detail.detailType = DetailType.favorite

        navigationController?.pushViewController(detail, animated: true)

    }
}

extension FavoriteViewController: UITableViewDataSource {

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
