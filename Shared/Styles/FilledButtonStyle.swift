import SwiftUI

struct FilledButtonStyle: ButtonStyle {
    
    enum Level {
        case primary
        case secondary
    }
    
    enum Width {
        case full
        case compact
    }
    
    var colorScheme: ColorScheme?
    var level: Level = .primary
    var width: Width = .full
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if width == .full {
                Spacer()
            }
            configuration.label
            if width == .full {
                Spacer()
            }
        }
        .frame(maxHeight: .infinity)
        .foregroundColor(foregroundColor)
        .background(backgroundColor)
        .overlay(configuration.isPressed ? pressedOverlayColor : Color.clear)
        .animation(.none)
    }
    
    private var foregroundColor: Color {
        (level == .primary) ? .white : .accentColor
    }
    
    private var backgroundColor: Color {
        switch (level, colorScheme) {
        case (.primary, _):
            return Color.accentColor
        case (.secondary, .dark):
            return Color.accentColor.opacity(0.2)
        case (.secondary, _):
            return Color.accentColor.opacity(0.1)
        }
    }
    
    private var pressedOverlayColor: Color {
        Color.black.opacity(0.1)
    }
}

struct FilledButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("Button", action: {})
            .buttonStyle(FilledButtonStyle(colorScheme: .light))
    }
}
