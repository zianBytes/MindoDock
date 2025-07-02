//
//  ContentView.swift
//  MindoDock
//
//  Created by Zian Miad on 7/2/25.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack(spacing: 20) {
            // GPT Widget
            VStack {
                Text("🧠 Ask Mindo")
                    .font(.headline)
                Button("Type here...") {
                    // will expand later
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(width: 150, height: 80)
            .background(.thinMaterial)
            .cornerRadius(15)

            // Clock Widget
            VStack {
                Text(Date(), style: .time)
                    .font(.largeTitle)
                Text(Date(), style: .date)
                    .font(.caption)
            }
            .frame(width: 120, height: 80)
            .background(.thinMaterial)
            .cornerRadius(15)

            // Notes Widget
            VStack(alignment: .leading) {
                Text("📝 Notes")
                    .font(.headline)
                Text("Start writing...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(width: 200, height: 80)
            .background(.thinMaterial)
            .cornerRadius(15)
        }
        .padding()
    }
}

