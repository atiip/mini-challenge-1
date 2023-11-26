//
//  GamificationViewModel.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 30/07/23.
//

import Foundation
import CoreData


class GoalsViewModel : ObservableObject {
    private var viewContext = PersistenceController.shared.viewContext
    
    // MARK: Fetch all goals data
    @Published var goals: [Goal] = []
    
    // MARK: all data with status complete
    @Published var completedGoalsBySpesificUser : [Goal] = []
    
    // MARK: all goals by user
    @Published var filteredGoalsByUser : [Goal] = []
    
    // MARK: all activty by goal with status completed
    @Published var filteredActivityCompleteByGoal : [Goal] = []
    
    @Published var selectedGoal: Goal = Goal()
    
//    // MARK: all goals name
//    // Check dibutuhkan atau engga
//    @Published var goalsName : [String] = []
//
//    // MARK: all activity by startDate and endDate
//    @Published var filteredActivityByStartAndEndDate : [Goal] = []
//
//    // MARK: all activity by start and endDate with status true
//    @Published var filteredActivityWithStatusTrueByStartAndEndDate : [Goal] = []
//
//    // MARK: all distinct data Goal
//    @Published var distinctGoalsArray : [Goal] = []
//
//    // MARK: all distinct data Goal with status true
//    @Published var distinctGoalsArrayWithStatusTrue : [Goal] = []

    

    init() {
        getGoals()
//        getGoalNames()
    }
    
    func countGoals() -> Int {
        return self.goals.count
    }
    
    func deleteGoal(goal: Goal) {
        viewContext.delete(goal)
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
    
    //Fetch all goals data
    func getGoals() {
        let request = NSFetchRequest<Goal>(entityName: "Goal")
        do{
            self.goals = try viewContext.fetch(request)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func createGoal(user: Personal_Information, goalName:String, startDate:Date, endDate:Date, status:Bool) {
        let goal_ = Goal(context: viewContext)
        goal_.id = UUID()
        goal_.goal = goalName
        goal_.status = status
        goal_.endDate = endDate
        goal_.startDate = startDate
        
        goal_.users = user
        save()
        self.getGoals()
        self.getGoalsByUser(forPersonalInformation: user)
    }
    
    // Untuk icon siram bunga tanpa diliat yang mana yang uda selesai
    // Untuk siram bunga cuma diliat progressnya uda sampe mana aja
    func getGoalsByUser(forPersonalInformation user:Personal_Information) {
        
        //TODO: Cek apakah jangka waktunya tidak melebih batas, kalau melebihi batas akan didelete
        let request = NSFetchRequest<Goal>(entityName: "Goal")
        
        let filter = NSPredicate(format: "users == %@", user)
        request.predicate = filter
        
        do{
            self.filteredGoalsByUser = try viewContext.fetch(request)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
   }
   
    //get first data by goal
    func getGoal(goalId:UUID, user:Personal_Information)-> Goal? {
        print("masuk get goal by id")
        let request = NSFetchRequest<Goal>(entityName: "Goal")
        request.predicate = NSPredicate(format: "users == %@ AND id == %@", user, goalId as CVarArg)
//        request.fetchLimit = 1
        
        do{
            print("masuk do get goal by id")
            let result = try viewContext.fetch(request)
            print("masuk result get goal by id")
            if let goal = result.last {
                return goal
            }
            
        } catch {
            print("masuk catch get goal by id")
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return nil
    }
    
//    //get first data by goal
//    func getSpesificGoal(goalId:UUID) {
//        let request = Goal.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", goalId as CVarArg)
//        request.fetchLimit = 1
//        
//        do{
//            let result = try viewContext.fetch(request)
//            if let goal = result.first {
//                self.selectedGoal = goal
//            }
//            
//        } catch {
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//    }
    
    //get all completed goals with spesific user
    func getCompletedGoalsBySpesificUser(forPersonalInformation user:Personal_Information) {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        request.predicate = NSPredicate(format: "users == %@ AND status == %@", user, NSNumber(value: true))
        
        do {
            self.completedGoalsBySpesificUser = try viewContext.fetch(request)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
//    //get all activity by goal with status complete
//    func getActivityCompleteByGoal(goal:String) {
//        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
//        request.predicate = NSPredicate(format: "goal == %@ AND status == %@", goal, NSNumber(value: true))
//        do {
//            self.filteredActivityCompleteByGoal = try viewContext.fetch(request)
//        } catch {
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//    }
    
//    //get all goal names
//    func getGoalNames() {
//        let request: NSFetchRequest<NSDictionary> = NSFetchRequest(entityName: "Goal")
//        let goalExpression = NSExpression(forKeyPath: "goal")
//        let distinctDescription = NSExpressionDescription()
//        distinctDescription.name = "distinctGoal"
//        distinctDescription.expression = goalExpression
//        distinctDescription.expressionResultType = .stringAttributeType
//
//        request.propertiesToFetch = [distinctDescription]
//        request.resultType = .dictionaryResultType
//
//        do {
//            let results = try viewContext.fetch(request)
//
//            for result in results {
//                if let distinctGoal = result["distinctGoal"] as? String {
//                    self.goalsName.append(distinctGoal)
//                }
//            }
//        } catch {
//            let nsError = error as NSError
//            print("Error: \(nsError), \(nsError.userInfo)")
//        }
//    }
//
//    //get activity by startDate and endDate
//    func getActivityByStartAndEndDate(startDate: Date, endDate: Date) {
//        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
//        request.predicate = NSPredicate(format: "startDate >= %@ AND endDate <= %@", startDate as NSDate, endDate as NSDate)
//        do {
//            self.filteredActivityByStartAndEndDate = try viewContext.fetch(request)
//        } catch {
//            let nsError = error as NSError
//            print("Error: \(nsError), \(nsError.userInfo)")
//        }
//    }
//
//    //get activity with status true by startDate and endDate
//    func getActivityTrueByStartAndEndDate(startDate: Date, endDate: Date) {
//        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
//        request.predicate = NSPredicate(format: "(startDate >= %@ AND endDate <= %@) AND status = %@", startDate as NSDate, endDate as NSDate, NSNumber(value: true))
//        do {
//            self.filteredActivityWithStatusTrueByStartAndEndDate = try viewContext.fetch(request)
//        } catch {
//            let nsError = error as NSError
//            print("Error: \(nsError), \(nsError.userInfo)")
//
//        }
//    }
//
//    //get distinct data Goal
//    func getDistinctGoal() {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
//        fetchRequest.resultType = .dictionaryResultType
//        fetchRequest.propertiesToFetch = ["goal"]
//        fetchRequest.returnsDistinctResults = true
//
//        do {
//            let results = try viewContext.fetch(fetchRequest) as! [[String:Any]]
//            self.distinctGoalsArray = results.compactMap { result -> Goal? in
//                let goalName = result["goal"] as! String
//                let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
//                fetchRequest.predicate = NSPredicate(format: "goal == %@", goalName)
//                do {
//                    let goals = try viewContext.fetch(fetchRequest)
//                    return goals.first
//                } catch {
//                    print("Error fetching goals for \(goalName): \(error.localizedDescription)")
//                    return nil
//                }
//            }
//
//        } catch {
//            print("Error fetching distinct goals: \(error.localizedDescription)")
//        }
//    }
//
//    //get distinct data Goal with status true
//    func getDistinctGoalWithStatusAllActivityTrue() {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
//        fetchRequest.resultType = .dictionaryResultType
//        fetchRequest.propertiesToFetch = ["goal"]
//        fetchRequest.returnsDistinctResults = true
//
//        do {
//            let results = try viewContext.fetch(fetchRequest) as! [[String:Any]]
//            self.distinctGoalsArrayWithStatusTrue = results.compactMap { result -> Goal? in
//                let goalName = result["goal"] as! String
//                let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
//                fetchRequest.predicate = NSPredicate(format: "goal == %@ AND activity == %@", goalName, NSNumber(value: true))
//                do {
//                    let goals = try viewContext.fetch(fetchRequest)
//                    return goals.first
//                } catch {
//                    print("Error fetching goals for \(goalName): \(error.localizedDescription)")
//                    return nil
//                }
//            }
//
//        } catch {
//            print("Error fetching distinct goals: \(error.localizedDescription)")
//        }
//    }
//
//
}
