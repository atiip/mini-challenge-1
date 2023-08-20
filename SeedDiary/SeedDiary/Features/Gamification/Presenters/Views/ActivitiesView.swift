//
//  ActivitiesView.swift
//  SeedDary
//
//  Created by Muhammad Athif on 02/05/23.
//


import SwiftUI
import CoreData

struct ActivitiesView: View {
    @State var quotes : [String] = [
        "What a happy day today",
        "Find Happiness Today",
        "Lets Process Our Day"
    ]
    
    @State private var mood = ""
    @State private var isTaskActive = true
    
    @State private var color = Color.blue

    @State var checkJournal = false
    @State var checkOnTap = false

    @State var isExploded = false
    @State var isOpacity = false
    
    @State private var showJournal = true
    @State private var showDailyMood = true

    private let explodingBits: Int = 15
    let screenSize = UIScreen.main.bounds.size
    
    // Rumus get activity + 2
    @State var totalActivity:Int = 3
    @State private var scale = 1.0
    @State var pola: CircleVariationModel
    @State var listDataGoal: [Goal] = []
    @State var listJournal: [Journal] = []
    @State var listDailyMoods: [Mood] = []
    @State var listActivityTrue: [Goal] = []
    @State var listAllActivity: [Goal] = []
    @State var isSheetMoodActive = false
    @State var updated = false
    @State var isSubmitDailyMood: Bool = false
    @State var goalName:String =  ""
    
    
//    public func checkStatusActivity() -> Int {
//        @State var countStatus: Int = 0
//        ForEach(listDataGoal.status, id: \.self) { status in
//            countStatus+=1
//        }
//        return countStatus
//    }
//    @State var countStatus: Int = 0
    
    
        
    public func convertDate(date: Date) -> Date {
        let calender = Calendar.current
        let startOfDay = calender.startOfDay(for: date)
        return startOfDay
    }
    @State var progress: CGFloat = 0
    @State var containerWidth:CGFloat = 0
    
//    let progress = (droppedCount / CGFloat(characters.count))
//    withAnimation{
//        item.isShowing = true
//        updateShuffledArray(character: "\(url)")
//        self.progress = progress
//    }
    @State var totalActivityProgress = 3
    @State var stepDone = 0
    @State var statusProgress: Double = 0
    @State var progressBarActive = false
    @State var actName = ""
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack{
            VStack{
                // AppBar
                HStack{
                    Text(Date(), style: .date)
                    Spacer()
                Button{
                } label:{
                    Image("icon-achievement")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    }
                }.frame(width: UIScreen.main.bounds.width-50)
                Spacer()

                // Content
                // TODO: if bubble = 0, maka gambar dan text yang muncul (Berdasarkan mood yang ada). Jika ada bubble, gambarnya kebawah dan bubble muncul.
                //
                
                VStack(alignment: .center){
                  
                    if (isTaskActive){
                        HStack{
                            GeometryReader{proxy in
                                ZStack(alignment: .leading){
                                    Capsule()
                                        .fill(Color("bg-progress-bar"))
                                        .frame(width: statusProgress)
                                    //                                        .fill(Color("bg-progress-bar"))
                                        .frame(width: statusProgress)
//                                        .overlay(Capsule()
//                                            .stroke(Color("border-progress-bar"), lineWidth: 3))
                                        .onAppear{
                                            containerWidth = proxy.size.width
                                        }
                                    
                                    
                                    //                                }.frame(height: 20)
                                    ZStack(alignment: .leading){
                                        ////
                                        Capsule().fill(Color("progress-fill-color")).frame(width: statusProgress)
                                            .animation(Animation.easeInOut(duration: Double( 1.0)), value: statusProgress)
                                        
                                        HStack(alignment: .center){
                                            Text("\(stepDone) / \(totalActivityProgress)")
                                                .foregroundColor(Color(.black))
                                                .padding(EdgeInsets(top: 16, leading: 12, bottom: 12, trailing: 12))
                                            
                                        }.frame(width: containerWidth)
                                        
                                        
                                    }
                                }
                                
                                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 2, y: 4)
                            }
                            .frame(height: 20)
                        }.frame(height:20)
                        .opacity(progressBarActive ? 1 : 0)
                        .onChange(of: progressBarActive){ newValue in
                            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                
                                    withAnimation{
                                        progressBarActive = false
                                }
                            }
                            
                        }
                        .onAppear(){
                            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                
                                    withAnimation{
                                        progressBarActive = false
                                }
                            }
                        }
                        
                        .padding(EdgeInsets(top: 50, leading: 12, bottom: 0, trailing: 12))
                        Spacer()
                        ZStack{
                            //bar
                            
                            
                            
                                ForEach(listDataGoal.indices, id: \.self) { idx in
                                    //                            Text((pola.circles[idx].isAppear) ? "true" : "false")
                                    //                            if (pola.circles[idx].isAppear == true){
                                    //                                BigBubble(idx: idx, pola: $pola, totalActivity: $totalActivity, isTaskActive: $isTaskActive)
                                    //                            }
                                    
                                    if var status = listDataGoal[idx].status as? Bool, !status {
                                        var activityName = listDataGoal[idx].activity ?? ""
                                        var goalName = listDataGoal[idx].goal ?? ""
//                                        goalName = actName
                                        MorphingCircle(duration: 3.0, points: 4, secting: 2, size: 150, outerSize: 30, morphingRange: 10, idx: idx, pola: $pola, isUpdated: $updated, totalActivity: $totalActivity, isTaskActive: $isTaskActive, listDataGoal: $listDataGoal,labelCircle: "Activity", showJournal: $showJournal, showDailyMood: $showDailyMood, isSheetMoodActive: $isSheetMoodActive, isSubmitDailyMood:$isSubmitDailyMood, activityName: activityName, progressBarActive: $progressBarActive, goalName: goalName, totalActivityProgress: $totalActivityProgress, stepDone: $stepDone,  statusProgress :$statusProgress, containerWidth: $containerWidth
                                                       
                                        ).environmentObject(router)
                                    }
                                }
                                
                                if showJournal {
                                    MorphingCircle(duration: 3.0, points: 4, secting: 2, size: 150, outerSize: 30, morphingRange: 10, idx: -1, pola: $pola, isUpdated: $updated, totalActivity: $totalActivity, isTaskActive: $isTaskActive, listDataGoal: $listDataGoal, labelCircle: "Journal", showJournal: $showJournal, showDailyMood: $showDailyMood, isSheetMoodActive: $isSheetMoodActive, isSubmitDailyMood:$isSubmitDailyMood, progressBarActive: $progressBarActive, goalName: goalName,  totalActivityProgress: $totalActivityProgress, stepDone: $stepDone,  statusProgress :$statusProgress, containerWidth: $containerWidth
                                    ).environmentObject(router)
                                }
                                
                                if showDailyMood{
                                    MorphingCircle(duration: 3.0, points: 4, secting: 2, size: 150, outerSize: 30, morphingRange: 10, idx: -1, pola: $pola, isUpdated: $updated, totalActivity: $totalActivity, isTaskActive: $isTaskActive, listDataGoal: $listDataGoal, labelCircle: "Daily Mood",showJournal: $showJournal, showDailyMood: $showDailyMood, isSheetMoodActive: $isSheetMoodActive, isSubmitDailyMood:$isSubmitDailyMood, progressBarActive: $progressBarActive, goalName: goalName,  totalActivityProgress: $totalActivityProgress, stepDone: $stepDone, statusProgress :$statusProgress, containerWidth: $containerWidth
                                    ).environmentObject(router)
                                    
                                }
                        }.frame(width: screenSize.width,height: screenSize.height * 0.6)
                        Image("home-bg")
                            .resizable()
                            .frame(width: 280, height: 160)
                        Spacer().frame(height: 160)
                    }
                    else {
                        switch mood{
                        case "Happy":
                            Text(quotes[0])
                                            .foregroundColor(Color(red: 77/255, green: 111/255, blue: 86/255))
                                            .shadow(color: .gray, radius: 1, x: 0, y: 2)
                                            .fontWeight(.semibold)
                            ZStack{
                                Image("happy-bg")
                                    .resizable()
                                    .frame(width: 280, height: 200)
                                }
                        case "Neutral":
                            Text(quotes[1])
                                            .foregroundColor(Color(red: 77/255, green: 111/255, blue: 86/255))
                                            .shadow(color: .gray, radius: 1, x: 0, y: 2)
                                            .fontWeight(.semibold)
                            ZStack{
                                Image("neutral-bg")
                                    .resizable()
                                    .frame(width: 280, height: 200)
                                }
                        case "Sad":
                            Text(quotes[2])
                                            .foregroundColor(Color(red: 77/255, green: 111/255, blue: 86/255))
                                            .shadow(color: .gray, radius: 1, x: 0, y: 2)
                                            .fontWeight(.semibold)
                            ZStack{
                                Image("sad-bg")
                                    .resizable()
                                    .frame(width: 280, height: 200)
                                }
                        default:
                            ZStack{
                                Image("home-bg")
                                    .resizable()
                                    .frame(width: 280, height: 200)
                                }.scaleEffect(scale)
        
                                .animation(.linear(duration: 1), value: scale)
                         
                        }
                    }
                }.frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity
                    )
                Spacer()
            }
        }
        .onAppear {
            print("List \(listDataGoal)")
            
//            1. listGoal ambil nama Goals
//            2. nama goal masuk ke state name goal
//            3.state nama goal dilooping ke func count activity
//            4.

            if (checkStatusActivity(listDataGoal: listActivityTrue) == listAllActivity.count){
                if(!listDailyMoods.isEmpty && !listJournal.isEmpty){
                    print("Masuk sini ga ya")
                    isTaskActive = false
                }
            }
                
            
            if !listJournal.isEmpty {
                showJournal = false
                print("masuk journal")
                print(showJournal)
            }
            if !listDailyMoods.isEmpty {
                showDailyMood = false
                print("masuk daily mood")
                print(showDailyMood)
            }
            
        }
        .onChange(of: updated) { newValue in
            if newValue {
                updated = false
            }
        }
    }
}



public func checkStatusActivity(listDataGoal: [Goal]) -> Int {
    var countStatus: Int = 0
    for goal in listDataGoal {
        if (goal.status == true) {
            countStatus += 1
        }
        
    }
    return countStatus
}

struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        let totalActivity: Int = 3
        let pola = Variation(jumlah: totalActivity).variasi
        ActivitiesView(pola: pola)
        }
}



