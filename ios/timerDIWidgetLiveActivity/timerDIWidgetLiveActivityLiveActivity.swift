//
//  timerDIWidgetLiveActivityLiveActivity.swift
//  timerDIWidgetLiveActivity
//
//  Created by Pratham Mittal on 08/01/24.
//

import ActivityKit
import WidgetKit
import SwiftUI
import Foundation



struct timerDIWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var remainingTime : Int    }

    // Fixed non-changing properties about your activity go here!
    
}

struct timerDIWidgetLiveActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: timerDIWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello ")
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
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T ")
            } minimal: {
                Text("M")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

