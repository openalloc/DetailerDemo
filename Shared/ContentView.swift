//
//  ContentView.swift
//
// Copyright 2022 FlowAllocator LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI

import Detailer

struct ContentView: View {
    
    public init(_ fruits: [Fruit]) {
        _fruits = State(initialValue: fruits)
    }
    
    // MARK: - Locals
    
    enum Tabs {
        case table
        case list
        case grid
    }
    
    private let title = "Detailer Demo"
    
    @State private var fruits: [Fruit]
    //@State private var selectedFruit: Fruit.ID? = nil
    @State private var selectedFruit: Set<Fruit.ID> = Set()
    @State private var toEdit: Fruit? = nil
    @State private var toView: Fruit? = nil
    @State private var isAdd: Bool = false
    @State private var tab: Tabs = .list
    
    typealias Config = DetailerConfig<Fruit>
    
    private var config: Config {
        Config(
            canEdit: { $0.name != "Orange" },
            canDelete: { $0.name != "Kiwi" },
            onDelete: deleteAction,
            onValidate: validateAction,
            onSave: saveAction,
            titler: { _ in title })
    }
    
    // MARK: - Views
    
    var body: some View {
        Group {
#if os(macOS)
            theContent
#elseif os(iOS)
            NavigationView {
                theContent
                    .navigationTitle(title)
                    .toolbar {
                        addButton
                    }
            }
            .navigationViewStyle(StackNavigationViewStyle())
#endif
        }
#if os(macOS)
        .toolbar {
            ToolbarItemGroup {
                Button(action: { editAction(selectedFruit.first!) } ) {
                    Text("Edit")
                }
                .disabled(selectedFruit.count != 1)
                
                Button(action: { viewAction(selectedFruit.first!) } ) {
                    Text("View")
                }
                .disabled(selectedFruit.count != 1)
                
                addButton
            }
        }
#endif
    }
    
    private var theContent: some View {
        TabView(selection: $tab) {
            listDetailer
                .tabItem { Text("List") }
                .tag(Tabs.list)
            
            gridDetailer
                .tabItem { Text("Grid") }
                .tag(Tabs.grid)
            
#if os(macOS)
            tableDetailer
                .tabItem { Text("Table") }
                .tag(Tabs.table)
#endif
        }
        .padding()
    }
    
    private var addButton: some View {
        Button(action: addAction) {
            Label("Add Item", systemImage: "plus")
        }
    }
    
#if os(macOS)
    private func menu(_ fruit: Fruit) -> MyContextMenu<Fruit> {
        MyContextMenu(config, $toView, $toEdit, fruit)
    }
#elseif os(iOS)
    private func menu(_ fruit: Fruit) -> MySwipeMenu<Fruit> {
        MySwipeMenu(config, $toView, $toEdit, fruit)
    }
#endif
    
    // MARK: - List/Table/Grid/Detail Views
    
    private var listDetailer: some View {
        FruitList(fruits: $fruits,
                  toEdit: $toEdit,
                  selectedFruit: $selectedFruit,
                  menu: menu)
            .editDetailer(config,
                          toEdit: $toEdit,
                          isAdd: $isAdd,
                          detailContent: editDetail)
            .viewDetailer(config,
                          toView: $toView,
                          viewContent: viewDetail)
    }
    
    private var gridDetailer: some View {
        ScrollView {
            FruitGrid(fruits: $fruits,
                      selectedFruit: $selectedFruit,
                      menu: { MyContextMenu(config, $toView, $toEdit, $0) })
        }
        .editDetailer(config,
                      toEdit: $toEdit,
                      isAdd: $isAdd,
                      detailContent: editDetail)
        .viewDetailer(config,
                      toView: $toView,
                      viewContent: viewDetail)
    }
    
#if os(macOS)
    private var tableDetailer: some View {
        SidewaysScroller(minWidth: 600) {
            FruitTable(fruits: $fruits,
                       selectedFruit: $selectedFruit,
                       menu: { MyContextMenu(config, $toView, $toEdit, $0) })
        }
        .editDetailer(config,
                      toEdit: $toEdit,
                      isAdd: $isAdd,
                      detailContent: editDetail)
        .viewDetailer(config,
                      toView: $toView,
                      viewContent: viewDetail)
    }
#endif
    
    private func editDetail(ctx: DetailerContext<Fruit>, element: Binding<Fruit>) -> some View {
        Form {
            TextField("ID", text: element.id)
                .validate(ctx, element, \.id) { $0.count > 0 }
            TextField("Name", text: element.name)
                .validate(ctx, element, \.name) { $0.count > 0 }
            TextField("Weight", value: element.weight, formatter: NumberFormatter())
                .validate(ctx, element, \.weight) { $0 > 0 }
            ColorPicker("Color", selection: element.color)
        }
    }
    
    private func viewDetail(element: Fruit) -> some View {
        VStack(alignment: .centerLine, spacing: 10) {
            HStack {
                Text("ID").clLeading()
                Text(element.id).clTrailing()
            }
            HStack {
                Text("Name").clLeading()
                Text(element.name).clTrailing()
            }
            HStack {
                Text("Weight").clLeading()
                Text(String(format: "%.0f g", element.weight)).clTrailing()
            }
            HStack {
                Text("Color").clLeading()
                Image(systemName: "circle.fill").foregroundColor(element.color).clTrailing()
            }
        }
    }
    
    // MARK: Action Handlers
    
    /// Element-level validation
    private func validateAction(_ context: DetailerContext<Fruit>, _ fruit: Fruit) -> [String] {
        if fruit.name == "Grapes" && fruit.weight == 2.0 {
            return ["'Grapes' not a valid name if weight is 2.0.", "It's a weird constraint, we know."]
        }
        return []
    }
    
    private func viewAction(_ id: Fruit.ID?) {
        guard let _id = id,
              let n = fruits.firstIndex(where: { $0.id == _id }) else { return }
        toView = fruits[n]
    }
    
    private func editAction(_ id: Fruit.ID?) {
        guard let _id = id,
              let n = fruits.firstIndex(where: { $0.id == _id }) else { return }
        isAdd = false
        toEdit = fruits[n]
    }
    
    private func addAction() {
        isAdd = true                // NOTE cleared on dismissal of detail sheet
        toEdit = Fruit()
    }
    
    private func saveAction(_ context: DetailerContext<Fruit>, _ element: Fruit) {
        if let n = fruits.firstIndex(where: { $0.id == element.id }) {
            fruits[n] = element
        } else if isAdd {
            withAnimation(.default) {
                fruits.append(element)
            }
        }
    }
    
    private func deleteAction(_ fruit: Fruit) {
        guard let n = fruits.firstIndex(where: { $0.id == fruit.id }) else { return }
        _ = withAnimation(.default) {
            fruits.remove(at: n)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(Fruit.bootstrap)
    }
}
