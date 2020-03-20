//
//  ViewModifiers.swift
//  Italian Food Forever
//
//  Created by Gabriel Hoban on 3/20/20.
//  Copyright © 2020 Gabriel Hoban. All rights reserved.
//
import SwiftUI

struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

extension View {
    func hiddenNavigationBarStyle() -> some View {
        ModifiedContent(content: self, modifier: HiddenNavigationBar())
    }
}
