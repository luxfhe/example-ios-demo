// Copyright © 2025 Lux. All rights reserved.

import SwiftUI

#Preview {
    VStack {
        Button("Foo") {}.buttonStyle(.bordered)
        Button("Foo") {}.buttonStyle(.borderedProminent)

        Button("Foo") {}.buttonStyle(.lux)
        Button("Foo") {}.buttonStyle(.lux).disabled(true)

        Button("Foo") {}.buttonStyle(.luxSecondary)
        Button("Foo") {}.buttonStyle(.luxSecondary).disabled(true)

        Button("Foo") {}.buttonStyle(.blackHighlight())
        Button("Foo") {}.buttonStyle(.blackHighlight()).disabled(true)

        AsyncButton(action: {}) {
            Label("Import Health Information", systemImage: "heart.text.clipboard")
        }.buttonStyle(.lux)

        Spacer()
    }
    .padding()
    .background(Color.white)
}

struct LuxButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration config: Configuration) -> some View {
        config.label
            .opacity(isEnabled ? 1 : 0.5)
            .padding(12)
            .frame(maxWidth: .infinity)
            .fontWeight(.bold)
            .background(.luxYellow.opacity(isEnabled ? 1 : 0.2))
            .border(config.isPressed ? .black : .clear, width: 1)
            .animation(.none, value: config.isPressed)
            .tint(.black)
    }
}

struct LuxSecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration config: Configuration) -> some View {
        config.label
            .opacity(isEnabled ? 1 : 0.3)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .fontWeight(.bold)
            .background(.black)
            .foregroundStyle(.white)
            .border(config.isPressed ? .red : .clear, width: 1.5)
            .animation(.none, value: config.isPressed)
            .tint(.black)
    }
}

struct BlackHighlightButtonStyle: ButtonStyle {
    var disabled: Bool
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration config: Configuration) -> some View {
        if disabled {
            config.label
        } else {
            config.label
                .opacity(isEnabled ? 1 : 0.5)
                .border(.black, width: config.isPressed ? 1 : 0)
                .animation(.none, value: config.isPressed)
        }
    }
}


extension ButtonStyle where Self == LuxButtonStyle {
    static var lux: LuxButtonStyle {
        LuxButtonStyle()
    }

    static var luxSecondary: LuxSecondaryButtonStyle {
        LuxSecondaryButtonStyle()
    }

    static func blackHighlight(disabled: Bool = false) -> BlackHighlightButtonStyle {
        BlackHighlightButtonStyle(disabled: disabled)
    }
}
