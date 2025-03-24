//
//  AddOrEditTaskView.swift
//  ToDoList
//
//  Created by Yan on 21/3/25.
//

import SwiftUI

struct AddOrEditTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ContentViewModel

    // Необязательный параметр для редактирования
    var editingItem: ToDoItem?

    @State private var title: String = ""
    @State private var content: String = ""
    private var date: Date

    // Инициализатор для создания новой задачи
    init(viewModel: ContentViewModel) {
        self.viewModel = viewModel
        self.editingItem = nil
        self.date = Date()
        // _title и _content уже инициализированы пустыми строками
    }

    // Инициализатор для редактирования существующей задачи
    init(viewModel: ContentViewModel, item: ToDoItem) {
        self.viewModel = viewModel
        self.editingItem = item
        self._title = State(initialValue: item.title)
        self._content = State(initialValue: item.content)
        self.date = item.date
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)

                VStack(alignment: .leading, spacing: 20) {
                    // Заголовок
                    TextField("Название задачи", text: $title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)

                    // Дата
                    Text(formattedDate(date))
                        .font(.system(size: 14))
                        .foregroundColor(.gray)

                    // Описание
                    TextField("Описание задачи", text: $content, axis: .vertical)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .lineLimit(5...10)

                    Spacer()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Назад")
                        }
                        .foregroundColor(.yellow)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if let item = editingItem {
                            // Режим редактирования
                            viewModel.presenter?.editItem(
                                id: item.id, title: title, content: content)
                        } else {
                            // Режим добавления
                            viewModel.presenter?.addItem(title: title, content: content)
                        }
                        dismiss()
                    } label: {
                        Text("Готово")
                            .bold()
                    }
                    .disabled(title.isEmpty)
                    .foregroundColor(title.isEmpty ? .gray : .yellow)
                }
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
}

#Preview {
    AddOrEditTaskView(viewModel: ContentViewModel())
}
