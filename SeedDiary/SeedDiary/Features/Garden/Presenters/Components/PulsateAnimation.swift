//
//  PulsateAnimation.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 17/02/24.
//

import SwiftUI

struct PulsateAnimation: View {
    
    @State private var wave = false
    @State private var wave1 = false
    
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack{
                Circle()
                    .stroke(lineWidth: 40)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray.opacity(0.4))
                    .scaleEffect(wave ? 2 : 1)
                    .opacity(wave ? 0 : 1)
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false).speed(0.5))
                    .onAppear() {
                        self.wave.toggle()
                    }
                Circle()
                    .stroke(lineWidth: 40)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray.opacity(0.4))
                    .scaleEffect(wave1 ? 2 : 1)
                    .opacity(wave1 ? 0 : 1)
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false).speed(0.7))
                    .onAppear() {
                        self.wave1.toggle()
                    }
                Circle()
                    
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray.opacity(0.2))
                    .shadow(radius: 12)
                
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            }
        }
       
        
    }
}

#Preview {
    PulsateAnimation(action: {
        print("1")
    })
}
