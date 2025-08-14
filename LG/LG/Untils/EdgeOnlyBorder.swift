import SwiftUI

/// Custom Shape cho phép vẽ border từng cạnh + bo góc
struct PartialRoundedBorder: Shape {
    var edges: [Edge]
    var cornerRadius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let radii = CGSize(width: cornerRadius, height: cornerRadius)
        let roundedRect = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: radii
        )
        path.addPath(Path(roundedRect.cgPath))

        var borderPath = Path()
        if edges.contains(.top) {
            borderPath.move(to: CGPoint(x: rect.minX + (corners.contains(.topLeft) ? cornerRadius : 0), y: rect.minY))
            borderPath.addLine(to: CGPoint(x: rect.maxX - (corners.contains(.topRight) ? cornerRadius : 0), y: rect.minY))
        }
        if edges.contains(.leading) {
            borderPath.move(to: CGPoint(x: rect.minX, y: rect.minY + (corners.contains(.topLeft) ? cornerRadius : 0)))
            borderPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
        if edges.contains(.trailing) {
            borderPath.move(to: CGPoint(x: rect.maxX, y: rect.minY + (corners.contains(.topRight) ? cornerRadius : 0)))
            borderPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }

        path.addPath(borderPath)
        return path
    }
}

/// ViewModifier để dễ sử dụng
struct PartialBorderModifier: ViewModifier {
    let color: Color
    let width: CGFloat
    let edges: [Edge]
    let corners: UIRectCorner
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .clipShape(
                RoundedCorner(radius: cornerRadius, corners: corners)
            )
            .overlay(
                PartialRoundedBorder(edges: edges, cornerRadius: cornerRadius, corners: corners)
                    .stroke(color, lineWidth: width)
            )
    }
}

/// Hỗ trợ clip bo góc riêng từng góc
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func partialBorder(
        color: Color,
        width: CGFloat,
        edges: [Edge],
        corners: UIRectCorner,
        cornerRadius: CGFloat
    ) -> some View {
        self.modifier(
            PartialBorderModifier(
                color: color,
                width: width,
                edges: edges,
                corners: corners,
                cornerRadius: cornerRadius
            )
        )
    }
}
