//
//  StatisticView.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 01/08/23.
//

import SwiftUI
import Charts

struct CompletedActivitySummaryView: Identifiable {
    var id = UUID().uuidString
    var period: String
    var date: Date
    var count: Double
    var animate: Bool = false
}

struct StatisticView: View {
    // MARK: State Chart Data For Animation Changes
    @State private var activitySummaries: [CompletedActivitySummaryView] = []
    // MARK: View Properties
    @State var currentTab: String = "Week"
    // MARK: Gesture Properties
    @State var currentActiveItem: CompletedActivitySummaryView?
    @State var plotWidth: CGFloat = 0
    @State var isLineGraph: Bool = false
    
    @EnvironmentObject var activitiesViewModel: ActivityViewModel
    @EnvironmentObject var userViewModel: PersonalInformationViewModel
    @EnvironmentObject var goalsViewModel: GoalsViewModel
    
    var body: some View {
        VStack{
            HStack{
                Text("Activities Reports Chart")
                    .fontWeight(.bold)
                    .font(.system(size: 24))
                Spacer()
            }
            Spacer()
                .frame(height: 24)
            // AppBar
            VStack(alignment: .leading, spacing: 12){
                HStack{
                    Text("Total activities")
                        .fontWeight(.bold)
                    Spacer()
                    
                    Picker("", selection: $currentTab) {
                        Text("Week")
                            .tag("Week")
                        Text("Month")
                            .tag("Month")
                    }
                    .pickerStyle(.segmented)
                    .padding(.leading, 80)
                }
                
                let totalValue = activitySummaries.reduce(0.0){ partialResult, item in
                    item.count + partialResult
                     
                }
                
                Text(totalValue.stringFormat)
                    .font(.largeTitle.bold())
                
                AnimatedChart()
            }
            
            Toggle("Line Graph", isOn: $isLineGraph)
                .padding(.top)
            
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity, alignment: .top)
        .onAppear() {
            updateChartData()
        }
        
        .padding()
        //MARK: Update data
        .onChange(of: currentTab) { newValue in
            //Reanimate Graph
            updateChartData()
        }
    }
    
    func updateChartData() {
          
            let periodFilter = currentTab
            let idUser = UUID(uuidString: UserDefaults.standard.string(forKey: "userID") ?? "") ?? UUID()
            
            if let user = userViewModel.getUserByUserId(userId: idUser) {
                goalsViewModel.getGoalsByUser(forPersonalInformation: user)
                
                self.activitySummaries = activitiesViewModel.getAllCompletedActivitiesSummary(forGoals: goalsViewModel.filteredGoalsByUser, filterBy: periodFilter).map { summary in
                            CompletedActivitySummaryView(id: UUID().uuidString, period: DateFormatter.localizedString(from: summary.date, dateStyle: .medium, timeStyle: .none), date: summary.date, count: Double(summary.count), animate: false)
                        }
                animateGraph(fromChange: true)
            }
        }
    
    @ViewBuilder
    func AnimatedChart() -> some View {
        let max = activitySummaries.max { item1, item2 in
            return item2.count > item1.count
        }?.count ?? 0
        
        
        let yAxisMax = max > 0 ? max : 10
        let dates = generateLast7Days()
        let calendar = Calendar.current
        
        Chart {
            if currentTab == "Week" {
                //MARK: Bner
                ForEach(dates, id: \.self) { date in
                    let count = activitySummaries.first(where: { calendar.isDate($0.date, inSameDayAs: date) })?.count ?? 0
                    if isLineGraph {
                        LineMark(
                            x: .value("Date", date, unit: .day),
                            y: .value("Activities", count)
                        )
                        .foregroundStyle(.blue.gradient)
                        .interpolationMethod(.catmullRom)
                       
                    }
                    else{
                        BarMark(
                            x: .value("Date", date, unit: .day),
                            y: .value("Activities", count)
                        )
                        .foregroundStyle(count > 0 ? .blue : .gray)
                    }
                    
                    if isLineGraph {
                        AreaMark(
                            x: .value("Date", date,  unit: .day),
                            y: .value("Activities", count)
                        )
                        .foregroundStyle(.blue.opacity(0.1).gradient)
                        .interpolationMethod(.catmullRom)
                    }
                    if let item = activitySummaries.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
                        if let currentActiveItem, currentActiveItem.id == item.id {
                            RuleMark(x: .value("Date", currentActiveItem.date ))
                            //Dotted Style
                                .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5 ))
                            
                            //MARK: Setting In Middle of Each Bars
                                .offset(x: (plotWidth / CGFloat(activitySummaries.count)) / 2)
                                .annotation(position: .top) {
                                    VStack{
                                        Text("Total activities \nthat have \nbeen completed")
                                            .multilineTextAlignment(.center)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            
                                        
                                        Text(currentActiveItem.count.stringFormat)
                                            .font(.title3.bold())
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background {
                                        RoundedRectangle(cornerRadius: 6, style: .continuous).fill(.white.shadow(.drop(radius: 2)))
                                    }
                                
                                }
                            
                        }
                        
                    }
                }
               
            }else if currentTab == "Month" {
                let last6Months = generateLast6MonthsStartDates()
                ForEach(last6Months, id: \.self) { monthDate in
                    let count = activitySummaries.first(where: { calendar.isDate($0.date, equalTo: monthDate, toGranularity: .month) })?.count ?? 0
                    
                    if isLineGraph {
                        LineMark(
                            x: .value("Date", monthDate, unit: .month),
                            y: .value("Activities", count)
                        )
                        .foregroundStyle(.blue.gradient)
                        .interpolationMethod(.catmullRom)
                       
                    }
                    else{
                        BarMark(
                            x: .value("Date", monthDate, unit: .month),
                            y: .value("Activities", count)
                        )
                        .foregroundStyle(count > 0 ? .blue : .gray)
                    }
                    
                    if isLineGraph {
                        AreaMark(
                            x: .value("Date", monthDate,  unit: .month),
                            y: .value("Activities", count)
                        )
                        .foregroundStyle(.blue.opacity(0.1).gradient)
                        .interpolationMethod(.catmullRom)
                    }
                    if let item = activitySummaries.first(where: { calendar.isDate($0.date, equalTo: monthDate, toGranularity: .month) }) {
                        if let currentActiveItem, currentActiveItem.id == item.id {
                            RuleMark(x: .value("Date", currentActiveItem.date ))
                            //Dotted Style
                                .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5 ))
                            
                            //MARK: Setting In Middle of Each Bars
                                .offset(x: (plotWidth / CGFloat(activitySummaries.count)) / 2)
                                .annotation(position: .top) {
                                    VStack{
                                        Text("Total activities \nthat have \nbeen completed")
                                            .multilineTextAlignment(.center)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            
                                        
                                        Text(currentActiveItem.count.stringFormat)
                                            .font(.title3.bold())
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background {
                                        RoundedRectangle(cornerRadius: 6, style: .continuous).fill(.white.shadow(.drop(radius: 2)))
                                    }
                                
                                }
                            
                        }
                        
                    }
                }
            }
        }
        .chartXAxis {
            if currentTab == "Week" {
                        AxisMarks(values: .stride(by: .day)) { _ in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel(format: .dateTime.day().month())
                        }
                    } else if currentTab == "Month" {
                        AxisMarks(values: .stride(by: .month)) { _ in
                                    AxisGridLine()
                                    AxisTick()
                                    AxisValueLabel(format: .dateTime.month().year())
                                }
                    }
           }
        //MARK: Customizing Y-Axis Length
        .chartYScale(domain: 0...(yAxisMax + 6))
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle()
                    .fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture().onChanged { value in
                            let x = value.location.x
                            if (currentTab == "Week"){
                                if let date: Date = proxy.value(atX: x), date <= Date() { // Batasi hanya sampai tanggal saat ini.
                                    if let matchingItem = findMatchingItem(forDate: date) {
                                        self.currentActiveItem = matchingItem
                                        self.plotWidth = geometry.size.width / CGFloat(activitySummaries.count)
                                    }
                                }
                            }
                            else if (currentTab == "Month") {
                                if let monthDate: Date = proxy.value(atX: x), monthDate <= Date() {
                                    let last6Months = generateLast6MonthsStartDates()
                                    self.plotWidth = (geometry.size.width / CGFloat(last6Months.count) / 1.2)
                                    let matchingMonthItem = activitySummaries.first { calendar.isDate($0.date, equalTo: monthDate, toGranularity: .month) } ??
                                                            CompletedActivitySummaryView(id: UUID().uuidString, period: "", date: monthDate, count: 0, animate: true)
                                    self.currentActiveItem = matchingMonthItem
                                  
                                }
                            }
                         
                        }
                        .onEnded { _ in
                            currentActiveItem = nil
                        }
                    )
            }
        }
        .frame(height: 250)
        .onAppear() {
            animateGraph()
        }
    }
    
    func animateGraph(fromChange: Bool = false) {
        for (index, _) in activitySummaries.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
                withAnimation(
//                        .easeInOut(duration: 0.8)
                    fromChange ? .easeInOut(duration: 0.8) :
                    .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)
//                        .delay(Double(index) * 1)
                ) {
                    activitySummaries[index].animate = true
                }
            }
       
            
        }
    }
    
    func generateLast7Days() -> [Date] {
        let calendar = Calendar.current
        var dates: [Date] = []
        for day in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -day, to: Date()) {
                dates.insert(date, at: 0)
            }
        }
        return dates
    }
    
    func generateLast6MonthsStartDates() -> [Date] {
        let calendar = Calendar.current
        var dates: [Date] = []
        if let sixMonthsAgo = calendar.date(byAdding: .month, value: -5, to: Date()) {
            let components = calendar.dateComponents([.year, .month], from: sixMonthsAgo)
            if let startOfPeriod = calendar.date(from: components) {
                for monthOffset in 0..<6 {
                    if let monthDate = calendar.date(byAdding: .month, value: monthOffset, to: startOfPeriod) {
                        dates.append(monthDate)
                    }
                }
            }
        }
        return dates
    }
    
    func findMatchingItem(forDate date: Date) -> CompletedActivitySummaryView? {
        let calendar = Calendar.current
        return activitySummaries.first(where: { summary in
            calendar.isDate(summary.date, inSameDayAs: date)
        })
    }
}

extension Double {
    var stringFormat: String {
        
        if self >= 10000 && self < 99999 {
            return String(format: "%.1fK", self / 10000).replacingOccurrences(of: ".0", with: "")
        }
        if self > 99999 {
            return String(format: "%.1fM", self / 10000).replacingOccurrences(of: ".0", with: "")
        }
        return String(format: "%.0f", self)
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView()
    }
}
