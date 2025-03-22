//
//  HayatiApp.swift
//  Hayati
//
//  Created by Muhammad Ali Maniar on 21/03/2025.
//

import SwiftUI

@main
struct HayatiApp: App {
    private let coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            coordinator.start()
        }
    }
}
