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
      exec "#{Formula["openjdk"].opt_bin}/java" --enable-native-access=ALL-UNNAMED -jar "#{libexec}/dwc-dp-analyser-cli.jar" "$@"
    SCRIPT

    # picocli ships a completion generator (AutoComplete) baked into the
    # runner jar already — no extra build step needed. Run it against this
    # same jar so the completion script always matches the version being
    # installed. picocli only emits a bash-style script, so zsh gets a
    # small wrapper that loads bashcompinit and sources it, rather than a
    # native #compdef function.
    system Formula["openjdk"].opt_bin/"java", "-cp", libexec/"dwc-dp-analyser-cli.jar",
           "picocli.AutoComplete", "--force", "-n", "dwc-dp-analyser",
           "-o", "dwc-dp-analyser_completion", "org.gbif.dp.cli.Config"
    bash_completion.install "dwc-dp-analyser_completion" => "dwc-dp-analyser"

    (zsh_completion/"_dwc-dp-analyser").write <<~ZSH
      #compdef dwc-dp-analyser
      autoload -U +X bashcompinit && bashcompinit
      source "#{bash_completion}/dwc-dp-analyser"
    ZSH
  end

  test do
    system "#{bin}/dwc-dp-analyser", "--help"
  end
end
