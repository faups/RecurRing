//
//  AlertsViewModel.swift
//  RecurRing
//
//  Created by Luke Faupel on 3/2/24.
//

import Foundation
import UserNotifications

class AlertsViewModel: ObservableObject {
    @Published var alerts: [RecurringAlert] = [] {
        didSet {
            saveToUserDefaults()
        }
    }
    
    init() {
        loadFromUserDefaults()
    }
    
    func addAlert(name: String, interval: Double) {
        let newAlert = RecurringAlert(name: name, intervalMinutes: interval, isEnabled: true)
        alerts.append(newAlert)
        scheduleNotification(for: newAlert)
    }
    
    func toggleAlert(id: UUID) {
        if let index = alerts.firstIndex(where: { $0.id == id }) {
            alerts[index].isEnabled.toggle()
            if alerts[index].isEnabled {
                scheduleNotification(for: alerts[index])
            } else {
                cancelNotification(for: alerts[index])
            }
        }
    }
    
    func deleteAlert(at offsets: IndexSet) {
        offsets.forEach { index in
            let alert = alerts[index]
            cancelNotification(for: alert)
        }
        alerts.remove(atOffsets: offsets)
    }
    
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(alerts) {
            UserDefaults.standard.set(encoded, forKey: "alerts")
        }
    }
    
    private func loadFromUserDefaults() {
        if let savedAlerts = UserDefaults.standard.data(forKey: "alerts"),
           let decoded = try? JSONDecoder().decode([RecurringAlert].self, from: savedAlerts) {
            alerts = decoded
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    func scheduleNotification(for alert: RecurringAlert) {
        let content = UNMutableNotificationContent()
        content.title = alert.name
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: alert.intervalMinutes * 60, repeats: true)
        
        let request = UNNotificationRequest(identifier: alert.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func cancelNotification(for alert: RecurringAlert) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alert.id.uuidString])
    }
}


