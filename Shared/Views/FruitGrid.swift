//
//  FruitGrid.swift
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

struct FruitGrid<Menu>: View where Menu: ViewModifier {
    
    // MARK: Parameters
    
    @Binding var fruits: [Fruit]
    //@Binding var selectedFruit: Fruit.ID?
    @Binding var selectedFruit: Set<Fruit.ID>
    var menu: (Fruit) -> Menu
    
    // MARK: Locals
    
    private let columns = [GridItem(.adaptive(minimum: CGFloat(200)))]
    private let cornerRadius: CGFloat = 20
    private let borderWidth: CGFloat = 4
    
    private func isSelected(_ id: Fruit.ID) -> Bool {
#if os(iOS)
        return false
#elseif os(macOS)
        return selectedFruit.contains(id)
#endif
    }
    
    private func toggleSelected(_ id: Fruit.ID) {
#if os(iOS)
        return
#elseif os(macOS)
        if isSelected(id) {
            selectedFruit.remove(id)
        } else {
            selectedFruit.insert(id)
        }
#endif
    }
    
    // MARK: Views
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns) {
                ForEach(fruits, id: \.id) { fruit in
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(fruit.color)
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .strokeBorder(isSelected(fruit.id) ? Color.white : Color.clear, lineWidth: borderWidth)
                        cellContents(fruit)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                    }
                    .compositingGroup()
                    .shadow(radius: 3)
                    .onTapGesture { toggleSelected(fruit.id) }
                    .modifier(menu(fruit))
                }
            }
            Spacer()
        }
        .padding()
    }
    
    private func cellContents(_ fruit: Fruit) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .top) {
                Text(fruit.id)
                    .font(.largeTitle)
                Spacer()
                Text(fruit.name)
                    .font(.title)
            }
            Spacer()
            HStack(alignment: .bottom) {
                Spacer()
                Text(String(format: "%.0f g", fruit.weight))
            }
        }
    }
}

//struct FruitGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        FruitGrid()
//    }
//}
