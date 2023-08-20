//
//  OpeningModel.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 30/07/23.
//

import Foundation
struct OpeningModel : Identifiable, Equatable {
    let id = UUID()
    var description: String
    var backimageUrl: String
    var frontimageUrl: String
    var tag: Int
    var type: Pagetype = .basic
    
    static var samplePage = OpeningModel(description: "Bring your journaling journey differntly", backimageUrl: "opening-bg", frontimageUrl: "icon-potty-happy", tag: 0)
    
    static var samplePages : [OpeningModel] = [
        OpeningModel(description: "Hi, welcome to I am Pottt. I am going to help you grow your journey", backimageUrl: "opening-bg", frontimageUrl: "icon-potty-happy", tag: 0),
        OpeningModel(description: "What's your name", backimageUrl: "opening-bg", frontimageUrl: "icon-potty-happy", tag: 1),
        OpeningModel(description: "As I grow, I believe you also will grow", backimageUrl: "opening-bg", frontimageUrl: "icon-potty-happy", tag: 2),
        OpeningModel(description: "So, let’s we start our journey together, shall we?", backimageUrl: "opening-bg", frontimageUrl: "icon-potty-happy", tag: 3)
    ]
    
    enum Pagetype{
        case basic, form
    }
}
