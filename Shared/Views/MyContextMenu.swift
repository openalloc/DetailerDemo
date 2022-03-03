//
//  MyContextMenu.swift
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
import DetailerMenu

public struct MyContextMenu<E>: ViewModifier where E: Identifiable
{
    private var config: DetailerConfig<E>
    @Binding private var toView: E?
    @Binding private var toEdit: E?
    private var element: E
    
    public init(_ config: DetailerConfig<E>,
                _ toView: Binding<E?>,
                _ toEdit: Binding<E?>,
                _ element: E) {
        self.config = config
        _toView = toView
        _toEdit = toEdit
        self.element = element
    }
        
    public func body(content: Content) -> some View {
        content
            .contextMenu {
                DetailerViewButton(element: element) { toView = $0 }
                DetailerEditButton(element: element, canEdit: config.canEdit) { toEdit = $0 }
                
                if config.onDelete != nil {
                    Divider()
                    DetailerDeleteButton(element: element, canDelete: config.canDelete, onDelete: config.onDelete)
                }
            }
    }
}

