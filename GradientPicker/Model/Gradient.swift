//
//  Gradient.swift
//  GradientPicker
//
//  Created by Maxim Macari on 28/10/2020.
//

import SwiftUI

struct Gradient: Decodable {
    var name : String
    var colors: [String]
}

struct CShape: Shape{
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topRight, .bottomLeft], cornerRadii: CGSize(width: 55, height: 55))
        
        return Path(path.cgPath)
    }
}
