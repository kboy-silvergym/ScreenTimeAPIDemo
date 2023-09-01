//
//  ContentView.swift
//  ScreenTimeAPIDemo3
//
//  Created by Kei Fujikawa on 2023/08/11.
//

import SwiftUI
import FamilyControls

struct ContentView: View {
    @StateObject var model = FamilyControlModel.shared
    @State var isPresented = false
    
    var body: some View {
        Button("Select Apps to Discourage") {
            Task {
                try await model.authorize()
                isPresented = true
            }
        }
        .familyActivityPicker(
            isPresented: $isPresented,
            selection: $model.selectionToDiscourage
        )
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
