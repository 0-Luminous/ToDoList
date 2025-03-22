//
//  ItemView.swift
//  ToDoList
//
//  Created by Yan on 21/3/25.
//

import SwiftUI

struct ToDoItemView: View {
    @ObservedObject var viewModel: ItemViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Поисковая строка
                SearchBar(text: $viewModel.searchText)

                // Список задач
                List {
                    ForEach(viewModel.items) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .strikethrough(item.isCompleted)
                                .foregroundColor(item.isCompleted ? .gray : .white)

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
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let item = viewModel.items[index]
                            viewModel.presenter?.deleteItem(id: item.id)
                        }
                    }
                }
                .listStyle(.plain)
                .background(Color.black)
                .scrollContentBackground(.hidden)

                Spacer()
            }
        }
    }
}
