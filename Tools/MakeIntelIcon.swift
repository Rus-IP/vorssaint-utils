// SPDX-License-Identifier: GPL-3.0-or-later
// A procedural identity for the unofficial Intel experiment.
import AppKit

let out = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "build/AppIcon.iconset"
try FileManager.default.createDirectory(atPath: out, withIntermediateDirectories: true)
let sizes = [("icon_16x16",16),("icon_16x16@2x",32),("icon_32x32",32),("icon_32x32@2x",64),
             ("icon_128x128",128),("icon_128x128@2x",256),("icon_256x256",256),("icon_256x256@2x",512),
             ("icon_512x512",512),("icon_512x512@2x",1024)]
func render(_ width: Int, _ height: Int, app: Bool) throws -> Data {
    guard let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: width, pixelsHigh: height,
                                    bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                                    colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0),
          let context = NSGraphicsContext(bitmapImageRep: rep) else {
        throw NSError(domain: "BarKitIcon", code: 1)
    }
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = context
    defer { NSGraphicsContext.restoreGraphicsState() }
    let w = CGFloat(width), h = CGFloat(height)
    if app {
        NSColor(calibratedRed: 0.07, green: 0.13, blue: 0.2, alpha: 1).setFill()
        NSBezierPath(roundedRect: NSRect(x: w*0.06, y: h*0.06, width: w*0.88, height: h*0.88),
                     xRadius: w*0.18, yRadius: h*0.18).fill()
        NSColor(calibratedRed: 0.2, green: 0.8, blue: 0.9, alpha: 1).setFill()
    } else { NSColor.black.setFill() }
    for (i, fraction) in [0.4, 0.65, 0.5].enumerated() {
        let x = w*(0.24 + Double(i)*0.19)
        let barH = h*fraction
        NSBezierPath(roundedRect: NSRect(x: x, y: (h-barH)/2, width: w*0.13, height: barH),
                     xRadius: w*0.035, yRadius: w*0.035).fill()
    }
    guard let data = rep.representation(using: .png, properties: [:]) else {
        throw NSError(domain: "BarKitIcon", code: 2)
    }
    return data
}
for (name, px) in sizes {
    try render(px, px, app: true).write(to: URL(fileURLWithPath: "\(out)/\(name).png"))
}
let parent = URL(fileURLWithPath: out).deletingLastPathComponent()
try render(26, 20, app: false).write(to: parent.appendingPathComponent("MenuBarIcon.png"))
try render(52, 40, app: false).write(to: parent.appendingPathComponent("MenuBarIcon@2x.png"))
try render(256, 256, app: true).write(to: parent.appendingPathComponent("BrandMark.png"))
let task = Process()
task.executableURL = URL(fileURLWithPath: "/usr/bin/iconutil")
task.arguments = ["-c", "icns", out, "-o", parent.appendingPathComponent("AppIcon.icns").path]
try task.run()
task.waitUntilExit()
guard task.terminationStatus == 0 else { exit(task.terminationStatus) }
