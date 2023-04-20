//
//  FruitTable.swift
//
// Copyright 2021, 2022 OpenAlloc LLC
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

struct FruitTable<Menu>: View where Menu: ViewModifier {
    // MARK: Parameters

    @Binding var fruits: [Fruit]
    // @Binding var selectedFruit: Fruit.ID?
    @Binding var selectedFruit: Set<Fruit.ID>
    var menu: (Fruit) -> Menu

    // MARK: Locals

    @State private var sortOrder = [KeyPathComparator(\Fruit.name)]

    // MARK: Views

    var body: some View {
        Table(fruits, selection: $selectedFruit, sortOrder: $sortOrder) {
            TableColumn("ID", value: \.id) {
                Text($0.id)
                    .modifier(menu($0))
            }
            .width(20)

            TableColumn("Name", value: \.name) { fruit in
                Text(fruit.name)
                    .foregroundColor(fruit.color)
                    .modifier(menu(fruit))
            }
            .width(250)

            TableColumn("Weight", value: \.weight) {
                Text(String(format: "%.0f g", $0.weight))
                    .modifier(menu($0))
            }

            .width(60)
            TableColumn("Color") {
                RoundedRectangle(cornerRadius: 3).fill($0.color)
                    .modifier(menu($0))
            }
            .width(40)
        }
        .onChange(of: sortOrder) {
            fruits.sort(using: $0)
        }
    }
}

// struct FruitTable_Previews: PreviewProvider {
//    static var previews: some View {
//        FruitTable()
//    }
// }
