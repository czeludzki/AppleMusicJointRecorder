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
    @State private var isMemberEditorPresented = false
    
    var body: some View {
        TabView(selection: self.$tabSelection) {
            NavigationView {
                MemberListView()
                    .navigationBarTitle(Text("Member"))
                    .navigationViewStyle(.stack)
                    .navigationBarItems(trailing: HStack {
                        Button.init {
                            self.isMemberEditorPresented.toggle()
                        } label: {
                            Text("New Member")
                        }.fullScreenCover(isPresented: self.$isMemberEditorPresented) {
                            MemberEditorView.init(memberVM: MemberVM.init())
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
                                // 弹出视图
                                ProductEditorView.init(productVM: ProductVM.init())
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
