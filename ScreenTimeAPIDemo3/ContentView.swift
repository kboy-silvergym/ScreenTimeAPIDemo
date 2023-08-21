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
    @State var isPresented2 = false

    
    var body: some View {
        Button("Authorize")  {
            Task {
                await model.authorize()
            }
        }
        .padding()
        
        Button("Select Apps to Discourage") {
            isPresented = true
        }
        .familyActivityPicker(
            isPresented: $isPresented,
            selection: $model.selectionToDiscourage
        )
        .padding()
        
//        Button("Start Monitoring") {
//            model.initiateMonitoring()
//        }
//        .padding()
        
//        Button("Stop Monitoring") {
//            model.stopMonitoring()
//            isPresented2 = true
//        }
//        .padding()
//        .alert(isPresented: $isPresented2) {
//            Alert(title: Text("タイトル"))
//        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
