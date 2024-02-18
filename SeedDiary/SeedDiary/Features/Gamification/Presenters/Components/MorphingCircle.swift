//
//  BigBubble.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 06/05/23.
//

import SwiftUI
import Foundation
import CoreData

struct MorphingCircle: View & Identifiable & Hashable {
    
    let id = UUID()
    @State var morph: AnimatableVector = AnimatableVector.zero
    @State var timer: Timer?
    
    static func == (lhs: MorphingCircle, rhs: MorphingCircle) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func morphCreator() -> AnimatableVector {
        let range = Float(-morphingRange)...Float(morphingRange)
        var morphing = Array.init(repeating: Float.zero, count: self.points)
        for i in 0..<morphing.count where Int.random(in: 0...1) == 0 {
            morphing[i] = Float.random(in: range)
        }
        return AnimatableVector(values: morphing)
    }
    
    func update() {
        morph = morphCreator()
    }
    
    let duration: Double
    let points: Int
    let secting: Double
    let size: CGFloat
    let outerSize: CGFloat
    let morphingRange: CGFloat
    
    var radius: CGFloat {
        outerSize / 2
    }
    
    var idx: Int
    @Binding var pola: CircleVariationModel
    @State var color: Color = Color.indigo
    @State var isOpacity = false
    @State var checkJournal = false
    @State var checkOnTap = false
    
    @Binding var isUpdated: Bool
    @Binding var totalActivity:Int
    @Binding var isTaskActive:Bool
    
    @State private var scale = 1.0
    @State var isExploded: Bool = false
    private let explodingBits: Int = 15
    
    @State var labelCircle = ""
    @State var isJournalViewPresented: Bool = false
    @State var isSubmitJournal: Bool = false
    @State var isDailyMoodPresented: Bool = false
    
    @Binding var showJournal: Bool
    @Binding var showDailyMood: Bool
    @Binding var isSheetMoodActive:Bool
    @Binding var isSubmitDailyMood:Bool
    @State var activityName: String = ""
    @Binding var progressBarActive:Bool
    

    @EnvironmentObject var router: Router
    @EnvironmentObject var moodsVM: MoodsViewModel
    @EnvironmentObject var userViewModel: PersonalInformationViewModel
    @EnvironmentObject var activitiesVM: ActivityViewModel
    
    var body: some View {
        ZStack{
            if (labelCircle == "Journal"){
                ForEach(0..<explodingBits, id: \.self) { _ in
                    
                    SmallCircle(idx: idx, isExploded: isExploded, isOpacity: isOpacity, pola: $pola, labelCircle:$labelCircle)
                }
                
                MorphingCircleShape(morph)
                    .fill(Color("bg-mood-journal"))
                    .frame(width: 150, height: 150, alignment: .center)
                    .animation(Animation.easeInOut(duration: Double(duration + 1.0)), value: morph)
                    .position(x:350, y: 200)
                    .onTapGesture {
                        isJournalViewPresented = true
                    }.onAppear {
                        update()
                        timer = Timer.scheduledTimer(withTimeInterval: duration / secting, repeats: true) { timer in
                            update()
                        }
                    }.onDisappear {
                        timer?.invalidate()
                    }
                    .opacity(checkOnTap ? 0 : 1)
                    .onChange(of: isSubmitJournal) { newValue in
                        if newValue  {
                            withAnimation (Animation.easeInOut(duration: 0.5)){
                                self.color = Color.indigo
                                checkOnTap.toggle()
                                isExploded.toggle()
                                isOpacity.toggle()
                                isUpdated = true
                                
                                pola = Variation(jumlah: totalActivity).variasi
                                
                                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                    
                                    if (totalActivity == 0){
                                        isTaskActive = false
                                    }
                                }
                                
                                showJournal = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                withAnimation{
                                    checkOnTap.toggle()
                                    isExploded.toggle()
                                    isOpacity.toggle()
                                    scale -= 0.5
                                }
                            }
                        }
                    }
                
                Text("Journal")
                    .position(x:350, y: 200)
                    .animation(Animation.easeInOut(duration: Double(duration + 1.0)), value: morph)
            }
            else if (labelCircle == "Daily Mood"){
                ForEach(0..<explodingBits, id: \.self) { _ in
                    
                    SmallCircle(idx: idx, isExploded: isExploded, isOpacity: isOpacity, pola: $pola, labelCircle:$labelCircle)
                }
                
                MorphingCircleShape(morph)
                    .fill(Color("bg-mood-journal"))
                    .frame(width: 120, height: 120, alignment: .center)
                    .animation(Animation.easeInOut(duration: Double(duration + 1.0)), value: morph)
                    .position(x:100, y: 200)
                    .onTapGesture (count: 1) {
                        isDailyMoodPresented = true
                        isSheetMoodActive = true
                    }.onAppear {
                        update()
                        timer = Timer.scheduledTimer(withTimeInterval: duration / secting, repeats: true) { timer in
                            update()
                        }
                    }.onDisappear {
                        timer?.invalidate()
                    }
                    .opacity(checkOnTap ? 0 : 1)
                    .onChange(of: isSubmitDailyMood) { newValue in
                        if newValue  {
                            withAnimation (Animation.easeInOut(duration: 0.5)){
                                self.color = Color.indigo
                                checkOnTap.toggle()
                                isExploded.toggle()
                                isOpacity.toggle()
                               
                                isUpdated = true
                                
                                
                                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                    
                                    if (totalActivity == 0){
                                        isTaskActive = false
                                    }
                                }
                                
                                showDailyMood = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                withAnimation{
                                    checkOnTap.toggle()
                                    isExploded.toggle()
                                    isOpacity.toggle()
                                    scale -= 0.5
                                }
                            }
                        }
                    }
                    .blur(radius: isDailyMoodPresented ? 3 : 0)
                
                Text("Daily Mood")
                    .position(x:100, y: 200)
                    .animation(Animation.easeInOut(duration: Double(duration + 1.0)), value: morph)
                
            }
            else{
                ForEach(0..<explodingBits, id: \.self) { _ in
                    
                    SmallCircle(idx: idx, isExploded: isExploded, isOpacity: isOpacity, pola: $pola, labelCircle:$labelCircle)
                }
                
                MorphingCircleShape(morph)
                    .fill(Color("bg-circle-activity"))
                    .frame(width: pola.circles[idx].size, height: pola.circles[idx].size, alignment: .center)
                    .animation(Animation.easeInOut(duration: Double(duration + 1.0)), value: morph)
                    .position(x:pola.circles[idx].position.x, y: pola.circles[idx].position.y)
                    .onTapGesture(count: 2) {
                        withAnimation (Animation.easeInOut(duration: 0.5)){
                            self.color = Color.indigo
                            checkOnTap.toggle()
                            isExploded.toggle()
                            isOpacity.toggle()
                            
                            activitiesVM.filteredActivityByUser[idx].status = true
                            
                            activitiesVM.filteredActivityByUser[idx].completeDate = Date()
                            
                            activitiesVM.save()
                            let act = activitiesVM.filteredActivityByUser[idx]
                            
                            if let currentGoal = act.goals {
                                activitiesVM.totalCurrentActivity = activitiesVM.getActivitiesByGoalInReturn(goal: currentGoal).count
                                activitiesVM.totalActivityIsDone = activitiesVM.getCompletedActivityByUser(goal: currentGoal)
                                activitiesVM.calculateActivityDone(totalActivity: activitiesVM.totalCurrentActivity, stepDone: activitiesVM.totalActivityIsDone, containerWidth: 250)
                            }
                            
                            isUpdated = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()+1) {

                                progressBarActive = true
                                
                                if (totalActivity == 0){
                                    isTaskActive = false
                                }
                            }
                            
                        }
                        
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                            withAnimation{
                                checkOnTap.toggle()
                                isExploded.toggle()
                                isOpacity.toggle()
                                scale -= 0.5
                            }
                        }
                    }
                
                    .onTapGesture (count: 1) {
                        self.color = Color.brown
                    }.onAppear {
                        update()
                        timer = Timer.scheduledTimer(withTimeInterval: duration / secting, repeats: true) { timer in
                            update()
                        }
                    }.onDisappear {
                        timer?.invalidate()
                    }
                    .opacity(checkOnTap ? 0 : 1)
                
                Text("\(activityName)")
                    .foregroundColor(.white)
                    .position(x:pola.circles[idx].position.x, y: pola.circles[idx].position.y)
                
            }
        }
        
        // Sheet Journal
        .sheet(isPresented: $isJournalViewPresented) {
            ListJournalView(isJournalViewPresented: $isJournalViewPresented, isSubmitJournal: $isSubmitJournal)
                .environmentObject(userViewModel)
                .presentationDetents([.height(700)])
                .presentationDragIndicator(.visible).environmentObject(router)
        }
        // Sheet daily mood
        .sheet(isPresented: $isDailyMoodPresented) {
            PopUpDailyMood(isSheetMoodActive: $isSheetMoodActive, mood: "", isSubmitDailyMood: $isSubmitDailyMood)
                .environmentObject(userViewModel)
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
        }
    }
}




