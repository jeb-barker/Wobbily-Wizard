//
//  ContentView.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 10/7/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}
struct Cauldren: View {
    var body: some View {
        Text("Hello, Cauldren!")
    }
}
struct Shop: View {
    var body: some View {
        Text("Hello. Shop!")
    }
}

#Preview {
    ContentView()
}
