//
//  AddTaskView.swift
//  ToDoList
//
//  Created by Yan on 21/3/25.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ItemViewModel
    @State private var title: String = ""
    @State private var content: String = ""
    private let date = Date()

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
                    Text(date.formatted(date: .numeric, time: .omitted))
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
                    Button("Назад") {
                        dismiss()
                    }
                    .foregroundColor(.yellow)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.presenter?.addItem(title: title, content: content)
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
}

#Preview {
    AddTaskView(viewModel: ItemViewModel())
}
