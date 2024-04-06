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
            VStack {
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
                
//                ZStack {
//                    Circle()
//                        .foregroundColor(.blue)
//                        .opacity(0.3)
//                        .scaleEffect(0.8)
//                    
////                    Circle()
////                        .stroke(lineWidth: 25)
////                        .opacity(0.2)
////                        .foregroundColor(.white)
////                        .shadow(radius: 5)
//                    
//                    Circle()
//                        .trim(from: 0, to: 0.65)
//                        .stroke(style: StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round))
//                        .opacity(0.8)
//                        .foregroundColor(.blue)
//                        .rotationEffect(Angle(degrees: -90))
////                        .animation(.linear)
//    
//                    Circle()
////                        .trim(from: 0.6, to: 0.8)
//                        .stroke(style: StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round))
//                        .opacity(0.2)
//                        .foregroundColor(.gray)
//                        .rotationEffect(Angle(degrees: 90))
////                        .animation(.linear)
//                    
//                    VStack {
//                        Text("💧")
//                            .font(.custom("", size: 45))
//                        
//                        Text("in 10 minutes")
//                    }
//                }
//                .frame(width: 200, height: 200)
//                .padding(.top, 100)
//                .padding(.bottom, 50)
            }
        }
        .onAppear {
            viewModel.requestNotificationPermission()
        }
    }
}


#Preview {
    ContentView()
}
