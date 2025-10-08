//
//  Home.swift
//  Wobbily Wizard
//
//  Created by Jeb Barker on 10/7/25.
//

import SwiftUI

struct Home: View {
    var body: some View {
        VStack {
            LinearProgressView().frame(alignment: .top)
            Spacer()
            CircleRotation().frame(alignment: .bottom)
        }
        .padding()
    }
}



struct CircleRotation: View {
    @State private var degrees: Double = 0

    var body: some View {
        Image(systemName: "globe.americas")
            .resizable()
            .frame(width: 200, height: 200)
            .foregroundColor(.blue)
            .rotationEffect(Angle(degrees: degrees)) // Apply rotation effect
            .animation(Animation.linear(duration: 15).repeatForever(autoreverses: false), value: degrees) // Apply animation
            .onAppear {
                degrees = 360
            }
    }
}

struct LinearProgressView: View {
    @State private var progress = 0.5

    var body: some View {
        VStack {
            ProgressView(value: progress)
                .progressViewStyle(PurplePotionProgressViewStyle())
            Button("More") {
                if progress > 1 {
                    progress = 0
                }
                else {
                    progress += 0.05;
                }
            }
        }
    }
}

struct PurplePotionProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .leading) {
            let barHeight: CGFloat = 35
            GeometryReader {
                geometry in
                let totalWidth = geometry.size.width
                //Outer Rectangle for progress bar
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: barHeight)
                    .foregroundColor(.gray.opacity(0.3))
                
                //Inner Rectangle for progress bar
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * totalWidth, height: barHeight)
                    .foregroundColor(.purple)
            }.frame(height: barHeight) // have to limit height bc GeometryReader takes up all available space
        }
    }
}

#Preview {
    Home()
}
