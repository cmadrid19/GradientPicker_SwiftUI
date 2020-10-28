//
//  ColorCard.swift
//  GradientPicker
//
//  Created by Maxim Macari on 28/10/2020.
//

import SwiftUI

struct ColorCard: View {
    
    var  gradient: Gradient
    var columns: [GridItem]
    
    var body: some View {
        //Model color card
        VStack(spacing: 15){
            
            ZStack{
                LinearGradient(gradient: .init(colors: hexToColor(colors: gradient.colors)), startPoint: .top, endPoint: .bottom)
                    .frame(height: 180)
                    .clipShape(CShape())
                    .cornerRadius(16)
                    //Context Menu
                    .contentShape(CShape())
                    .contextMenu {
                        Button(action: {
                            //copy to board
                            var colorCode = ""
                            for color in gradient.colors {
                                colorCode += color + "\n"
                            }
                            
                            UIPasteboard.general.string = colorCode
                            
                        }, label: {
                            Text("Copy")
                        })
                    }
                Text("\(gradient.name)")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    //On Colors too light, dislpay name in black
                    .foregroundColor(isLight(colors: gradient.colors) ? .black : .white)
                    .padding(.horizontal)
                
                
            }
            if columns.count == 1 {
                HStack(spacing: 15){
                    ForEach(gradient.colors, id: \.self){ color in
                        Text("\(color)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                    }
                }
            }
            
        }
    }
    
    //Converting data retrieved (hex to UIColor)
    private func hexToColor(colors: [String]) -> [Color] {
        
        var colorArray: [Color] = []
        
        for color in colors {
            //removing #
            var trimmed = color.trimmingCharacters(in: .whitespaces).uppercased()
            
            trimmed.remove(at: trimmed.startIndex)
            
            var hexValue: UInt64 = 0
            Scanner(string: trimmed).scanHexInt64(&hexValue)
            
            let r = CGFloat((hexValue & 0x00FF0000) >> 16) / 225
            let g = CGFloat((hexValue & 0x0000FF00) >> 8) / 225
            let b = CGFloat((hexValue & 0x000000FF)) / 225
            
            colorArray.append(Color(UIColor(red: r, green: g, blue: b, alpha: 1)))
        }
        
        
        return colorArray
    }
    
    //returns true if at least one oclor is warm
    // the more 'R' we have in rgb more warmere it will be
    func isLight(colors: [String]) -> Bool{
        var isLight = false
        
        var count = 0
        for color in colors {
            //removing #
            var trimmed = color.trimmingCharacters(in: .whitespaces).uppercased()
            
            trimmed.remove(at: trimmed.startIndex)
            
            var hexValue: UInt64 = 0
            Scanner(string: trimmed).scanHexInt64(&hexValue)
            
            let r = CGFloat((hexValue & 0x00FF0000) >> 16)
            let g = CGFloat((hexValue & 0x0000FF00) >> 8)
            let b = CGFloat((hexValue & 0x000000FF))
            
            let hsp = sqrt(0.299 * (r * r ) + 0.587 * (g * g) + 0.114 * (b * b))
            if hsp > 127.5 {
                count += 1
            }
            print("hsp: \(hsp)")
        }
        
        if count > (colors.count / 2){
            isLight = true
        }
        return isLight
    }
}
