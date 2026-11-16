import XCTest
import SwiftUI
@testable import PokeTokenBar

// Temporary, fork only: renders the Shop with the single incense card for the PR description.
private struct RenderProvider: PokeProviding {
    func line(baseSpeciesID: Int) async throws -> EvoLine { throw URLError(.badURL) }
    func baseSpeciesIndex() async throws -> [BaseSpecies] { throw URLError(.badURL) }
}

@MainActor
final class IncenseShopRenderTests: XCTestCase {
    private var windows: [NSWindow] = []

    func testRenderShopWithOneIncenseCard() async throws {
        guard let dir = ProcessInfo.processInfo.environment["PTB_SNAPSHOT_SCREENSHOT_DIR"] else {
            throw XCTSkip("no output directory")
        }
        try FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true)
        let f = FileManager.default.temporaryDirectory.appendingPathComponent("render-\(UUID().uuidString).json")
        let mon = "{\"baseID\":10,\"pathIDs\":[10],\"stageIndex\":0,\"usedAtStage\":20000000,"
            + "\"rarity\":\"common\",\"totalForms\":3,\"isShiny\":false}"
        let json = "{\"installBaselineSet\":true,\"usedSinceInstall\":20000000000,\"spentTokens\":0,\"lastDate\":\"d\","
            + "\"language\":\"en\",\"active\":\(mon),\"dex\":[],\"collectedFinals\":[],\"inventory\":{\"hoennIncense\":2}}"
        try json.data(using: .utf8)!.write(to: f)
        let store = CompanionStore(provider: RenderProvider(), fileURL: f)
        for (scheme, name) in [(ColorScheme.light, "light"), (.dark, "dark")] {
            let height: CGFloat = 560
            let width = PopoverMetrics.contentWidth
            let view = ShopView(store: store, nav: PopoverNavigation())
                .padding(12)
                .frame(width: width, height: height)
                .background(scheme == .dark ? Color(red: 0.16, green: 0.16, blue: 0.165) : Color.white)
                .environment(\.colorScheme, scheme)
            let host = NSHostingView(rootView: view)
            host.frame = NSRect(x: 0, y: 0, width: width, height: height)
            let window = NSWindow(contentRect: NSRect(x: -10000, y: -10000, width: width, height: height),
                                  styleMask: .borderless, backing: .buffered, defer: false)
            window.isReleasedWhenClosed = false
            window.appearance = NSAppearance(named: scheme == .dark ? .darkAqua : .aqua)
            window.contentView = host
            window.orderFront(nil)
            windows.append(window)
            try await Task.sleep(for: .seconds(4))   // item sprites load over the network
            host.layoutSubtreeIfNeeded()
            let bounds = host.bounds
            let bitmap = try XCTUnwrap(NSBitmapImageRep(
                bitmapDataPlanes: nil, pixelsWide: Int(bounds.width * 2), pixelsHigh: Int(bounds.height * 2),
                bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0))
            bitmap.size = bounds.size
            host.cacheDisplay(in: bounds, to: bitmap)
            let png = try XCTUnwrap(bitmap.representation(using: .png, properties: [:]))
            try png.write(to: URL(fileURLWithPath: dir).appendingPathComponent("incense-shop-\(name).png"))
        }
    }
}
