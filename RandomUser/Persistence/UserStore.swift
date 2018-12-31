//
//  CoreDataStack.swift
//  RandomUser
//
//  Created by Mateusz Matoszko on 26/12/2018.
//  Copyright © 2018 Mateusz Matoszko. All rights reserved.
//

import Foundation
import CoreData

protocol UserPersisting {

    typealias UsersCallback = ([User]) -> Void

    func persistAsync(users: [User])
    func loadUsers(callback: UsersCallback)

}

final class UserStore: UserPersisting {

    private let container: NSPersistentContainer

    init(containerName: String) {
        container = NSPersistentContainer(name: containerName)
    }

    func load(completion: @escaping (Bool) -> Void) {
        container.loadPersistentStores { (storeDescription, error) in
            if error != nil {
                completion(false)
                return
            }
            completion(true)
        }
    }

    func persistAsync(users: [User]) {
        container.performBackgroundTask { [weak self] context in
            do {
                try self?.removeAllUsers(from: context)
                users.forEach { $0.persisted(in: context) }
                try context.save()

            } catch {
                assertionFailure("Error while persisting users: \(error)")
            }
        }
    }

    func loadUsers(callback: UsersCallback) {
        let fetchRequest: NSFetchRequest<PersistedUser> = PersistedUser.fetchRequest()
        do {
            let persistedUsers = try container.viewContext.fetch(fetchRequest)
            let users = persistedUsers.compactMap(User.init)
            callback(users)
        } catch {
            assertionFailure("Error while loading users: \(error)")
        }
    }

    private func removeAllUsers(from context: NSManagedObjectContext) throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PersistedUser.fetchRequest()
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(batchDeleteRequest)
    }

}

private extension User {

    @discardableResult
    func persisted(in context: NSManagedObjectContext) -> PersistedUser {
        let persistedUser = PersistedUser(context: context)
        persistedUser.email = email
        persistedUser.firstName = name.first
        persistedUser.largePicture = picture.large
        persistedUser.lastName = name.last
        persistedUser.mediumPicture = picture.medium
        persistedUser.thumbnailPicture = picture.thumbnail
        persistedUser.title = name.title
        persistedUser.uuid = login.uuid
        return persistedUser
    }

    init?(persistedUser: PersistedUser) {
        guard let uuid = persistedUser.uuid,
            let email = persistedUser.email,
            let title = persistedUser.title,
            let firstName = persistedUser.firstName,
            let lastName = persistedUser.lastName,
            let thumbnail = persistedUser.thumbnailPicture,
            let mediumPicture = persistedUser.mediumPicture,
            let largePicture = persistedUser.largePicture else { return nil }
        self.email = email
        self.login = Login(uuid: uuid)
        self.name = Name(title: title, first: firstName, last: lastName)
        self.picture = Picture(large: largePicture, medium: mediumPicture, thumbnail: thumbnail)
    }
}
