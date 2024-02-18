//
//  JournalViewModel.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 30/07/23.
//

import Foundation
import CoreData

class JournalsViewModel: ObservableObject {
    private var viewContext = PersistenceController.shared.viewContext
    
    @Published var journals: [Journal] = []
    
    @Published var filteredJournalsByUsers: [Journal] = []
    
    @Published var filteredJournalsByDate : [Journal] = []

    init () {
        getJournals()
    }
    
    public func GetJournals() -> [Journal] {
        return self.journals
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
    
    //get all
    func getJournals() {
        let request = NSFetchRequest<Journal>(entityName: "Journal")
        do{
            self.journals = try viewContext.fetch(request)
           
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func getJournalsByUsers(forUser user:Personal_Information) {
        let request = NSFetchRequest<Journal>(entityName: "Journal")
        
        let filter = NSPredicate(format: "users == %@", user)
        request.predicate = filter
        
        do{
            self.filteredJournalsByUsers = try viewContext.fetch(request)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
   }
    
    
    
    func createJournal(user: Personal_Information,date:Date, title:String, content: String) {
        //        date.formatted(Date.FormatStyle().weekday(.abbreviated))
        let newJournal = Journal(context: viewContext)
        newJournal.title = title
        newJournal.journalDate = date
        newJournal.content = content
        
        newJournal.users = user
        save()
        self.getJournals()
        self.getJournalsByUsers(forUser: user)
    }
    
    
    
    //get one data by goal
    func getJournal(title:String)-> Journal? {
        let request = Journal.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        request.fetchLimit = 1
        
        do{
            let result = try viewContext.fetch(request)
            if let journal = result.first {
                return journal
            }
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return nil
    }
    
    
    
    //get data by Date
    func getJournalsByDate(date: Date) {
        let request: NSFetchRequest<Journal> = Journal.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", date as NSDate)
        
        do {
            self.filteredJournalsByDate = try viewContext.fetch(request)
        } catch {
            let nsError = error as NSError
            print("Error: \(nsError), \(nsError.userInfo)")
        }
    }
    
    
    func updateJournal(journal: Journal, newTitle: String?, newContent: String?, newDate: Date?) {
        if let existingJournal = getJournal(title: journal.title ?? "") {
            if let newTitle = newTitle {
                existingJournal.title = newTitle
            }
            if let newContent = newContent {
                existingJournal.content = newContent
            }
            if let newDate = newDate {
                existingJournal.journalDate = newDate
            }
            
            save()
            self.getJournals()
        } else {
            print("Data not found")
        }
    }
    
    func deleteJournal(journal: Journal) {
        viewContext.delete(journal)
        save()
    }
}
