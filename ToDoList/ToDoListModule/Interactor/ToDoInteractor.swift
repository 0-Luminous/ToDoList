//
//  ToDoInteractor.swift
//  ToDoList
//
//  Created by Yan on 19/3/25.
//
import Foundation

class ToDoInteractor: ToDoInteractorProtocol {
    private var todoItems: [ToDoItem] = []
    weak var presenter: ToDoPresenterProtocol?

    func fetchItems() {
        // Здесь можно добавить загрузку из CoreData
        presenter?.didFetchItems(ToDoItem: todoItems)
    }

    func addItem(title: String, content: String) {
        let newItem = ToDoItem(
            title: title,
            content: content,
            date: Date()
        )
        todoItems.append(newItem)
        presenter?.didAddItem()
    }
    func deleteItem(id: UUID) {
        todoItems.removeAll { $0.id == id }
        presenter?.didDeleteItem()
    }

    func toggleItem(id: UUID) {
        if let index = todoItems.firstIndex(where: { $0.id == id }) {
            todoItems[index].isCompleted.toggle()
            presenter?.didToggleItem()
        }
    }

    func searchItems(query: String) {
        let filtered =
            query.isEmpty
            ? todoItems
            : todoItems.filter {
                $0.title.localizedCaseInsensitiveContains(query)
                    || $0.content.localizedCaseInsensitiveContains(query)
            }
        presenter?.didFetchItems(ToDoItem: filtered)
    }

    func editItem(id: UUID, title: String, content: String) {
        if let index = todoItems.firstIndex(where: { $0.id == id }) {
            todoItems[index].title = title
            todoItems[index].content = content
            presenter?.didFetchItems(ToDoItem: todoItems)
        }
    }

    func getItem(id: UUID) -> ToDoItem? {
        return todoItems.first { $0.id == id }
    }
}
