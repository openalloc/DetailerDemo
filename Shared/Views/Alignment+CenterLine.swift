//
//  HorizontalAlignment.swift
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

extension HorizontalAlignment {
    private struct CenterLine: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.center]
        }
    }

    static let centerLine = Self(CenterLine.self)
}

// NOTE requires VStack(alignment: .centerLine) { ... }
extension View {
    func clLeading() -> some View {
        alignmentGuide(.centerLine) { $0[.trailing] }
    }

    func clTrailing() -> some View {
        alignmentGuide(.centerLine) { $0[.leading] }
    }
}
