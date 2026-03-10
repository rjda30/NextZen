import Foundation
import SwiftUI

struct HomeRoom: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let itemCount: Int
    let color: Color
}

struct HomeItem: Identifiable {
    let id = UUID()
    let name: String
    let brand: String
    let room: String
    let category: String
    let icon: String
    let warrantyExpires: Date?
}

struct MaintenanceAlert: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let dueDate: Date
    let isUrgent: Bool
}

struct SampleData {
    static let rooms: [HomeRoom] = [
        HomeRoom(name: "Living Room", icon: "sofa.fill", itemCount: 12, color: .blue),
        HomeRoom(name: "Kitchen", icon: "refrigerator.fill", itemCount: 18, color: .orange),
        HomeRoom(name: "Bedroom", icon: "bed.double.fill", itemCount: 8, color: .purple),
        HomeRoom(name: "Bathroom", icon: "shower.fill", itemCount: 5, color: .teal),
        HomeRoom(name: "Garage", icon: "car.fill", itemCount: 15, color: .gray),
        HomeRoom(name: "Office", icon: "desktopcomputer", itemCount: 9, color: .indigo)
    ]

    static let items: [HomeItem] = [
        HomeItem(name: "Samsung TV 65\"", brand: "Samsung", room: "Living Room", category: "Electronics", icon: "tv.fill", warrantyExpires: Calendar.current.date(byAdding: .month, value: 8, to: Date())),
        HomeItem(name: "Dyson V15", brand: "Dyson", room: "Living Room", category: "Appliance", icon: "fan.fill", warrantyExpires: Calendar.current.date(byAdding: .month, value: 3, to: Date())),
        HomeItem(name: "KitchenAid Mixer", brand: "KitchenAid", room: "Kitchen", category: "Appliance", icon: "blender.fill", warrantyExpires: Calendar.current.date(byAdding: .year, value: 2, to: Date())),
        HomeItem(name: "Nest Thermostat", brand: "Google", room: "Living Room", category: "Smart Home", icon: "thermometer.medium", warrantyExpires: Calendar.current.date(byAdding: .month, value: 14, to: Date())),
        HomeItem(name: "Bosch Dishwasher", brand: "Bosch", room: "Kitchen", category: "Appliance", icon: "dishwasher.fill", warrantyExpires: Calendar.current.date(byAdding: .month, value: 18, to: Date()))
    ]

    static let alerts: [MaintenanceAlert] = [
        MaintenanceAlert(title: "HVAC Filter Change", subtitle: "Last changed 89 days ago", icon: "wind", dueDate: Date().addingTimeInterval(86400), isUrgent: true),
        MaintenanceAlert(title: "Smoke Detector Battery", subtitle: "Replace batteries", icon: "flame.fill", dueDate: Date().addingTimeInterval(86400 * 3), isUrgent: true),
        MaintenanceAlert(title: "Dishwasher Maintenance", subtitle: "Run cleaning cycle", icon: "dishwasher.fill", dueDate: Date().addingTimeInterval(86400 * 7), isUrgent: false),
        MaintenanceAlert(title: "Dyson V15 Warranty", subtitle: "Expires in 3 months", icon: "exclamationmark.shield.fill", dueDate: Calendar.current.date(byAdding: .month, value: 3, to: Date())!, isUrgent: false)
    ]

    static let categoryDistribution: [(String, Double, Color)] = [
        ("Electronics", 28, .blue),
        ("Appliances", 35, .orange),
        ("Furniture", 20, .purple),
        ("Smart Home", 10, .teal),
        ("Other", 7, .gray)
    ]
}
