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
    static func == (lhs: MorphingCircle, rhs: MorphingCircle) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id = UUID()
    @State var morph: AnimatableVector = AnimatableVector.zero
    @State var timer: Timer?
    
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
    
    @Binding var listDataGoal: [Goal]
    

    
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
    
    @State var goalName: String = ""
    @Binding var totalActivityProgress: Int
    @Binding var stepDone: Int
    @Binding var statusProgress: Double
    @Binding var containerWidth: CGFloat
    
    @EnvironmentObject var router: Router
    var body: some View {
        ZStack{
            if (labelCircle == "Journal"){
                ForEach(0..<explodingBits, id: \.self) { _ in
                    
                    SmallCircle(idx: idx, pola: $pola,isExploded: isExploded, isOpacity: isOpacity, labelCircle:$labelCircle)
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
    //                    .animation(.easeInOut.speed(0.6), value: checkOnTap)
                    .opacity(checkOnTap ? 0 : 1)
                    .onChange(of: isSubmitJournal) { newValue in
                        if newValue  {
                            withAnimation (Animation.easeInOut(duration: 0.5)){
                                self.color = Color.indigo
                                //                                        checkJournal.toggle()
                                checkOnTap.toggle()
                                isExploded.toggle()
                                isOpacity.toggle()
                    //                        print(, to: &<#T##TextOutputStream#>)
                                
                    //                        pola.circles[idx].isAppear = false
                    //                        pola = Variation(jumlah: totalActivity).variasi
                    //
                    //                            listDataGoal[idx].status = true
                                // Save
//                                do {
//                                    try Helper.viewContext.save()
//                                } catch {
//                                    print(error)
//                                }
//                                
                                isUpdated = true
                                
                                print("Ini data listGoal \(listDataGoal)")
                                pola = Variation(jumlah: totalActivity).variasi
                                
                                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                    
                                    
                                    print("ini adalah pola: \(pola)")
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
                    
                    SmallCircle(idx: idx, pola: $pola,isExploded: isExploded, isOpacity: isOpacity, labelCircle:$labelCircle)
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
                    }    //                    .animation(.easeInOut.speed(0.6), value: checkOnTap)
                    .opacity(checkOnTap ? 0 : 1)
                    .onChange(of: isSubmitDailyMood) { newValue in
                        if newValue  {
                            withAnimation (Animation.easeInOut(duration: 0.5)){
                                self.color = Color.indigo
                                //                                        checkJournal.toggle()
                                checkOnTap.toggle()
                                isExploded.toggle()
                                isOpacity.toggle()
                    //                        print(, to: &<#T##TextOutputStream#>)
                                
                    //                        pola.circles[idx].isAppear = false
                    //                        pola = Variation(jumlah: totalActivity).variasi
                    //
                    //                            listDataGoal[idx].status = true
                                // Save
//                                do {
//                                    try Helper.viewContext.save()
//                                } catch {
//                                    print(error)
//                                }
                                
                                isUpdated = true
                                
                                print("Ini data listGoal \(listDataGoal)")
                                pola = Variation(jumlah: totalActivity).variasi
                                
                                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                    
                                   
                                    print("ini adalah pola: \(pola)")
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
                    
                    SmallCircle(idx: idx, pola: $pola,isExploded: isExploded, isOpacity: isOpacity, labelCircle:$labelCircle)
                }
                
                MorphingCircleShape(morph)
                    .fill(Color("bg-circle-activity"))
                    .frame(width: pola.circles[idx].size, height: pola.circles[idx].size, alignment: .center)
                    .animation(Animation.easeInOut(duration: Double(duration + 1.0)), value: morph)
                    .position(x:pola.circles[idx].position.x, y: pola.circles[idx].position.y)
                    .onTapGesture(count: 2) {
                        withAnimation (Animation.easeInOut(duration: 0.5)){
                            self.color = Color.indigo
                            //                                        checkJournal.toggle()
                            checkOnTap.toggle()
                            isExploded.toggle()
                            isOpacity.toggle()
    //                        print(, to: &<#T##TextOutputStream#>)
                            
    //                        pola.circles[idx].isAppear = false
    //                        pola = Variation(jumlah: totalActivity).variasi
    //
                            listDataGoal[idx].status = true
                            // Save
//                            do {
//                                try Helper.viewContext.save()
//                            } catch {
//                                print(error)
//                            }
                            
                            isUpdated = true
//                            self.totalActivityProgress = Goal.getActivityByGoal(viewContext: PersistenceController.preview.container.viewContext, goal: goalName).count
//
//                            self.stepDone = Goal.getActivityCompleteByGoal(viewContext: PersistenceController.preview.container.viewContext, goal: goalName).count
                            print("iNi total activity progress \(totalActivityProgress)")
                                        
                            print("Ini data listGoal \(listDataGoal)")
                            pola = Variation(jumlah: totalActivity).variasi
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                
                                progressBarActive = true
                                statusProgress = calculateActivityDone(totalActivityProgress: totalActivityProgress, stepDone: stepDone, containerWidth: containerWidth)
                                print("ini adalah pola: \(pola)")
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
                                print(activityName)
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
    //                    .animation(.easeInOut.speed(0.6), value: checkOnTap)
                    .opacity(checkOnTap ? 0 : 1)
                
                Text("\(activityName)")
//                    .font(.system(size: 17))
                    .foregroundColor(.white)
                    .position(x:pola.circles[idx].position.x, y: pola.circles[idx].position.y)
                   
//
//                    .frame(width: pola.circles[idx].size, height: pola.circles[idx].size, alignment: .center)
            }
        }
        
        .sheet(isPresented: $isJournalViewPresented) {
            ListJournalView(isJournalViewPresented: $isJournalViewPresented, isSubmitJournal: $isSubmitJournal)
                .presentationDetents([.height(700)])
                .presentationDragIndicator(.visible).environmentObject(router)
        }
        
        .sheet(isPresented: $isDailyMoodPresented) {
            PopUpDailyMood(isSheetMoodActive: $isSheetMoodActive, mood: "", isSubmitDailyMood: $isSubmitDailyMood)
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
//        destination: DetailActivity(
//            viewActivityModel: ActivityViewModel(viewContext: PersistenceController.preview.container.viewContext, goal: goal_)
//        ),
        }
//        .sheet(isPresented: $isDailyMoodPresented) {
//
//
//        }
            
            
//            if isDailyMoodPresented{
//
//            }
       
    }
//    func size(_ newSize: CGFloat) -> MorphingCircle {
//            var sizeNew = self
//            sizeNew.size = newSize
//            return sizeNew
//        }
//    init(_ size:CGFloat = 300, morphingRange: CGFloat = 30, color: Color = .indigo, points: Int = 4,  duration: Double = 3.0, secting: Double = 2) {
//        self.points = points
////        self.color = color
//        self.morphingRange = morphingRange
//        self.duration = duration
//        self.secting = secting
//        self.size = morphingRange * 2 < size ? size - morphingRange * 2 : 5
//        self.outerSize = size
////        morph = AnimatableVector(values: [])
////        update()
//    }
//
//    func color(_ newColor: Color) -> MorphingCircle {
//        var morphNew = self
//        morphNew.color = newColor
//        return morphNew
//    }
}

public func calculateActivityDone(totalActivityProgress : Int, stepDone : Int, containerWidth: CGFloat)  -> Double {
    return min(containerWidth / CGFloat(totalActivityProgress) * CGFloat(stepDone), containerWidth)
}

//struct Helper {
//    public static let viewContext: NSManagedObjectContext = PersistenceController.preview.container.viewContext
//}
