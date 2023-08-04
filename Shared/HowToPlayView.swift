//
//  HowToPlayView.swift
//  Super_Mind
//
//  Created by ВоВка on 30.07.2023.
//

import SwiftUI

struct HowToPlayView: View {
    var body: some View {
        NavigationView {
                    VStack {
                        NavigationLink(destination: GameView()) {
                            Text("Start")
                        }.padding()
                        Spacer()
                        Button(action: {
                           
                        }) {
                            Text("Как играть?").padding()                        }
                        HStack{
                        Text("Copyright © «2023»")
                            Button(action: {
                               if let url = URL(string: "") {
                                  UIApplication.shared.open(url)
                               }
                            }) {
                               Text("«V228a»")
                            }
                        }
                    }
                    .navigationTitle("Super Mind")
                }
    }
}

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
    }
}
