import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), isLocked: true, range: 450, temperature: 22.0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = loadData()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = loadData()
        // Refresh periodically (though Flutter app will usually force reload)
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }
    
    // Read data shared from Flutter via UserDefaults App Group
    func loadData() -> SimpleEntry {
        // IMPORTANT: Replace with your actual App Group ID from Xcode Capabilities
        let userDefaults = UserDefaults(suiteName: "group.com.example.car_owner_app")
        
        let isLocked = userDefaults?.bool(forKey: "is_locked") ?? true
        let range = userDefaults?.integer(forKey: "range") ?? 450
        let temp = userDefaults?.double(forKey: "temperature") ?? 22.0
        
        return SimpleEntry(date: Date(), isLocked: isLocked, range: range, temperature: temp)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let isLocked: Bool
    let range: Int
    let temperature: Double
}

struct CarControlWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground) // Adapts to Dark Mode
            
            VStack(spacing: 12) {
                // Header
                HStack {
                    Text("BJ60")
                        .font(.headline)
                    Spacer()
                    Text("京A·88888")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                // Status Row
                HStack(spacing: 20) {
                    Label("\(entry.range)km", systemImage: "fuelpump.fill")
                        .font(.subheadline)
                    
                    Label("\(Int(entry.temperature))°C", systemImage: "thermometer")
                        .font(.subheadline)
                }
                
                Spacer()
                
                // Controls (Deep Links to open app and perform action)
                HStack(spacing: 15) {
                    Link(destination: URL(string: "carapp://control/toggleLock")!) {
                        HStack {
                            Image(systemName: entry.isLocked ? "lock.fill" : "lock.open.fill")
                            Text(entry.isLocked ? "解锁" : "关锁")
                                .font(.caption)
                                .fontWeight(.bold)
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity)
                        .background(entry.isLocked ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                        .foregroundColor(entry.isLocked ? .green : .red)
                        .cornerRadius(8)
                    }
                    
                    Link(destination: URL(string: "carapp://control/toggleClimate")!) {
                        Image(systemName: "fanblades.fill")
                            .font(.system(size: 20))
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
    }
}

@main
struct CarControlWidget: Widget {
    let kind: String = "CarControlWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CarControlWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("车辆控制")
        .description("快速查看状态与控制车辆")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

