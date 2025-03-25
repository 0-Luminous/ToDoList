//
//  ContentViewModel.swift
//  ToDoList
//
//  Created by Yan on 25/3/25.
//

import Combine
import Foundation
import SwiftUI

class ContentViewModel: ObservableObject, ToDoViewProtocol {
    @Published var items: [ToDoItem] = []
    @Published var searchText: String = "" {
        didSet {
            presenter?.handleSearch(query: searchText)
        }
    }
    @Published var isAddingNewItem: Bool = false
    @Published var editingItem: ToDoItem? = nil

    var presenter: ToDoPresenterProtocol?

    init() {
        self.presenter = ToDoPresenter(view: self)
        presenter?.viewDidLoad()
    }

    func displayItems(_ items: [ToDoItem]) {
        DispatchQueue.main.async {
            self.items = items
        }
    }

    func onViewDidLoad() {
        print("🚀 ContentViewModel: onViewDidLoad вызван")
        presenter?.viewDidLoad()
    }
}
