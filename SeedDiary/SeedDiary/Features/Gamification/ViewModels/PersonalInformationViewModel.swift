//
//  PersonalInformationViewModel.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 30/07/23.
//

import Foundation
import CoreData

class PersonalInformationViewModel : ObservableObject {
    private var viewContext = PersistenceController.shared.viewContext
    // MARK: Fetch all goals data
    @Published var users: [Personal_Information] = []
    
    @Published var user: Personal_Information?
    
    @Published var username: String = ""
    @Published var userId: UUID?
    @Published var isFirstActivity: Bool = false
    @Published var isFirstActivityCompleted: Bool = false
    @Published var isFirstGoalCompleted: Bool = false
    
    init() {
      getUsers()
    }
    
    public func GetName() -> String {
        return self.username
    }

    func save() {
        do {
            try viewContext.save()
            print("save success")
        }catch {
            print("Error saving")
            let nsError = error as NSError
            print(nsError)
        }
    }
    
    //Fetch all users
    func getUsers() {
        let request = NSFetchRequest<Personal_Information>(entityName: "Personal_Information")
        
        do{
            self.users = try viewContext.fetch(request)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func getLatestUser() -> Personal_Information? {
        let request = NSFetchRequest<Personal_Information>(entityName: "Personal_Information")
//        request.fetchLimit = 1  // Batasi hasil hanya ke satu objek (data terakhir)

        do {
            let result = try viewContext.fetch(request)
            if let user = result.last {
                return user
            }
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return nil
    }
    
    func createUser(username:String) {
        let personalInformation = Personal_Information(context: viewContext)
        let idUser = UUID()
        personalInformation.id = idUser
        personalInformation.name = username
        save()
        self.userId = idUser
        self.user = personalInformation
        self.getUsers()
    }
    
    //get first data by goal
    func getUserByUserId(userId:UUID)-> Personal_Information? {
        let request = Personal_Information.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", userId as CVarArg)
        
        do{
            let result = try viewContext.fetch(request)
            if let user = result.last {
                return user
            }
            
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return nil
    }
}
