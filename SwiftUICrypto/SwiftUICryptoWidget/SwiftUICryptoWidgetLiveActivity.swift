//
//  SwiftUICryptoWidgetLiveActivity.swift
//  SwiftUICryptoWidget
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SwiftUICryptoWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SwiftUICryptoWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SwiftUICryptoWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension SwiftUICryptoWidgetAttributes {
    fileprivate static var preview: SwiftUICryptoWidgetAttributes {
        SwiftUICryptoWidgetAttributes(name: "World")
    }
}

extension SwiftUICryptoWidgetAttributes.ContentState {
    fileprivate static var smiley: SwiftUICryptoWidgetAttributes.ContentState {
        SwiftUICryptoWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: SwiftUICryptoWidgetAttributes.ContentState {
         SwiftUICryptoWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: SwiftUICryptoWidgetAttributes.preview) {
   SwiftUICryptoWidgetLiveActivity()
} contentStates: {
    SwiftUICryptoWidgetAttributes.ContentState.smiley
    SwiftUICryptoWidgetAttributes.ContentState.starEyes
}
