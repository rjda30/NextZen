import SwiftUI

struct AlertsView: View {
    @EnvironmentObject var homeStore: HomeStore
    @State private var showAddReminder = false
    @State private var filter: AlertFilter = .all

    enum AlertFilter: String, CaseIterable {
        case all = "All"
        case urgent = "Urgent"
        case upcoming = "Upcoming"
        case completed = "Done"
    }

    private var filtered: [MaintenanceReminder] {
        switch filter {
        case .all: return homeStore.reminders.sorted { $0.dueDate < $1.dueDate }
        case .urgent: return homeStore.reminders.filter { $0.isUrgent && !$0.isCompleted }
        case .upcoming: return homeStore.reminders.filter { !$0.isCompleted && !$0.isUrgent }
        case .completed: return homeStore.reminders.filter { $0.isCompleted }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filterBar
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(.systemBackground))
                if filtered.isEmpty {
                    emptyState
                } else {
                    alertList
                }
            }
            .background(Color(.systemGray6).opacity(0.5))
            .navigationTitle("Alerts")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showAddReminder = true }) {
                        Image(systemName: "plus.circle.fill").font(.title2).foregroundColor(.black)
                    }
                }
            }
            .sheet(isPresented: $showAddReminder) {
                AddReminderSheet(itemId: nil, itemName: "General", isPresented: $showAddReminder)
                    .environmentObject(homeStore)
            }
        }
    }

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(AlertFilter.allCases, id: \.self) { f in
                    filterChip(f)
                }
            }
        }
    }

    private func filterChip(_ f: AlertFilter) -> some View {
        Button(action: { filter = f }) {
            Text(f.rawValue)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 16).padding(.vertical, 8)
                .background(filter == f ? Color.black : Color(.systemGray5))
                .foregroundColor(filter == f ? .white : .primary)
                .clipShape(Capsule())
        }
    }

    private var alertList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                if homeStore.urgentCount > 0 && filter == .all {
                    urgentBanner
                }
                ForEach(filtered) { reminder in
                    alertCard(reminder)
                }
                Spacer().frame(height: 20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
        }
    }

    private var urgentBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.red)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text("\(homeStore.urgentCount) urgent reminder\(homeStore.urgentCount == 1 ? "" : "s")")
                    .font(.system(size: 15, weight: .semibold))
                Text("Needs your attention soon").font(.caption).foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(14)
        .background(Color.red.opacity(0.07))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.red.opacity(0.2), lineWidth: 1))
    }

    private func alertCard(_ reminder: MaintenanceReminder) -> some View {
        let daysUntil = Calendar.current.dateComponents([.day], from: Date(), to: reminder.dueDate).day ?? 0
        let isOverdue = daysUntil < 0
        let accentColor: Color = reminder.isCompleted ? .green : (reminder.isUrgent || isOverdue ? .red : .orange)

        return HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(accentColor.opacity(0.12))
                    .frame(width: 48, height: 48)
                Image(systemName: reminder.icon)
                    .font(.system(size: 18))
                    .foregroundColor(accentColor)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.title).font(.system(size: 15, weight: .semibold))
                Text(reminder.itemName).font(.caption).foregroundColor(.secondary)
                dueDateLabel(daysUntil: daysUntil, isOverdue: isOverdue, reminder: reminder)
            }
            Spacer()
            Button(action: { homeStore.toggleReminder(id: reminder.id) }) {
                Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(reminder.isCompleted ? .green : .secondary)
            }
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 6, y: 2)
        .opacity(reminder.isCompleted ? 0.6 : 1.0)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                homeStore.deleteReminder(id: reminder.id)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private func dueDateLabel(daysUntil: Int, isOverdue: Bool, reminder: MaintenanceReminder) -> some View {
        let text: String
        let color: Color
        if reminder.isCompleted {
            text = "Completed"
            color = .green
        } else if isOverdue {
            text = "Overdue by \(abs(daysUntil)) day\(abs(daysUntil) == 1 ? "" : "s")"
            color = .red
        } else if daysUntil == 0 {
            text = "Due today"
            color = .red
        } else {
            text = "Due in \(daysUntil) day\(daysUntil == 1 ? "" : "s")"
            color = daysUntil <= 3 ? .orange : .secondary
        }
        return Text(text).font(.caption.weight(.medium)).foregroundColor(color)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "bell.slash").font(.system(size: 44)).foregroundColor(.secondary.opacity(0.4))
            Text("No alerts").font(.title2.bold())
            Text("Add reminders for maintenance tasks, warranty expirations, and more.")
                .font(.subheadline).foregroundColor(.secondary).multilineTextAlignment(.center)
            Button(action: { showAddReminder = true }) {
                Label("Add Reminder", systemImage: "plus")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.horizontal, 28).padding(.vertical, 14)
                    .background(Color.black).foregroundColor(.white).clipShape(Capsule())
            }
            Spacer()
        }
        .padding(40)
    }
}
