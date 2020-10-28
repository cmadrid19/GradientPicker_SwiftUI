//
//  Home.swift
//  GradientPicker
//
//  Created by Maxim Macari on 28/10/2020.
//

import SwiftUI

struct Home: View {
    
    @State var show = false
    @State var search = ""
    @State var gradients: [Gradient] = []
    @State var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    @State var filtered: [Gradient] = []
    
    var body: some View {
        VStack{
            HStack(spacing: 15){
                
                if show {
                    
                    //Search Bar
                    
                    TextField("Search Gradient", text: $search)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    //fuctionality
                        .onChange(of: search, perform: { value in
                            if search != "" {
                                self.searchColors()
                            }else{
                                //Clearing all search results
                                search = ""
                                filtered = gradients
                            }
                        })
                    
                    Button(action: {
                        
                        withAnimation(.easeOut){
                            //Clear search
                            search = ""
                            //safe side
                            filtered = gradients
                            show.toggle()
                        }
                        
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    })
                }else{
                    Text("Gradients")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: {
                        
                        withAnimation(.easeOut){
                            show.toggle()
                        }
                        
                    }, label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title)
                    })
                    
                    
                    Button(action: {
                        
                        withAnimation(.easeOut){
                            if columns.count == 1 {
                                columns.append(GridItem(.flexible(), spacing: 20))
                            }
                            else{
                                columns.removeLast()
                            }
                        }
                        
                    }, label: {
                        Image(systemName: columns.count == 1 ? "square.grid.2x2.fill" : "rectangle.grid.1x2.fill")
                            .font(.title)
                    })
                    
                }
                
                
            }
            .padding(.top, 20)
            .padding(.bottom, 10)
            .padding(.horizontal)
            
            if gradients.isEmpty {
                //loading view..
                ProgressView()
                    .padding(.top, 55)
                
                Spacer()
            }else{
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(columns: columns, spacing: 20){
                        // assigning name as ID
                        ForEach(filtered, id: \.name){ gradient in
                            ColorCard(gradient: gradient, columns: columns)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .zIndex(0)
            }
            
        }
        .onAppear(){
            self.getColors()
        }
    }
    
    //Loading JSON Data
    private func getColors(){
        
        let urlString = "https://raw.githubusercontent.com/ghosh/uiGradients/master/gradients.json"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url){  (data, res, err) in
            guard let jsonData = data else {
                return
            }
            
            do{
                //decoding JSON
                let colors = try JSONDecoder().decode([Gradient].self, from: jsonData)
                self.gradients = colors
                self.filtered = colors
                print(self.gradients)
            }catch{
                print(error)
            }
        }
        .resume()
        
    }
    
    private func searchColors() {
        let query = search.lowercased()
        
        // using bg thread to reduce main ui usage
        // optimize resources, wait till user stops typying
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.3 , qos: .background) {
            
            let filter = gradients.filter { (gradient) -> Bool in
                if gradient.name.lowercased().contains(query){
                    return true
                }else{
                    return false
                }
            }
            //Refreshing view
            DispatchQueue.main.async {
                withAnimation(.spring()){
                    self.filtered = filter
                }
            }
        }
    }
    
    
}



