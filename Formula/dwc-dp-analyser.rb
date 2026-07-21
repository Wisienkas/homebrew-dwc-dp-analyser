class DwcDpAnalyser < Formula
  desc "Validator/analyser CLI for DwC-DP data packages"
  homepage "https://github.com/gbif/dwc-dp-analyser"
  url "https://github.com/gbif/dwc-dp-analyser/releases/download/dwc-dp-analyser-0.0.8/dwc-dp-analyser-0.0.8.jar"
  sha256 "912eac45f52aae8f5fde458d57d34288c3cd157a0320f60138b7fce00dbae160"
  license "Apache-2.0"

  # Adjust the openjdk version constraint here if the CLI needs a specific
  # Java release (e.g. "openjdk@21") rather than whatever's latest.
  depends_on "openjdk"

  def install
    libexec.install "dwc-dp-analyser-0.0.8.jar" => "dwc-dp-analyser-cli.jar"
    (bin/"dwc-dp-analyser").write <<~SCRIPT
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/dwc-dp-analyser-cli.jar" --enable-native-access=ALL-UNNAMED "$@"
    SCRIPT
  end

  test do
    system "#{bin}/dwc-dp-analyser", "--help"
  end
end
