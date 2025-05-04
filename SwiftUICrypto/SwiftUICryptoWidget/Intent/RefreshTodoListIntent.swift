//
//  RefreshTodoListIntent.swift
//  MyToDo
//

import AppIntents
import WidgetKit

struct RefreshCoinMarketIntent: AppIntent {
    static var title = LocalizedStringResource("Refresh coin market")
    
    func perform() async throws -> some IntentResult {
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
