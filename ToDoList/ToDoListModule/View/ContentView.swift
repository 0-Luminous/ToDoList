//
//  ContentView.swift
//  ToDoList
//
//  Created by Yan on 19/3/25.
//

import CoreData
import SwiftUI

class ItemViewModel: ObservableObject, ToDoViewProtocol {
    @Published var items: [ToDoItem] = []
    @Published var searchText: String = "" {
        didSet {
            presenter?.handleSearch(query: searchText)
        }
    }
    @Published var isAddingNewItem: Bool = false

    var presenter: ToDoPresenter?

    init() {
        self.presenter = ToDoPresenter(view: self)
        presenter?.viewDidLoad()
    }

    func displayItems(_ items: [ToDoItem]) {
        DispatchQueue.main.async {
            self.items = items
        }
    }
}

struct ItemView: View {
    @ObservedObject var viewModel: ItemViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Поисковая строка
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal, 17)

                // Список задач
                List {
                    ForEach(viewModel.items) { item in
                        TaskRow(
                            item: item,
                            onToggle: {
                                viewModel.presenter?.toggleItem(id: item.id)
                            },
                            onEdit: {
                                viewModel.presenter?.editItem(
                                    id: item.id, title: item.title, content: item.content)
                            },
                            onDelete: {
                                viewModel.presenter?.deleteItem(id: item.id)
                            },
                            onShare: {
                                viewModel.presenter?.shareItem(id: item.id)
                            }
                        )
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let item = viewModel.items[index]
                            viewModel.presenter?.deleteItem(id: item.id)
                        }
                    }
                }
                .padding(.vertical, 8)
                .listRowBackground(Color.black)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                
                // Нижняя панель
                BottomBar(itemCount: viewModel.items.count) {
                    viewModel.isAddingNewItem = true
                }
            }
            .navigationTitle("Задачи")
            .fullScreenCover(isPresented: $viewModel.isAddingNewItem) {
                AddTaskView(viewModel: viewModel)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 6)
            TextField("Search", text: $text)
                .padding(.vertical, 7)
                .font(.system(size: 17))
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct TaskRow: View {
    let item: ToDoItem
    let onToggle: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onShare: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button(action: onToggle) {
                    Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                        .foregroundColor(item.isCompleted ? .yellow : .gray)
                        .font(.system(size: 22))
                }

                Text(item.title)
                    .strikethrough(item.isCompleted)
                    .foregroundColor(item.isCompleted ? .gray : .white)

                Spacer()
            }

            Text(item.content)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
                .padding(.leading, 30)

            Text(item.date.formatted(date: .numeric, time: .omitted))
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.leading, 30)

            Divider()
                .background(Color(.systemGray5))
        }
        .listRowSeparator(.hidden)
        .contextMenu {
            Button(action: onEdit) {
                Label("Редактировать", systemImage: "pencil")
            }

            Button(action: onShare) {
                Label("Поделиться", systemImage: "square.and.arrow.up")
            }

            Button(role: .destructive, action: onDelete) {
                Label("Удалить", systemImage: "trash")
            }
        }
    }
}
