# Homebrew recipe for Bloub. It lives in github.com/nubidubi09/homebrew-bloub as Formula/bloub.rb.
class Bloub < Formula
  desc "AI assistant for the Mac that lives in the notch"
  homepage "https://github.com/nubidubi09/Bloub"
  license "MIT"
  head "https://github.com/nubidubi09/Bloub.git", branch: "main"

  depends_on xcode: ["27.2", :build]
  depends_on :macos

  def install
    # Built on your Mac and signed for your Mac only: no Apple developer account involved.
    system "scripts/release.sh", "#{buildpath}/dd",
           "CODE_SIGN_IDENTITY=-",
           "-clonedSourcePackagesDirPath", "#{buildpath}/packages",
           "-IDEPackageSupportDisableManifestSandbox=YES",
           "-IDEPackageSupportDisablePluginExecutionSandbox=YES",
           # Swift's macros (@State, @Observable) start their own sandbox, which Homebrew's sandbox does not allow.
           "OTHER_SWIFT_FLAGS=$(inherited) -disable-sandbox"
    prefix.install "#{buildpath}/dd/Build/Products/Release/Bloub.app" => "Bloub.app"
    (bin/"bloub").write <<~SH
      #!/bin/sh
      exec open "#{opt_prefix}/Bloub.app"
    SH
    chmod 0755, bin/"bloub"
  end

  def caveats
    <<~TEXT
      Start Bloub by typing:  bloub
      Then open Settings (⌘,) and paste your Claude API key.
    TEXT
  end
end
