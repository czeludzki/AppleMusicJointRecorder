//
//  ContentView.swift
//  ApM Expense Caculator
//
//  Created by siu on 2022/10/15.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var vm: VM
    @State private var tabSelection: Int = 0
    @State private var isProductEditorPresented = false
    
    var body: some View {
        TabView(selection: self.$tabSelection) {
            NavigationView {
                MemberListView()
                    .navigationBarTitle(Text("Member"))
                    .navigationViewStyle(.stack)
                    .navigationBarItems(trailing: HStack {
                        Button.init {
                            
                        } label: {
                            Text("New Member")
                        }
                    })
            }.tabItem {
                Text("Member")
                Image(systemName: "shippingbox.circle")
            }
            NavigationView {
                ProductListView()
                    .navigationBarTitle(Text("Product"))
                    .navigationViewStyle(.stack)
                    .toolbar(content: {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button.init {
                                self.isProductEditorPresented.toggle()
                            } label: {
                                Text("New Product")
                            }.fullScreenCover(isPresented: self.$isProductEditorPresented) {
                                
                            }
                        }
                    })
            }.tabItem {
                Text("Product")
                Image(systemName: "person.crop.circle")
            }
        }.onAppear {
            self.vm.loadData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
