//
//  Persistence.swift
//  ToDoList
//
//  Created by Yan on 19/3/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let entity = NSEntityDescription.entity(forEntityName: "CDToDoItem", in: viewContext)!
            let newItem = NSManagedObject(entity: entity, insertInto: viewContext)

            newItem.setValue(UUID(), forKey: "id")
            newItem.setValue("Пример задачи", forKey: "title")
            newItem.setValue("Описание задачи", forKey: "content")
            newItem.setValue(Date(), forKey: "date")
            newItem.setValue(false, forKey: "isCompleted")
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ToDoList")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("❌ Ошибка загрузки хранилища CoreData: \(error), \(error.userInfo)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                print("✅ CoreData хранилище успешно загружено")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
