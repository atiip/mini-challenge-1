//
//  MoodViewModel.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 30/07/23.
//

import Foundation
import CoreData

public class MoodsViewModel: ObservableObject {
    private var viewContext = PersistenceController.shared.viewContext
    
    @Published var moods: [Mood] = []
    
    @Published var filteredMoodsByUsers: [Mood] = []
    
    @Published var filteredMoodsByDate: [Mood] = []
    
    @Published var filteredMoodMonthly: [Mood] = []
    
    init() {
        getMoods()
    }
    
    public func GetMoods() -> [Mood] {
        return self.moods
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

    //get all data
    func getMoods() {
        let request = NSFetchRequest<Mood>(entityName: "Mood")
        do{
            self.moods = try viewContext.fetch(request)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func getMoodsByUsers(forUser user:Personal_Information) {
        let request = NSFetchRequest<Mood>(entityName: "Mood")
        
        let filter = NSPredicate(format: "users == %@", user)
        request.predicate = filter
        
        do{
            self.filteredMoodsByUsers = try viewContext.fetch(request)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
   }
    
    func createMood(user:Personal_Information, mood:String, date:Date) {
        let mood_ = Mood(context: viewContext)
        mood_.mood = mood
        mood_.moodDate = date
        
        mood_.users = user
        save()
        self.getMoods()
        self.getMoodsByUsers(forUser: user)
    }
    
    //get data by date
    func getMoodsByDate(date: Date) {
        let request: NSFetchRequest<Mood> = Mood.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", date as NSDate)
        do {
            self.filteredMoodsByDate = try viewContext.fetch(request)
        } catch {
            let nsError = error as NSError
            print("Error: \(nsError), \(nsError.userInfo)")
        }
    }
    
    //get data mood by date (monthly)
    func getMoodsMonthly(date: Date) {
        let calendar = Calendar.current
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: date))
        let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate!)
        
        let request: NSFetchRequest<Mood> = Mood.fetchRequest()
        request.predicate = NSPredicate(format: "(date >= %@ AND date <= %@)", startDate! as NSDate, endDate! as NSDate)
        
        do {
            self.filteredMoodMonthly = try viewContext.fetch(request)
        } catch {
            let nsError = error as NSError
            print("Error: \(nsError), \(nsError.userInfo)")
          
        }
    }
    
}

