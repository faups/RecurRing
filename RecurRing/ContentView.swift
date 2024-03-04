//
//  ContentView.swift
//  RecurRing
//
//  Created by Luke Faupel on 3/2/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AlertsViewModel()
    @State private var alertName: String = ""
    @State private var intervalMinutes: String = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.alerts) { alert in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(alert.name)
                            Text("Every \(String(format: "%.0f", alert.intervalMinutes)) \(alert.intervalMinutes == 1 ? "minute" : "minutes")")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { alert.isEnabled },
                            set: { _ in viewModel.toggleAlert(id: alert.id) }
                        ))
                    }
                }
                .onDelete(perform: viewModel.deleteAlert)
                
                Section(header: Text("Add New Alert")) {
                    TextField("Alert Name", text: $alertName)
                    TextField("Interval (Minutes)", text: $intervalMinutes)
                        .keyboardType(.numberPad)
                    Button("Add Alert") {
                        if let interval = Double(intervalMinutes) {
                            viewModel.addAlert(name: alertName, interval: interval)
                            alertName = ""
                            intervalMinutes = ""
                        }
                    }
                }
            }
            .navigationBarTitle("RecurRing Alerts")
        }
        .onAppear {
            viewModel.requestNotificationPermission()
        }
    }
}


#Preview {
    ContentView()
}
