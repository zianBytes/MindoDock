import SwiftUI

struct ExpandableIslandShape: Shape {
    /// expansion: 0 = collapsed (just tab), 1 = fully expanded
    var expansion: CGFloat
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Measurements
        let cornerRadius: CGFloat = 40
        let tabHeight: CGFloat = 38
        let notchWidth: CGFloat = 140
        let notchDepth: CGFloat = 7 // shallower curve
        let notchCurve: CGFloat = 7 // shallower curve
        let expandedHeight: CGFloat = rect.height
        let collapsedHeight: CGFloat = tabHeight
        let currentHeight = collapsedHeight + (expandedHeight - collapsedHeight) * expansion
        let startNotchX = rect.midX - notchWidth / 2
        let endNotchX = rect.midX + notchWidth / 2
        // Start at top left corner
        path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))
        // Top left corner
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )
        // Left edge
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + currentHeight - cornerRadius))
        // Bottom left corner
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + currentHeight),
            control: CGPoint(x: rect.minX, y: rect.minY + currentHeight)
        )
        // Bottom edge to start of notch
        path.addLine(to: CGPoint(x: startNotchX, y: rect.minY + currentHeight))
        // Notch dip (bottom curve, shallower)
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.minY + currentHeight + notchDepth),
            control: CGPoint(x: rect.midX - notchWidth / 2.2, y: rect.minY + currentHeight + notchCurve)
        )
        path.addQuadCurve(
            to: CGPoint(x: endNotchX, y: rect.minY + currentHeight),
            control: CGPoint(x: rect.midX + notchWidth / 2.2, y: rect.minY + currentHeight + notchCurve)
        )
        // Bottom edge to bottom right corner
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + currentHeight))
        // Bottom right corner
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY + currentHeight - cornerRadius),
            control: CGPoint(x: rect.maxX, y: rect.minY + currentHeight)
        )
        // Right edge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius))
        // Top right corner
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY),
            control: CGPoint(x: rect.maxX, y: rect.minY)
        )
        // Back to top left
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    VStack(spacing: 0) {
        ZStack {
            Color.black
            ExpandableIslandShape(expansion: 0)
                .fill(Color(red: 0.08, green: 0.09, blue: 0.11))
                .frame(width: 700, height: 140)
                .shadow(color: .black.opacity(0.18), radius: 40, y: 12)
        }
        .frame(height: 60)
        ZStack {
            Color.black
            ExpandableIslandShape(expansion: 1)
                .fill(Color(red: 0.08, green: 0.09, blue: 0.11))
                .frame(width: 700, height: 140)
                .shadow(color: .black.opacity(0.18), radius: 40, y: 12)
        }
        .frame(height: 140)
    }
}
