cask "entropy" do
  arch arm: "arm64", intel: "x86_64"

  version "0.4.0"
  sha256 arm:   "eae53f3f3d1d0ac4a360bf08ada4e5dd7217d9708987bf4e73b18e4f7cf41ec3",
         intel: "bae3988ff0c7ad747219d116bd8e2688b9c43c82a3e0e0b9d2ea617e434d2f21"

  url "https://github.com/ergohaven/entropy/releases/download/v#{version}/entropy-v#{version}-macos-#{arch}.dmg"
  name "Entropy"
  desc "Ergohaven keyboard configurator"
  homepage "https://github.com/ergohaven/entropy"

  app "Entropy.app"
end
