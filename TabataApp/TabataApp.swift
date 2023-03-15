//
//  TabataAppApp.swift
//  TabataApp
//
//  Created by Kirill Ushkov on 11.03.2023.
//

import SwiftUI

@main
struct TabataApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(model: AppModel(path: []))
        }
    }
}
