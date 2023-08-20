//
//  CreateJournalView.swift
//  SeedDary
//
//  Created by Muhammad Athif on 04/05/23.
//

import SwiftUI
import CoreData

struct CreateJournalView: View {
    @State var content_ = ""
    @State var title_ = ""
    @State var date_ = Date()
    @State var journal_ = ""
    @State private var isSheetActivityActive = false
    @State private var showingAlert = false
    @Binding var isJournalViewPresented:Bool
    @Binding var isSubmitJournal:Bool
    @StateObject var journalsViewModel: JournalsViewModel = JournalsViewModel()
    
    var body: some View {
        NavigationView{
//            Spacer().frame(height: 40)
            VStack(alignment: .center){
                Spacer()
                
                ZStack(alignment: .center){
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 248/255, green: 241/255, blue: 216/255))
                        .shadow(color: .gray, radius: 10, x: 0, y: 5)
                    ScrollView{
                        Spacer()
                        VStack(alignment: .leading){
                            TextField("Journal's Title", text: $title_, axis: .vertical)
                                .frame(width: 300, height: 50, alignment: .leading)
                                .fontWeight(.bold)
                                .frame(minWidth: 0, maxWidth: 340, minHeight: 0, maxHeight: .infinity)
                        }
                    }
                    
                    TextField(
                        "Let me hear your story today",
                        text: $content_, axis: .vertical)
                    .lineLimit(23, reservesSpace: true)
                    .multilineTextAlignment(.leading)
                    .frame(width: 300)
                    .fixedSize(horizontal: true, vertical: false)
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width-50, height: UIScreen.main.bounds.height-240, alignment: .center)
                HStack(){
                    Button(){
                        if (title_.isEmpty || content_.isEmpty) {
                            showingAlert = true
                        }else{
                            let calender = Calendar.current
                            let startOfDay = calender.startOfDay(for: Date.now)
                            journalsViewModel.createJournal(date: startOfDay, title: title_, content: content_)
                            isSheetActivityActive = true
                            isJournalViewPresented = false
                            isSubmitJournal = true
                        }
                    } label: {
                        Capsule()
                            .fill(Color(red: 63/255, green: 120/255, blue: 82/255))
                            .shadow(color: .gray, radius: 10, x: 0, y: 5)
                        //                            .opacity()
                            .frame(width: 350 ,height: 50)
                            .overlay(
                                Text("Submit Journal")
                                    .foregroundColor(.white))
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Notification"), message: Text("Title and Journal Content cannot be empty!"), dismissButton: .default(Text("OK")))
                    }
                    
                    
                }.frame(width: UIScreen.main.bounds.width)
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                
            }.padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
            
        }
//        .navigationBarBackButtonHidden(true)
//
//        .navigationBarItems(trailing:
//              NavigationLink(destination: ContentView(), isActive: $isSheetActivityActive) {
//          })
            
//        .sheet(isPresented: $isSheetActivityActive) {
//                ActivitiesView()
//                .presentationDetents([.height(700)])
//                .presentationDragIndicator(.visible)
//                 .navigationBarTitle("Create Journal")
//            }
        
    }
}

//struct CreateJournalView_Previews: PreviewProvider {
//    static var previews: some View {
//        let viewContext = PersistenceController.preview.container.viewContext
//        let journalViewModel = JournalsViewModel(viewContext: viewContext)
//        CreateJournalView(ViewModel: journalViewModel, viewContext_: viewContext, content_: "", title_: "", date_: Date())
//    }
//}


