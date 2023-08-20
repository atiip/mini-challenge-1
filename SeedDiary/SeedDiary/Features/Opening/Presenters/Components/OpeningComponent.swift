//
//  OpeningComponent.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 30/07/23.
//

import SwiftUI

struct OpeningComponent: View {
    let page: OpeningModel
    @State var finalText: String = ""
    //    @State var name = ""
    //    @State var pageIndex = 0
    @Binding var name: String
    @Binding var pageIndex: Int
    @State var isShowingSheet = false
    @Binding var isTextFieldFilled: Bool
    
    @StateObject var personalInformationViewModel = PersonalInformationViewModel()
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
                                        print("masuk")
                                        isTextFieldFilled = true
                                        print(isTextFieldFilled)
                                    }
                                    else{
                                        isTextFieldFilled = false
                                    }
//
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
                            NavigationLink(destination:ContentView()) {
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
                              personalInformationViewModel.createName(name: name)
                              print("goal")
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
        
        OpeningComponent(page: OpeningModel.samplePages[1], name: .constant("bro"), pageIndex: .constant(1), isTextFieldFilled: .constant(false))
        //        OpeningComponent(page: OpeningModel.samplePage)
    }
}
