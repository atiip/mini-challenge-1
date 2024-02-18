//
//  ActivityViewModel.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 29/10/23.
//

import Foundation
import CoreData


class ActivityViewModel : ObservableObject {
    private var viewContext = PersistenceController.shared.viewContext
    
    // MARK: Fetch all goals data
    @Published var activities: [Activity] = []
    @Published var filteredActivityByGoal: [Activity] = []
    @Published var totalActivity: Int = 0
    @Published var filteredActivityByUser: [Activity] = []
    @Published var activityCompletedByGoal: [Activity] = []
    
    @Published var statusProgress: Double = 0
    @Published var totalCurrentActivity: Int = 0
    @Published var totalActivityIsDone: Int = 0
    
    init() {
        getActivities()
    }
    
    func countActivity() -> Int {
        return self.activities.count
    }
    
    func deleteActivity(activity: Activity) {
        viewContext.delete(activity)
        save()
    }
    
    func save() {
        do {
            try viewContext.save()
        }catch {
            print("Error saving")
            let nsError = error as NSError
            print(nsError)
        }
    }
    
    //Fetch all activites
    func getActivities() {
        let request = NSFetchRequest<Activity>(entityName: "Activity")
        do{
            self.activities = try viewContext.fetch(request)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func countAllActivitiesByUser(forGoals goals: [Goal]) {
        self.totalActivity = 0
        
        // Reset filtered activities
        self.filteredActivityByGoal = []
        
        for goal in goals {
            // Mengambil aktivitas yang terkait dengan goal saat ini
            self.getActivitiesByGoal(forGoal: goal)
            self.totalActivity += self.filteredActivityByGoal.count
        }
        
    }
    
    func getAllActivityByUser(forGoals goals: [Goal]) {
        self.filteredActivityByUser = []
        for goal in goals {
            // Mengambil aktivitas yang terkait dengan goal saat ini
            self.getActivitiesByGoal(forGoal: goal)
            for filteredActivity in self.filteredActivityByGoal {
                if filteredActivity.status == false {
                    self.filteredActivityByUser.append(filteredActivity)
                }
            }
            
        }
    }
    
    func getCountAllCompletedActivityByUserGoal(forGoals goals: [Goal]) -> Int{
        var tempArr: [Activity] = []
        for goal in goals {
            // Mengambil aktivitas yang terkait dengan goal saat ini
            self.getActivitiesByGoal(forGoal: goal)
            for filterdActivity in self.filteredActivityByGoal {
                if filterdActivity.status == true {
                    tempArr.append(filterdActivity)
                }
            }
            
            
        }
        return tempArr.count
    }
    func getAllCompletedActivityByUserGoal(forGoals goals: [Goal]) -> [Activity]{
        var tempArr: [Activity] = []
        for goal in goals {
            // Mengambil aktivitas yang terkait dengan goal saat ini
            self.getActivitiesByGoal(forGoal: goal)
            for filterdActivity in self.filteredActivityByGoal {
                if filterdActivity.status == true {
                    tempArr.append(filterdActivity)
                }
            }
            
            
        }
        return tempArr
    }
    
    func getCompletedActivityByUser(goal: Goal) -> Int{
        self.activityCompletedByGoal = []
        let activities = self.getActivitiesByGoalInReturn(goal: goal)
        var count = 0
        for act in activities {
            if act.status == true {
                self.activityCompletedByGoal.append(act)
                count += 1
            }
        }
        return self.activityCompletedByGoal.count
    }
    
    
    
    func getActivitiesByGoal(forGoal goal:Goal) {
        let request = NSFetchRequest<Activity>(entityName: "Activity")
        
        let filter = NSPredicate(format: "goals == %@", goal)
        request.predicate = filter
        
        do{
            self.filteredActivityByGoal = try viewContext.fetch(request)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func getActivitiesByGoalInReturn(goal:Goal) -> [Activity] {
        let request = NSFetchRequest<Activity>(entityName: "Activity")
        
        let filter = NSPredicate(format: "goals == %@", goal)
        request.predicate = filter
        
        do{
            return try viewContext.fetch(request)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    func createActivity(goal: Goal, activityName:String, desc:String , startDate:Date, endDate:Date, completeDate:Date, status:Bool) {
        let activity_ = Activity(context: viewContext)
        activity_.id = UUID()
        activity_.activityName = activityName
        activity_.desc = desc
        activity_.status = status
        activity_.startDate = startDate
        activity_.endDate = endDate
        activity_.completeDate = completeDate
        
        
        activity_.goals = goal
        save()
        self.getActivities()
        self.getActivitiesByGoal(forGoal: goal)
    }
    
    //get first data by goal
    func getSpesificActivity(activityId:UUID)-> Activity? {
        let request = Activity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", activityId as CVarArg)
        request.fetchLimit = 1
        
        do{
            let result = try viewContext.fetch(request)
            if let activity = result.first {
                return activity
            }
            
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return nil
    }
    
    func calculateActivityDone(totalActivity : Int, stepDone : Int, containerWidth: CGFloat) {
        self.statusProgress = min(containerWidth / CGFloat(totalActivity) * CGFloat(stepDone), containerWidth)
    }
    
    
    func getAllCompletedActivitiesSummary(forGoals goals: [Goal], filterBy periodFilter: String) -> [CompletedActivitySummary] {
        let calendar = Calendar.current
        var activitiesSummary: [CompletedActivitySummary] = []
        let activities : [Activity] = getAllCompletedActivityByUserGoal(forGoals: goals).filter { $0.status == true }

        switch periodFilter {
        case "Week":
            let endDate = Date()
            if let startDate = calendar.date(byAdding: .day, value: -6, to: endDate) {
                for date in Date.dates(from: startDate, to: endDate) {
                    let count = activities.filter { calendar.isDate($0.completeDate ?? Date(), inSameDayAs: date) }.count
                    if count > 0 {
                        activitiesSummary.append(CompletedActivitySummary(date: date, count: count))
                    }
                }
            }
            
           
        case "Month":
            //MARK: Example
//            let components = calendar.dateComponents([.year, .month], from: Date())
//            if let month = components.month, let year = components.year {
//                 let monthName = DateFormatter().monthSymbols[month - 1]
//                 let count = activities.filter {
//                     let activityComponents = calendar.dateComponents([.year, .month], from: $0.completeDate ?? Date())
//                     return activityComponents.year == year && activityComponents.month == month
//                 }.count
//                 activitiesSummary.append(CompletedActivitySummary(date: Date(), count: count))
//            }
            let currentDate = Date()
            for monthOffset in (0..<6).reversed() {
                if let monthDate = calendar.date(byAdding: .month, value: -monthOffset, to: currentDate) {
                    let components = calendar.dateComponents([.year, .month], from: monthDate)
                    let startOfMonth = calendar.date(from: components)!
                    let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
                    let activitiesInMonth = activities.filter { $0.completeDate ?? Date() >= startOfMonth && $0.completeDate ?? Date() < endOfMonth }
                    if !activitiesInMonth.isEmpty {
                        activitiesSummary.append(CompletedActivitySummary(date: startOfMonth, count: activitiesInMonth.count))
                    }
                }
            }
         
        default: break
        }

        return activitiesSummary
    }
    
}
struct CompletedActivitySummary {
    var date: Date // Tanggal aktivitas diselesaikan
    var count: Int // Jumlah aktivitas yang diselesaikan
}

enum Period {
    case week, month
}
extension Date {
    static func dates(from startDate: Date, to endDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = startDate

        let calendar = Calendar.current

        while date <= endDate {
            dates.append(date)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: date) else { break }
            date = nextDate
        }

        return dates
    }
}
