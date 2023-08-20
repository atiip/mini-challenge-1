//
//  PopUpDailyMood.swift
//  SeedDiary
//
//  Created by Muhamad Ichsan Al - Qudhori on 06/05/23.
//

import SwiftUI
import CoreData

public struct PopUpDailyMood: View {
    @Binding var isSheetMoodActive: Bool
    @State var mood: String
    @StateObject var moodViewModel: MoodsViewModel = MoodsViewModel()
    @Binding var isSubmitDailyMood:Bool
    
  public var body: some View {
        
        ZStack{
            VStack (alignment: .leading){
                VStack{
                    HStack{
                        Text("How do you feel today?")
                            .font(.system(size: 17))
                            .fontWeight(.bold)
                            .foregroundColor(Color("subtitle-color"))
                        Spacer()
                        Button(action: {
                            isSheetMoodActive = false
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color(.black))
                                .frame(width: 16, height: 16)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 4, trailing: 8))
                    
                }.padding(EdgeInsets(top: 0, leading: 16, bottom: 4, trailing: 16))
                Spacer().frame(height: 28)
                // TODO: Post Daily Mood Here
                HStack (alignment: .center){
                    Spacer()
                    Button(){
                        let calender = Calendar.current
                        let startOfDay = calender.startOfDay(for: Date.now)
                        moodViewModel.createMood(mood: "Sad", date: startOfDay)
                        print("icon-potty-sad")
                        isSheetMoodActive = false
                        isSubmitDailyMood = true
                    } label: {
                        Image("icon-potty-sad")
                            .resizable()
                            .frame(width: 50, height: 43)
                    }
                    Spacer().frame(width: 24)
                    Button(){
                        let calender = Calendar.current
                        let startOfDay = calender.startOfDay(for: Date.now)
                        moodViewModel.createMood(mood: "Neutral", date: startOfDay)
                        print("icon-potty-neutral")
                        isSheetMoodActive = false
                        isSubmitDailyMood = true
                    } label: {
                        Image("icon-potty-neutral")
                            .resizable()
                            .frame(width: 50, height: 43)
                    }
                    Spacer().frame(width: 24)
                    Button(){
                        let calender = Calendar.current
                        let startOfDay = calender.startOfDay(for: Date.now)
                        moodViewModel.createMood(mood: "Happy", date: startOfDay)
                        print("icon-potty-happy")
                        isSheetMoodActive = false
                        isSubmitDailyMood = true
                    } label: {
                        Image("icon-potty-happy")
                            .resizable()
                            .frame(width: 50, height: 43)
                    }
                    Spacer()
                   
                   
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                
                
            }
        }.frame(width: 328 ,height: 154)
            .background(Color(.white)).cornerRadius(15)
                .padding()
                .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 5)
    }
}
