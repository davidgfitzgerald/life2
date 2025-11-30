//
//  LifeApp.swift
//  Life
//
//  Created by David Fitzgerald on 28/10/2025.
//

import SwiftUI
import SwiftData

@main
struct LifeApp: App {
    let startupService: StartupService
    let dataService: DataService
    let backgroundTaskService: BackgroundTaskService

    init() {
        self.startupService = StartupService(userDefaults: .standard)
        self.dataService = DataService(
            shouldSeed: startupService.checkFirstLaunch(),
            inMemory: false,
        )
        self.backgroundTaskService = BackgroundTaskService(container: dataService.container, monitorType: NewDayMonitor.self)
        
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .configured(
                    with:
                        AppConfiguration(
                            startupService: startupService,
                            dataService: dataService,
                            backgroundTaskService: backgroundTaskService,
                        )
                )
                .onAppActive {
                    print("App became active!")
                    Task.rollover(in: dataService.context)
                }
        }
    }
}

extension View {
    func configured(with config: AppConfiguration) -> some View {
        self
            .modelContainer(config.dataService.container)
            .environment(config.backgroundTaskService.monitor)
    }
}

extension View {
    func onAppActive(perform action: @escaping () -> Void) -> some View {
        self.modifier(AppActiveModifier(action: action))
    }
}

private struct AppActiveModifier: ViewModifier {
    @Environment(\.scenePhase) private var scenePhase
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onChange(of: scenePhase) { oldPhase, newPhase in
                print("onChange ran: scene changed from \(oldPhase) to \(newPhase)")
                if newPhase == .active {
                    action()
                }
            }
    }
}
