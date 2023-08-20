//
//  CircleVariationModel.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 29/07/23.
//

import Foundation

struct CircleVariationModel: Identifiable,Equatable{
    var id = UUID().uuidString
    var isUsed: Bool = false
    var circles: [CircleModel] = []
    
    init(id: String = UUID().uuidString, isUsed: Bool, circles: [CircleModel]) {
        self.id = id
        self.isUsed = isUsed
        self.circles = circles
    }
}

struct Variation: Identifiable {
    let id: UUID
    var pola: [CircleVariationModel] = []
    var variasi: CircleVariationModel
    
    init(id: UUID = UUID(), jumlah:Int) {
        self.id = id
        
        if (jumlah == 5) {
            self.pola = pola5
        }else if (jumlah == 4){
            self.pola = pola4
        }else if (jumlah == 3){
            self.pola = pola3
        }else if (jumlah == 2){
            self.pola = pola2
        }else{
            self.pola = pola1
        }
        
        var X = Int.random(in: 0...4)
        
        while pola[X].isUsed {
            X = Int.random(in: 0...4)
        }
        
        self.variasi = pola[X]
    }
}

var pola1 : [CircleVariationModel] = [
    
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 150, y:120), size: 140)
    ]),
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 280, y: 260), size: 140)
    ]),
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 100, y: 520), size: 140)
    ]),
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 290, y: 100), size: 140)
    ]),
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 120, y: 240), size: 140)
    ]),
   
    
]
var pola2 : [CircleVariationModel] = [
    
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 150, y: 120), size: 140),
        CircleModel(position: CGPoint(x: 280, y: 320), size: 120),
    ]),
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 280, y: 260), size: 140),
        CircleModel(position: CGPoint(x: 100, y: 330), size: 120),
    ]),
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 100, y: 420), size: 140),
        CircleModel(position: CGPoint(x: 220, y: 220), size: 120),
    ]),
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 290, y: 100), size: 140),
        CircleModel(position: CGPoint(x: 140, y: 280), size: 120),
    ]),
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 120, y: 240), size: 140),
        CircleModel(position: CGPoint(x: 260, y: 540), size: 120),
    ]),

]

var pola3 : [CircleVariationModel] = [
    
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 160, y: 120), size: 100),
        CircleModel(position: CGPoint(x: 280, y: 300), size: 100),
        CircleModel(position: CGPoint(x: 120, y: 420), size: 100),
    ]),
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 280, y: 260), size: 100),
        CircleModel(position: CGPoint(x: 100, y: 330), size: 100),
        CircleModel(position: CGPoint(x: 220, y: 500), size: 100),
    ]),
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 100, y: 520), size: 100),
        CircleModel(position: CGPoint(x: 220, y: 220), size: 100),
        CircleModel(position: CGPoint(x: 270, y: 400), size: 100),
    ]),
    // now here
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 290, y: 100), size: 100),
        CircleModel(position: CGPoint(x: 140, y: 280), size: 100),
        CircleModel(position: CGPoint(x: 100, y: 560), size: 100),
    ]),
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 120, y: 240), size: 100),
        CircleModel(position: CGPoint(x: 260, y: 540), size: 100),
        CircleModel(position: CGPoint(x: 100, y: 560), size: 100),
    ]),

]
var pola4 : [CircleVariationModel] = [
    
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
    ]),
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 280, y: 260), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
    ]),
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 100, y:520), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
    ]),
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 290, y:100), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
    ]),
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 120, y:240), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
    ]),
]
var pola5 : [CircleVariationModel] = [
    
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
    ]),
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 280, y: 260), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
    ]),
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 100, y:520), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
    ]),
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 290, y:100), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
    ]),
    CircleVariationModel(isUsed: false, circles: [
        CircleModel(position: CGPoint(x: 120, y:240), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
        CircleModel(position: CGPoint(x: 150, y:120), size: 100),
    ]),
]
