import XCTest
@testable import PokeTokenBar

// Temporary, not for upstream: checks the incense share on the real base index
// (PokéAPI GraphQL, fetched 2026-11-16, 328 bases).
private struct LiveIndexProvider: PokeProviding {
    static let pairs: [(Int, Int)] = [(1, 45), (4, 45), (7, 45), (10, 255), (13, 255), (16, 255), (19, 255), (21, 255), (23, 255), (27, 255), (29, 235), (32, 235), (37, 190), (41, 255), (43, 255), (46, 190), (48, 190), (50, 255), (52, 255), (54, 190), (56, 190), (58, 190), (60, 255), (63, 200), (66, 180), (69, 255), (72, 190), (74, 255), (77, 190), (79, 190), (81, 190), (83, 45), (84, 190), (86, 190), (88, 190), (90, 190), (92, 190), (95, 45), (96, 190), (98, 225), (100, 190), (102, 90), (104, 190), (108, 45), (109, 190), (111, 120), (114, 45), (115, 45), (116, 225), (118, 225), (120, 225), (123, 45), (127, 45), (128, 45), (129, 255), (131, 45), (133, 45), (137, 45), (138, 45), (140, 45), (142, 45), (144, 3), (145, 3), (146, 3), (147, 45), (150, 3), (151, 45), (152, 45), (155, 45), (158, 45), (161, 255), (163, 255), (165, 255), (167, 255), (170, 190), (172, 190), (173, 150), (174, 170), (175, 190), (177, 190), (179, 235), (187, 255), (190, 45), (191, 235), (193, 75), (194, 255), (198, 30), (200, 45), (201, 225), (203, 60), (204, 190), (206, 190), (207, 60), (209, 190), (211, 45), (213, 190), (214, 45), (215, 60), (216, 120), (218, 190), (220, 225), (222, 60), (223, 190), (225, 45), (227, 25), (228, 120), (231, 120), (234, 45), (235, 45), (236, 75), (238, 45), (239, 45), (240, 45), (241, 45), (243, 3), (244, 3), (245, 3), (246, 45), (249, 3), (250, 3), (251, 45), (252, 45), (255, 45), (258, 45), (261, 255), (263, 255), (265, 255), (270, 255), (273, 255), (276, 200), (278, 190), (280, 235), (283, 200), (285, 255), (287, 255), (290, 255), (293, 190), (296, 180), (298, 150), (299, 255), (300, 255), (302, 45), (303, 45), (304, 180), (307, 180), (309, 120), (311, 200), (312, 200), (313, 150), (314, 150), (316, 225), (318, 225), (320, 125), (322, 255), (324, 90), (325, 255), (327, 255), (328, 255), (331, 190), (333, 255), (335, 90), (336, 90), (337, 45), (338, 45), (339, 190), (341, 205), (343, 255), (345, 45), (347, 45), (349, 255), (351, 45), (352, 200), (353, 225), (355, 190), (357, 200), (359, 30), (360, 125), (361, 190), (363, 255), (366, 255), (369, 25), (370, 225), (371, 45), (374, 3), (377, 3), (378, 3), (379, 3), (380, 3), (381, 3), (382, 3), (383, 3), (384, 45), (385, 3), (386, 3), (387, 45), (390, 45), (393, 45), (396, 255), (399, 255), (401, 255), (403, 235), (406, 255), (408, 45), (410, 45), (412, 120), (415, 120), (417, 200), (418, 190), (420, 190), (422, 190), (425, 125), (427, 190), (431, 190), (433, 120), (434, 225), (436, 255), (438, 255), (439, 145), (440, 130), (441, 30), (442, 100), (443, 45), (446, 50), (447, 75), (449, 140), (451, 120), (453, 140), (455, 200), (456, 190), (458, 25), (459, 120), (479, 45), (480, 3), (481, 3), (482, 3), (483, 3), (484, 3), (485, 3), (486, 3), (487, 3), (488, 3), (489, 30), (490, 3), (491, 3), (492, 45), (493, 3), (494, 3), (495, 45), (498, 45), (501, 45), (504, 255), (506, 255), (509, 255), (511, 190), (513, 190), (515, 190), (517, 190), (519, 255), (522, 190), (524, 255), (527, 190), (529, 120), (531, 255), (532, 180), (535, 255), (538, 45), (539, 45), (540, 255), (543, 255), (546, 190), (548, 190), (550, 25), (551, 180), (554, 120), (556, 255), (557, 190), (559, 180), (561, 45), (562, 190), (564, 45), (566, 45), (568, 190), (570, 75), (572, 255), (574, 200), (577, 200), (580, 190), (582, 255), (585, 190), (587, 200), (588, 200), (590, 190), (592, 190), (594, 75), (595, 190), (597, 255), (599, 130), (602, 190), (605, 255), (607, 190), (610, 75), (613, 120), (615, 25), (616, 200), (618, 75), (619, 180), (621, 45), (622, 190), (624, 120), (626, 45), (627, 190), (629, 190), (631, 90), (632, 90), (633, 45), (636, 45), (638, 3), (639, 3), (640, 3), (641, 3), (642, 3), (643, 3), (644, 3), (645, 3), (646, 3), (647, 3), (648, 3), (649, 3)]
    static let entries = pairs.map { BaseSpecies(id: $0.0, captureRate: $0.1) }
    func baseSpeciesIndex() async throws -> [BaseSpecies] { Self.entries }
    func baseSpecies(id: Int) async throws -> BaseSpecies? { Self.entries.first { $0.id == id } }
    func line(baseSpeciesID: Int) async throws -> EvoLine {
        guard let e = Self.entries.first(where: { $0.id == baseSpeciesID }) else { throw URLError(.badURL) }
        return EvoLine(baseID: e.id, tree: EvoNode(speciesID: e.id, children: []),
                       rarity: Rarity.from(captureRate: e.captureRate, isLegendary: false, isMythical: false),
                       names: [e.id: ["en": "M\(e.id)"]])
    }
}

@MainActor
final class IncenseLiveCheckTests: XCTestCase {
    func testShareOnTheLiveIndex() async {
        XCTAssertEqual(LiveIndexProvider.entries.count, 328)
        let now = Date(timeIntervalSince1970: 1_700_000_000)
        let rolls: UInt64 = 2000
        for tier in [Rarity?.none, .uncommon, .rare] {
            let pool = LiveIndexProvider.entries.filter { e in tier.map { $0.includes(captureRate: e.captureRate) } ?? true }
            for region in PokedexRegion.allCases {
                let flags = pool.map { region.dexRange.contains($0.id) }
                let natural = Double(zip(pool, flags).filter { $0.1 }.map { $0.0.captureRate }.reduce(0, +))
                    / Double(pool.map(\.captureRate).reduce(0, +))
                var hatched = 0, inRegion = 0, belowTier = 0
                for seed in 1...rolls {
                    let f = FileManager.default.temporaryDirectory.appendingPathComponent("live-\(UUID().uuidString).json")
                    let json = "{\"installBaselineSet\":true,\"usedSinceInstall\":1,\"spentTokens\":0,\"lastDate\":\"d\","
                        + "\"dex\":[],\"collectedFinals\":[],\"active\":null,\"eggUsage\":\(PokemonBalance.eggHatchThreshold),"
                        + "\"eggTier\":\(tier.map { "\"\($0.rawValue)\"" } ?? "null"),\"pendingIncense\":\"\(region.rawValue)\"}"
                    try? json.data(using: .utf8)!.write(to: f)
                    let s = CompanionStore(provider: LiveIndexProvider(), clock: { now }, fileURL: f, rng: SeededRNG(seed: seed))
                    await s.hatchIfNeeded()
                    try? FileManager.default.removeItem(at: f)
                    guard let a = s.state.active else { continue }
                    hatched += 1
                    if region.dexRange.contains(a.baseID) { inRegion += 1 }
                    if let tier, a.rarity.sortRank < tier.sortRank { belowTier += 1 }
                    XCTAssertNil(s.state.pendingIncense)
                }
                let share = Double(inRegion) / Double(max(1, hatched))
                print(String(format: "LIVE-SHARE tier=%@ region=%@ candidates=%d natural=%.1f%% hatched=%d share=%.1f%% belowTier=%d",
                             tier?.rawValue ?? "plain", region.rawValue, flags.filter { $0 }.count, natural * 100,
                             hatched, share * 100, belowTier))
                XCTAssertEqual(hatched, Int(rolls))
                XCTAssertEqual(belowTier, 0)
                XCTAssertEqual(share, 0.80, accuracy: 0.03, "tier=\(String(describing: tier)) region=\(region)")
            }
        }
    }
}
