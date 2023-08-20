//
//  SmallBubble.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 06/05/23.
//
//
//  SmallBubble.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 06/05/23.
//

import SwiftUI

struct SmallCircle: View {
    
    var idx: Int
   
//    @State var isOpacity: Bool
//    @State var isExploded: Bool
       @Binding var pola: CircleVariationModel
   //    @State private var isOpacity = false
   //    @State private var isExploded = flase
   
   
       @State private var color = Color.blue
    
    var isExploded = false
    var isOpacity = false
    
    @Binding var labelCircle:String
    
    
    var body: some View {
        if (labelCircle == "Journal"){
            Circle()
                .rotation(Angle(degrees: Double.random(in: 0..<360)))
                .frame(width: 20, height: 20)
                .foregroundColor(Color("bg-mood-journal"))
                .position(x:350, y: 200)
                .offset(
                    x: isExploded ? (Double.random(in: -1...1) * 150) : 0,
                    y: isExploded ? (Double.random(in: -1...1) * 150) : 0)
            
                .opacity(isOpacity ? 0 : 1)
                .animation(.easeInOut.speed(0.6), value: isExploded)
                .padding()
        }else if (labelCircle == "Daily Mood"){
            Circle()
                .rotation(Angle(degrees: Double.random(in: 0..<360)))
                .frame(width: 20, height: 20)
                .foregroundColor(Color("bg-mood-journal"))
                .position(x:100, y: 200)
//                .frame(width: 120, height: 120, alignment: .center)
                .offset(
                    x: isExploded ? (Double.random(in: -1...1) * 150) : 0,
                    y: isExploded ? (Double.random(in: -1...1) * 150) : 0)
            
                .opacity(isOpacity ? 0 : 1)
                .animation(.easeInOut.speed(0.6), value: isExploded)
                .padding()
        }else{
            Circle()
                .rotation(Angle(degrees: Double.random(in: 0..<360)))
                .frame(width: 20, height: 20)
                .foregroundColor(Color("bg-circle-activity"))
                .position(x:pola.circles[idx].position.x, y: pola.circles[idx].position.y)
                .offset(
                    x: isExploded ? (Double.random(in: -1...1) * 150) : 0,
                    y: isExploded ? (Double.random(in: -1...1) * 150) : 0)
            
                .opacity(isOpacity ? 0 : 1)
                .animation(.easeInOut.speed(0.6), value: isExploded)
                .padding()
        }
       
    }
}

