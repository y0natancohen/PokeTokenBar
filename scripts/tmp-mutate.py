"""Temporary, fork only. Applies one named defect to the incense code."""
import pathlib, sys
STORE = "Sources/PokeTokenBar/Core/CompanionStore.swift"
MODEL = "Sources/PokeTokenBar/Core/CompanionModel.swift"
M = {
  "no-rescale": (STORE, "                    weights = biased\n", ""),
  "no-generation-bump": (STORE, "            prefetchedLineID = nil\n            activeGeneration += 1\n            Task { await self.ensureEggPrefetch() }",
                                 "            prefetchedLineID = nil\n            Task { await self.ensureEggPrefetch() }"),
  "keep-pre-roll": (STORE, "            state.discardPreRoll()\n            prefetchedLineID = nil\n            activeGeneration += 1",
                           "            prefetchedLineID = nil\n            activeGeneration += 1"),
  "rest-no-exclude": (STORE, "                excluded = incense.dexRange\n", "                excluded = nil\n"),
  "always-spend": (STORE, "if rolledIncense == burning { state.pendingIncense = nil } else { unspentIncense = burning }",
                          "state.pendingIncense = nil; if rolledIncense != burning { unspentIncense = nil }"),
  "never-spend": (STORE, "if rolledIncense == burning { state.pendingIncense = nil } else { unspentIncense = burning }",
                         "if rolledIncense != burning { unspentIncense = burning }"),
  "second-incense-allowed": (STORE, "kind.incenseRegion != nil && itemCount(kind) > 0 && state.pendingIncense == nil",
                                    "kind.incenseRegion != nil && itemCount(kind) > 0"),
  "share-70": (MODEL, "static let inRegionSharePercent = 80", "static let inRegionSharePercent = 70"),
}
path, old, new = M[sys.argv[1]]
p = pathlib.Path(path); s = p.read_text()
assert s.count(old) == 1, (sys.argv[1], s.count(old))
p.write_text(s.replace(old, new))
