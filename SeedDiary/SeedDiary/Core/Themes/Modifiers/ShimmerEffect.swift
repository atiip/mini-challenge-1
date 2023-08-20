//
//  ShimmerEffect.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 30/07/23.
//

import Foundation
import SwiftUI

extension View {
    func shimmer(_ config: ShimmerConfig) -> some View {
        self
            .modifier(ShimmerEffectHelper(config: config))
    }
}

fileprivate struct ShimmerEffectHelper: ViewModifier {
    
    var config: ShimmerConfig
    
    @State var moveTo: CGFloat = -0.7
    
    func body(content: Content) -> some View {
        content
            .hidden()
            .overlay {
                Rectangle()
                    .fill(config.tint)
                    .mask(content)
                    .overlay {
                        GeometryReader {
                            let size = $0.size
                            let extraOffset = $0.size.height / 2.5
                            
                            Rectangle()
                                .fill(config.highlight)
                                .mask {
                                     Rectangle()
                                        .fill(
                                            LinearGradient(colors: [
                                                .white.opacity(0),
                                                config.highlight.opacity(config.highlightOpacity),
                                                .white.opacity(0)
                                            ], startPoint: .top, endPoint: .bottom)
                                        )
                                        .blur(radius: config.blur)
                                        .rotationEffect(Angle(degrees: 60))
                                        .offset(x: moveTo > 0 ? extraOffset : -extraOffset)
                                        .offset(x: size.width * moveTo)
                                }
                        }
                        .mask(content)
                    }
            }
            .onAppear {
                DispatchQueue.main.async {
                    moveTo = 0.7
                }
            }
            .animation(.linear(duration: config.speed).repeatForever(autoreverses: false), value: moveTo)
    }
    
    
}

struct ShimmerConfig {
    var tint: Color
    var highlight: Color
    var blur: CGFloat = 0
    var highlightOpacity: CGFloat = 1
    var speed: CGFloat = 1.5
}

