//
//  AppRepository.swift
//  GameCatalogue
//
//  Created by Team SSG on 30/07/21.
//

import Foundation
import CoreData

class AppRepository {

    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func isFavorite(gameId: Int) -> Bool {
        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(gameId)")
            if let result = try context.fetch(fetchRequest).first {
                let id = result.value(forKeyPath: "id") as? Int
                return id != nil
            }
            return false
        } catch let error as NSError {
            print(error)
            return false
        }
    }

    func getFavorites(completion: @escaping(_ games: [GameModel]) -> Void) {
        context.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
            do {
                var games: [GameModel] = []
                let results = try self.context.fetch(fetchRequest)
                for res in results {
                    let game = GameModel(
                        gameId: res.value(forKeyPath: "id") as? Int ?? 0,
                        name: res.value(forKeyPath: "name") as? String ?? "",
                        released: res.value(forKeyPath: "released") as? String ?? "",
                        image: res.value(forKeyPath: "photo") as? String ?? "",
                        rating: res.value(forKeyPath: "rating") as? Double ?? 0.0,
                        ratingsCount: res.value(forKeyPath: "ratingsCount") as? Int ?? 0,
                        description: ""
                    )
                    games.append(game)
                }
                completion(games)
            } catch let error as NSError {
                print(error)
            }
        }
    }

    func getFavorite(gameId: Int, completion: @escaping(_ games: GameModel) -> Void) {
        context.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(gameId)")
            do {
                if let res = try self.context.fetch(fetchRequest).first {
                    let member = GameModel(
                        gameId: res.value(forKeyPath: "id") as? Int ?? 0,
                        name: res.value(forKeyPath: "name") as? String ?? "",
                        released: res.value(forKeyPath: "released") as? String ?? "",
                        image: res.value(forKeyPath: "photo") as? String ?? "",
                        rating: res.value(forKeyPath: "rating") as? Double ?? 0.0,
                        ratingsCount: res.value(forKeyPath: "ratingsCount") as? Int ?? 0,
                        description: res.value(forKey: "gameDescription") as? String ?? ""
                    )
                    completion(member)
                }
            } catch let error as NSError {
                print(error)
            }
        }
    }

    func addToFavorite(insertedModel: DetailResponse) -> Bool {
        context.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "Game", in: context) {
                let game = NSManagedObject(entity: entity, insertInto: context)
                game.setValue(insertedModel.gameId, forKey: "id")
                game.setValue(insertedModel.name, forKey: "name")
                game.setValue(insertedModel.backgroundImage, forKey: "photo")
                game.setValue(insertedModel.released, forKey: "released")
                game.setValue(insertedModel.ratingsCount, forKey: "ratingsCount")
                game.setValue(insertedModel.detailResponseDescription, forKey: "gameDescription")
                game.setValue(insertedModel.rating, forKey: "rating")
                save()
            }
        }
        return true
    }

    func removeFromFavorite(gameId: Int, completion: @escaping() -> Void) {
        context.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(gameId)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? context.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    completion()
                }
            }
        }
    }

    private func save() {
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
