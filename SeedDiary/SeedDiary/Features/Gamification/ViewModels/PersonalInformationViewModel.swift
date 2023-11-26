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
    
    @Published var username: String = ""
    @Published var userId: UUID? = nil
    
    init() {
      getUsers()
    }
    
    public func GetName() -> String {
        return self.username
    }
//    func deleteUser() {
//        guard let stores = viewContext.persistentStoreCoordinator?.persistentStores else {
//            return
//        }
//
//        for store in stores {
//            do {
//                try viewContext.persistentStoreCoordinator?.destroyPersistentStore(
//                    at: store.url!,
//                    ofType: store.type,
//                    options: nil
//                )
//            } catch {
//                print("Error deleting store: \(error)")
//            }
//        }
//    }
//
    func save() {
        do {
            try viewContext.save()
            print("save success")
//            print(users.count)
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
        print("masuk get lastestUser")
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
