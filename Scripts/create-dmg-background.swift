import AppKit
import Foundation

guard CommandLine.arguments.count == 2 else {
    fputs("Usage: create-dmg-background.swift <output-path>\n", stderr)
    exit(64)
}

let outputURL = URL(fileURLWithPath: CommandLine.arguments[1])
let size = NSSize(width: 760, height: 440)
let image = NSImage(size: size)

image.lockFocus()
NSColor(calibratedRed: 0.055, green: 0.082, blue: 0.125, alpha: 1).setFill()
NSBezierPath(rect: NSRect(origin: .zero, size: size)).fill()

NSColor(calibratedRed: 0.20, green: 0.27, blue: 0.38, alpha: 0.75).setStroke()
let border = NSBezierPath(roundedRect: NSRect(x: 1, y: 1, width: size.width - 2, height: size.height - 2), xRadius: 14, yRadius: 14)
border.lineWidth = 1
border.stroke()

let arrowColor = NSColor(calibratedRed: 0.82, green: 0.87, blue: 0.95, alpha: 0.95)
arrowColor.setStroke()
let arrow = NSBezierPath()
arrow.move(to: NSPoint(x: 328, y: 246))
arrow.line(to: NSPoint(x: 432, y: 246))
arrow.lineCapStyle = .round
arrow.lineWidth = 9
arrow.stroke()

let arrowHead = NSBezierPath()
arrowHead.move(to: NSPoint(x: 402, y: 282))
arrowHead.line(to: NSPoint(x: 440, y: 246))
arrowHead.line(to: NSPoint(x: 402, y: 210))
arrowHead.lineCapStyle = .round
arrowHead.lineJoinStyle = .round
arrowHead.lineWidth = 9
arrowHead.stroke()

let paragraph = NSMutableParagraphStyle()
paragraph.alignment = .center
let instruction = NSAttributedString(
    string: "LimitChecker.app in den Programme-Ordner ziehen",
    attributes: [
        .font: NSFont.systemFont(ofSize: 20, weight: .medium),
        .foregroundColor: NSColor(calibratedRed: 0.86, green: 0.89, blue: 0.95, alpha: 1),
        .paragraphStyle: paragraph,
    ]
)
instruction.draw(in: NSRect(x: 60, y: 54, width: 640, height: 28))
image.unlockFocus()

guard let tiff = image.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiff),
      let png = bitmap.representation(using: .png, properties: [:]) else {
    fputs("Could not render DMG background.\n", stderr)
    exit(1)
}

try png.write(to: outputURL)
