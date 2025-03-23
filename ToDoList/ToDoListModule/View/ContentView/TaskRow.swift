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

    @State private var isSelected: Bool = false

    var body: some View {
        ZStack {
            ContextMenuDetector(isSelected: $isSelected)
                .frame(width: 0, height: 0)  // Скрываем детектор

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

                //                Divider()
                //                    .background(Color(.systemGray5))
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
}

// Класс для отслеживания появления контекстного меню
struct ContextMenuDetector: UIViewRepresentable {
    @Binding var isSelected: Bool

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        NotificationCenter.default.removeObserver(context.coordinator)

        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(context.coordinator.menuWillShow),
            name: UIMenuController.willShowMenuNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(context.coordinator.menuDidHide),
            name: UIMenuController.didHideMenuNotification,
            object: nil
        )
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: ContextMenuDetector

        init(_ parent: ContextMenuDetector) {
            self.parent = parent
        }

        @objc func menuWillShow() {
            DispatchQueue.main.async {
                self.parent.isSelected = true
            }
        }

        @objc func menuDidHide() {
            DispatchQueue.main.async {
                self.parent.isSelected = false
            }
        }
    }
}
