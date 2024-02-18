//
//  OpeningComponent.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 30/07/23.
//

import SwiftUI
//import Inject
@_exported import Inject

struct OpeningComponent: View {
    let page: OpeningModel
    @State var finalText: String = ""
    @State var isShowingSheet = false

    @EnvironmentObject var userViewModel: PersonalInformationViewModel
    @EnvironmentObject var goalViewModel: GoalsViewModel
    @State var isAddGoalsViewPresented: Bool = false
    @State var isFirstGoals: Bool = false
    @State var isUpdateGoal: Bool = false
    
    @Binding var name: String
    @Binding var pageIndex: Int
    @Binding var isTextFieldFilled: Bool
    @Binding var addFirstGoalsComplete: Bool
    
    @AppStorage("userID") var userID: String = ""
    @ObservedObject private var iO = Inject.observer
    
    
    var body: some View {
        ZStack {
            Image(page.backimageUrl)
                .resizable()
                .opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ZStack (alignment: .topLeading){
                    Image("opening-shape")
                        .resizable()
                    
                    VStack {
                        Text(finalText).padding()
                            .onAppear {
                                self.typeWriter()
                                
                            }
                        if pageIndex == 1 {
                            TextField("Enter name", text: $name).padding()
                                .onChange(of: name) { newName in
                                    if !newName.isEmpty{
                                        isTextFieldFilled = true
                                    }
                                    else{
                                        isTextFieldFilled = false
                                    }
                                }
                        }
                    }
                    
                }
                .frame(width: 200, height: 160)
                .padding()
                .cornerRadius(8)
                
                Image(page.frontimageUrl)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 140)
                Spacer().frame(height: 200)
                if pageIndex == OpeningModel.samplePages.count-1 && isTextFieldFilled == true {
                    ZStack{
                        Button(action: {
                        }) {
                            NavigationLink(destination: AddGoalsView(isAddGoalsViewPresented: $isAddGoalsViewPresented, isFirstGoals: $isFirstGoals, addFirstGoalsComplete: $addFirstGoalsComplete, isUpdateGoal: $isUpdateGoal)
                            
                            ) {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(red: 63/255, green: 120/255, blue: 82/255))
                                        .frame(width: 350, height: 50)
                                    Text("START YOUR JOURNEY HERE")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            userViewModel.createUser(username: name)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                let user = userViewModel.getLatestUser()
                                let stringId = user?.id?.uuidString
                                
                                UserDefaults.standard.set(stringId, forKey: "userID")
                            }
                            
                            
                            isFirstGoals = true
                        })
                    }
                    
                }
                else if pageIndex == OpeningModel.samplePages.count-1 && isTextFieldFilled == false {
                    ZStack{
                        Button{
                            
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.gray)
                                    .frame(width: 350, height: 50)
                                Text("START YOUR JOURNEY HERE")
                                    .foregroundColor(.white)
                            }
                            
                        }
                        .disabled(true)
                        
                    }
                    Spacer().frame(height: 20)
                    Text("Please fill the name first").foregroundColor(.secondary)
                        .bold()
                }
            }
        }.enableInjection()
        
            .sheet(isPresented: $isAddGoalsViewPresented) {
                AddGoalsView(isAddGoalsViewPresented: $isAddGoalsViewPresented, isFirstGoals: $isFirstGoals, addFirstGoalsComplete: $addFirstGoalsComplete, isUpdateGoal: $isUpdateGoal)
                    .environmentObject(userViewModel)
                    .presentationDetents([.height(700)])
                    .presentationDragIndicator(.visible)
                    .onDisappear{
                
                        if addFirstGoalsComplete {
                            NavigationLink(destination: ContentView().environmentObject(userViewModel), isActive: $addFirstGoalsComplete) {
                                EmptyView()
                            }
                        }
                    }
            }
        
    }
    
    func typeWriter(at position: String.Index? = nil) {
        if let index = position {
            if index == page.description.startIndex {
                finalText = ""
            }
            if index < page.description.endIndex {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    let nextIndex = page.description.index(after: index)
                    finalText.append(page.description[index])
                    typeWriter(at: nextIndex)
                }
            }
        } else {
            // If no index provided, start from the beginning
            typeWriter(at: page.description.startIndex)
        }
    }
}
struct OpeningComponent_Previews: PreviewProvider {
    static var previews: some View {
        
        OpeningComponent(page: OpeningModel.samplePages[1], name: .constant("bro"), pageIndex: .constant(1), isTextFieldFilled: .constant(false), addFirstGoalsComplete: .constant(false))
        //        OpeningComponent(page: OpeningModel.samplePage)
    }
}

