# Fork build of PokeTokenBar, installed on the fork owner's Mac.
# .github/workflows/fork-release.yml rewrites `version` and `sha256` after each release.
# No `zap` stanza on purpose: no brew command may delete the save folder.
cask "poke-token-bar" do
  version "2.5.7,3.1"
  sha256 "c623a289f5968962546d217baa3229becd17ca3d3764b427bd383fb568c2e610"

  url "https://github.com/y0natancohen/PokeTokenBar/releases/download/fork-v#{version.csv.first}-#{version.csv.second}/PokeTokenBar.zip"
  name "PokeTokenBar"
  desc "Menu bar app turning AI coding token usage into a growing Pokemon (fork build)"
  homepage "https://github.com/y0natancohen/PokeTokenBar"

  app "PokeTokenBar.app"

  # Same as upstream's cask: the app is self-signed, not notarized.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/PokeTokenBar.app"],
                   sudo: false
  end
end
