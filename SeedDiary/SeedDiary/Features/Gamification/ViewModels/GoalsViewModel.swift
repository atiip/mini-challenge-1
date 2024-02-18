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
    
    @Published var goalID: UUID = UUID()
    
    
    
    
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
        goalID = goal_.id ?? UUID()
        self.getGoals()
        self.getGoalsByUser(forPersonalInformation: user)
    }
    
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
        let request = NSFetchRequest<Goal>(entityName: "Goal")
        request.predicate = NSPredicate(format: "users == %@ AND id == %@", user, goalId as CVarArg)
//        request.fetchLimit = 1
        
        do{
            let result = try viewContext.fetch(request)
            if let goal = result.last {
                return goal
            }
            
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return nil
    }
    
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
    
    //get all activity by goal with status complete
    func getActivityCompleteByGoal(goal:String) {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        request.predicate = NSPredicate(format: "goal == %@ AND status == %@", goal, NSNumber(value: true))
        do {
            self.filteredActivityCompleteByGoal = try viewContext.fetch(request)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}
