//
//  ToDoRouter.swift
//  ToDoList
//
//  Created by Yan on 19/3/25.
//
import SwiftUI
import UIKit

class ToDoRouter: ToDoRouterProtocol {
    weak var viewController: UIViewController?

    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }

    static func createModule() -> some View {
        let viewModel = ItemViewModel()
        let view = ItemView(viewModel: viewModel)
        let interactor = ToDoInteractor()
        let router = ToDoRouter()
        let presenter = ToDoPresenter(view: viewModel)

        viewModel.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        return view
    }

    func shareItem(_ item: ToDoItem) {
        let textToShare = "\(item.title)\n\(item.content)"
        let activityVC = UIActivityViewController(
            activityItems: [textToShare],
            applicationActivities: nil
        )

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first,
            let rootVC = window.rootViewController
        {
            rootVC.present(activityVC, animated: true)
        }
    }
}
