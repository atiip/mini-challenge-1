//
//  OpeningView.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 30/07/23.
//

import SwiftUI

struct OpeningView: View {
    @State private var pageIndex = 0
    private var pages: [OpeningModel] = OpeningModel.samplePages
    private let dotAppearance = UIPageControl.appearance()
    @State var name: String = ""
    @State private var isTextFieldFilled = false
    
    var body: some View {
        ZStack{
            TabView(selection: $pageIndex) {
                ForEach(pages) { page in
                    
                    VStack {
                        Spacer()
                        OpeningComponent(page: page, name: $name, pageIndex: $pageIndex, isTextFieldFilled: $isTextFieldFilled)
                    }
                    .tag(page.tag)
                    .ignoresSafeArea()
                    
                }
            }
            .ignoresSafeArea()
            
            .tabViewStyle(.page)
            .animation(.easeInOut, value: pageIndex)
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode:.interactive))
            .onAppear{
                dotAppearance.currentPageIndicatorTintColor = .green
                dotAppearance.pageIndicatorTintColor = .gray
            }
            
        }
        
    }
}

struct OpeningView_Previews: PreviewProvider {
    static var previews: some View {
        OpeningView()
    }
}
