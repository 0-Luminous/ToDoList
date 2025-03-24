//
//  ContentView.swift
//  ToDoList
//
//  Created by Yan on 19/3/25.
//

import CoreData
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

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Поисковая строка
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal, 17)
                    .padding(.bottom, 16)

                // Список задач
                List {
                    ForEach(viewModel.items) { item in
                        VStack(spacing: 0) {
                            TaskRow(
                                item: item,
                                onToggle: {
                                    viewModel.presenter?.toggleItem(id: item.id)
                                },
                                onEdit: {
                                    viewModel.editingItem = item
                                },
                                onDelete: {
                                    viewModel.presenter?.deleteItem(id: item.id)
                                },
                                onShare: {
                                    viewModel.presenter?.shareItem(id: item.id)
                                }
                            )
                            .padding(.horizontal, 10)
                        }
                        // Отключаем системный разделитель
                        //.listRowSeparator(.hidden)
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let item = viewModel.items[index]
                            viewModel.presenter?.deleteItem(id: item.id)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .onAppear {
                    viewModel.onViewDidLoad()
                }

                // Нижняя панель
                BottomBar(itemCount: viewModel.items.count) {
                    viewModel.isAddingNewItem = true
                }
            }
            .navigationTitle("Задачи")
            .fullScreenCover(isPresented: $viewModel.isAddingNewItem) {
                AddOrEditTaskView(viewModel: viewModel)
            }
            .fullScreenCover(item: $viewModel.editingItem) { item in
                AddOrEditTaskView(viewModel: viewModel, item: item)
            }
        }
    }
}
