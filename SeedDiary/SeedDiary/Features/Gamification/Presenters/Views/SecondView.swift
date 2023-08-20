//
//  SecondView.swift
//  SeedDiary
//
//  Created by Muhammad Athif on 30/07/23.
//

import SwiftUI

struct SecondView: View {
    @EnvironmentObject var router: Router
    var body: some View {
        VStack{
            Text("Second View")
            Button(action: {
                router.path.append(2)
            }) {
                Text("Go to page 3")
            }
        }
        
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView()
    }
}
