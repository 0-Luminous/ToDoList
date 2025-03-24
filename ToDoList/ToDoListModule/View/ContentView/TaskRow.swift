//
//  TaskRow.swift
//  ToDoList
//
//  Created by Yan on 23/3/25.
//
import SwiftUI
import UIKit

struct TaskRow: View {
    let item: ToDoItem
    let onToggle: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onShare: () -> Void

    var body: some View {
        ZStack {
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
                    .foregroundColor(item.isCompleted ? .gray : .white)
                    .lineLimit(2)
                    .padding(.leading, 30)

                Text(formattedDate(item.date))
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.leading, 30)
            }
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

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
}
