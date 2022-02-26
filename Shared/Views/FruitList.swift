//
//  FruitList.swift
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

struct FruitList<Menu>: View where Menu: ViewModifier {
    
    // MARK: Parameters
    
    @Binding var fruits: [Fruit]
    @Binding var toEdit: Fruit?
    //@Binding var selectedFruit: Fruit.ID?
    @Binding var selectedFruit: Set<Fruit.ID>
    var menu: (Fruit) -> Menu
    
    // MARK: Views
    
    var body: some View {
        List(fruits, id: \.id, selection: $selectedFruit) { fruit in
            rowContents(fruit)
                .modifier(menu(fruit))
        }
    }
    
    private func rowContents(_ fruit: Fruit) -> some View {
        HStack(alignment: .top) {
            Text(fruit.id)
            Text(fruit.name).foregroundColor(fruit.color)
            Spacer()
            Text(String(format: "%.0f g", fruit.weight))
        }
    }
}

//struct FruitTable_Previews: PreviewProvider {
//    static var previews: some View {
//        FruitTable()
//    }
//}
