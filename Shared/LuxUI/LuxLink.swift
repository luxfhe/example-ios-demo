// Copyright © 2025 Zama. All rights reserved.
// Copyright © 2025 Lux Industries Inc.

import SwiftUI

#Preview {
    LuxLink()
}

struct LuxLink: View {
    var body: some View {
        Link(destination: LuxConfig.websiteLandingPage) {
            Image(.logoLuxZblack)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 32, height: 32)
                .opacity(0.095)
                .padding(.trailing, 16)
                .padding(.top, -4)
        }.buttonStyle(.plain)
    }
}
