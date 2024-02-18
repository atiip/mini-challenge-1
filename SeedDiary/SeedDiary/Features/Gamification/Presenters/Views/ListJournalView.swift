//
//  ListJournalView.swift
//  SeedDiary
//
//  Created by Muhamad Ichsan Al - Qudhori on 06/05/23.
//

import SwiftUI

public struct ListJournalView: View {
    @StateObject var journalsViewModel: JournalsViewModel = JournalsViewModel()
    @State private var isSheetCreateJournalActive = false
    @EnvironmentObject var userViewModel: PersonalInformationViewModel
    
    public func convertDate(date: Date) -> Date {
        let calender = Calendar.current
        let startOfDay = calender.startOfDay(for: date)
        return startOfDay
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        return formatter
    }()
    
    @Binding var isJournalViewPresented:Bool
    @Binding var isSubmitJournal:Bool
    
    @EnvironmentObject var router: Router
    public var body: some View {
        NavigationView{
            VStack(alignment: .center){
                Spacer()
                ZStack(alignment: .leading){
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 248/255, green: 241/255, blue: 216/255))
                        .shadow(color: .gray, radius: 10, x: 0, y: 5)
                    VStack(alignment: .leading){
                        HStack{
                            Text("List Journal's")
                                .font(.system(size: 17))
                                .fontWeight(.bold)
                        }.padding()
                        Spacer()
                        ScrollView{
                            // TODO: Fetch data here using for each
                            
                            ForEach(journalsViewModel.filteredJournalsByUsers, id:\.self) {item in
                                Group{
                                    HStack{
                                        Text("\(item.title ?? " ")")
                                            .font(.system(size: 14))
                                            .fontWeight(.regular)
                                        
                                        Spacer()
                                        
                                        if let date = item.journalDate {
                                            let formattedDate = self.dateFormatter.string(from: date)
                                            Text("\(formattedDate) ")
                                                .font(.system(size: 14))
                                                .fontWeight(.regular)
                                        } else {
                                            Text("-")
                                                .font(.system(size: 14))
                                                .fontWeight(.regular)
                                        }
                                    }.padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                                }
                            }
                        }
                        
                    }
                }
                .frame(width: UIScreen.main.bounds.width-50, height: UIScreen.main.bounds.height-240, alignment: .center)
                HStack(){
                    
                    Button(action: {
                        isSheetCreateJournalActive = true
                    }, label: {
                        NavigationLink(destination: CreateJournalView(isJournalViewPresented: $isJournalViewPresented, isSubmitJournal: $isSubmitJournal).environmentObject(userViewModel)) {
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(red: 63/255, green: 120/255, blue: 82/255))
                                    .frame(width: 350, height: 50)
                                Text("Add Journal")
                                    .foregroundColor(.white)
                            }
                            
                        }
                    })
                }.frame(width: UIScreen.main.bounds.width)
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
                
            }
            .onAppear{
                let idUser = UUID(uuidString: UserDefaults.standard.string(forKey: "userID") ?? "")
                guard let user = userViewModel.getUserByUserId(userId: idUser ?? UUID()) else {
                    return
                }
                
                journalsViewModel.getJournalsByUsers(forUser: user)
            }
        }
    }
}

struct ListJournalView_Previews: PreviewProvider {
    static var previews: some View {
        ListJournalView(isJournalViewPresented: .constant(false), isSubmitJournal: .constant(false))
    }
}



