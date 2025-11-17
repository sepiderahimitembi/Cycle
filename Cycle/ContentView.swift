import SwiftUI

// MARK: - Bottom Tab Enum

enum BottomTab: String, CaseIterable {
    case cycle
    case calendar
    case insights
    case me
    
    var title: String {
        switch self {
        case .cycle: return "Cycle"
        case .calendar: return "Calendar"
        case .insights: return "Insights"
        case .me: return "Me"
        }
    }
    
    var systemImage: String {
        switch self {
        case .cycle: return "circle.dashed.inset.filled"
        case .calendar: return "calendar"
        case .insights: return "lightbulb.fill"
        case .me: return "person.crop.circle"
        }
    }
}

// MARK: - MAIN SCREEN

struct ContentView: View {
    
    @State private var selectedTab: BottomTab = .insights
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {
                        if selectedTab == .insights {
                            InsightsPage()
                        } else {
                            PlaceholderPage(tab: selectedTab)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 16 + 60) // space for tab bar
                }
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

// MARK: - INSIGHTS PAGE

struct InsightsPage: View {
    
    private let lastPeriodDays = 4
    private let estimatedCycleDays = 28
    private let phaseName = "Follicular"
    private let phaseDaysLeft = 3
    
    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            
            Text("Insights")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 8)
            
            // Your Cycle
            VStack(alignment: .leading, spacing: 14) {
                Text("Your Cycle")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("Overview of your cycle.")
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)
                
                HStack(spacing: 16) {
                    CycleStatCard(
                        value: "\(lastPeriodDays)",
                        unit: "Days",
                        label: "Last Period",
                        iconName: "drop.fill",
                        badgeColor: .redAccent
                    )
                    
                    CycleStatCard(
                        value: "\(estimatedCycleDays)",
                        unit: "Days",
                        label: "Estimated Cycle",
                        iconName: "clock.arrow.circlepath",
                        badgeColor: .purpleAccent
                    )
                }
            }
            
            // Phase
            VStack(alignment: .leading, spacing: 14) {
                Text("Phase")
                    .font(.headline)
                    .foregroundColor(.white)
                
                PhaseCard(
                    phaseName: phaseName,
                    daysLeft: phaseDaysLeft,
                    description: "Your energy is on the rise as your body prepares for ovulation."
                )
            }
            
            // Predictions
            VStack(alignment: .leading, spacing: 16) {
                Text("Predictions")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("What to expect within the next 3 days.")
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(0..<4) { index in
                            PredictionCard(index: index)
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                Button(action: {
                    // Handle tap
                }) {
                    Text("Get Predictions")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.tealAccent)
                        .foregroundColor(.white)
                        .cornerRadius(24)
                }
                .padding(.top, 4)
            }
        }
    }
}

// MARK: - PLACEHOLDER PAGES

struct PlaceholderPage: View {
    let tab: BottomTab
    
    var body: some View {
        VStack(spacing: 12) {
            Text(tab.title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
            
            Text("This is a placeholder for the \(tab.title.lowercased()) tab.")
                .font(.subheadline)
                .foregroundColor(.secondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - CUSTOM TAB BAR

struct CustomTabBar: View {
    
    @Binding var selectedTab: BottomTab
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.borderDivider)
            
            HStack(spacing: 0) {
                ForEach(BottomTab.allCases, id: \.self) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        TabBarItem(
                            icon: tab.systemImage,
                            title: tab.title,
                            isSelected: selectedTab == tab
                        )
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)
            .padding(.bottom, 12)
            .background(Color.appBackground.opacity(0.98))
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct TabBarItem: View {
    
    let icon: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(isSelected ? .white : .secondaryText)
            
            Text(title)
                .font(.caption)
                .foregroundColor(isSelected ? .white : .secondaryText)
        }
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(isSelected ? Color.tabSelectedBackground : Color.clear)
        )
    }
}

// MARK: - CARDS

struct CycleStatCard: View {
    
    let value: String
    let unit: String
    let label: String
    let iconName: String
    let badgeColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(value) \(unit)")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                    Text(label)
                        .font(.subheadline)
                        .foregroundColor(.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: iconName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(badgeColor)
                    .padding(8)
                    .background(badgeColor.opacity(0.18))
                    .clipShape(Circle())
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground)
        .cornerRadius(20)
    }
}

struct PhaseCard: View {
    
    let phaseName: String
    let daysLeft: Int
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [.tealAccent.opacity(0.4), .blueAccent]),
                            center: .center,
                            startRadius: 4,
                            endRadius: 32
                        )
                    )
                Circle()
                    .fill(Color.appBackground)
                    .frame(width: 26, height: 26)
            }
            .frame(width: 56, height: 56)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text(phaseName)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(daysLeft) Days Left")
                        .font(.subheadline)
                        .foregroundColor(.secondaryText)
                }
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(20)
    }
}

struct PredictionCard: View {
    
    let index: Int
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .cardBackground.opacity(0.95),
                            .cardBackground.opacity(0.85)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.borderDivider.opacity(0.4), lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Day \(index + 1)")
                    .font(.caption)
                    .foregroundColor(.secondaryText)
                Text("Tap Get Predictions")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.85))
            }
            .padding(12)
        }
        .frame(width: 150, height: 110)
    }
}

// MARK: - COLORS

extension Color {
    static let appBackground = Color(red: 5/255, green: 7/255, blue: 15/255)
    static let cardBackground = Color(red: 19/255, green: 23/255, blue: 38/255)
    static let secondaryText = Color.white.opacity(0.6)
    static let borderDivider = Color.white.opacity(0.08)
    static let tabSelectedBackground = Color.white.opacity(0.08)
    
    static let tealAccent = Color(red: 0/255, green: 201/255, blue: 179/255)
    static let blueAccent = Color(red: 60/255, green: 150/255, blue: 255/255)
    static let purpleAccent = Color(red: 170/255, green: 125/255, blue: 255/255)
    static let redAccent = Color(red: 255/255, green: 99/255, blue: 99/255)
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
