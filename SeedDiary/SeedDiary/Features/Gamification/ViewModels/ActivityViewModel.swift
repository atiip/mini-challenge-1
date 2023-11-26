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

//    var goal: Goal // (NSManagedObject)

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
    
    //Fetch all goals data
//    func getActivities() {
//        if let activitiesSet = goal.activities as? Set<Activity> {
//            let activitiesArray = Array(activitiesSet)
//            self.activities = activitiesArray
//        }
//    }
    
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
    
    func createActivity(goal: Goal, activityName:String, desc:String , startDate:Date, endDate:Date, status:Bool) {
        // TODO: Add logic untuk ngecek dlu total activity udah berapa, kalau uda 8 gabakal di create
//        if countActivity() <= 8{
//
//        }
        let activity_ = Activity(context: viewContext)
        activity_.id = UUID()
        activity_.activityName = activityName
        activity_.desc = desc
        activity_.status = status
        activity_.startDate = startDate
        activity_.endDate = endDate
       
        
        activity_.goals = goal
        save()
        self.getActivities()
        self.getActivitiesByGoal(forGoal: goal)
        print("success")
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
}
