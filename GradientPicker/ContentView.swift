//
//  ContentView.swift
//  GradientPicker
//
//  Created by Maxim Macari on 28/10/2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .preferredColorScheme(.dark)
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
