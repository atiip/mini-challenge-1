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
    
    @Published var username: String = ""
    
    init() {
       getName()
    }
    
    public func GetName() -> String {
        return self.username
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
    
    func createName(name:String) {
        let personalInformation = Personal_Information(context: viewContext)
      
        personalInformation.name = name
        save()
        self.getName()
    }
    
    func getName() {
        let request = NSFetchRequest<Personal_Information>(entityName: "Personal_Information")
        do {
            let result = try viewContext.fetch(request)
            guard let personalInfo = result.last else {
                return
            }
            self.username = personalInfo.name ?? "default"
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}
