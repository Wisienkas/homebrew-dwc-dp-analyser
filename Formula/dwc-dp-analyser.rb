class DwcDpAnalyser < Formula
  desc "Validator/analyser CLI for DwC-DP data packages"
  homepage "https://github.com/gbif/dwc-dp-analyser"
  url "https://github.com/gbif/dwc-dp-analyser/releases/download/dwc-dp-analyser-0.0.9/dwc-dp-analyser-0.0.9.jar"
  sha256 "4df9e0f55246bd652cfebddd139a142dfd70d0b6b66e0d166c9fa5ffe7f205e6"
  license "Apache-2.0"

  # Adjust the openjdk version constraint here if the CLI needs a specific
  # Java release (e.g. "openjdk@21") rather than whatever's latest.
  depends_on "openjdk"

  def install
    libexec.install "dwc-dp-analyser-0.0.9.jar" => "dwc-dp-analyser-cli.jar"
    (bin/"dwc-dp-analyser").write <<~SCRIPT
      #!/bin/bash
      exec "#{formula_opt_bin("openjdk")}/java" --enable-native-access=ALL-UNNAMED -jar "#{libexec}/dwc-dp-analyser-cli.jar" "$@"
    SCRIPT

    # picocli ships a completion generator (AutoComplete) baked into the
    # runner jar already — no extra build step needed. Run it against this
    # same jar so the completion script always matches the version being
    # installed. picocli only emits a bash-style script, so zsh gets a
    # small wrapper that loads bashcompinit and sources it, rather than a
    # native #compdef function.
    system formula_opt_bin("openjdk")/"java", "-cp", libexec/"dwc-dp-analyser-cli.jar",
           "picocli.AutoComplete", "--force", "-n", "dwc-dp-analyser",
           "-o", "dwc-dp-analyser_completion", "org.gbif.dp.cli.Config"
    bash_completion.install "dwc-dp-analyser_completion" => "dwc-dp-analyser"

    (zsh_completion/"_dwc-dp-analyser").write <<~ZSH
      #compdef dwc-dp-analyser
      autoload -U +X bashcompinit && bashcompinit
      # picocli's generated completion script calls compopt, a bash 4+
      # builtin with no equivalent in bashcompinit's zsh emulation — stub
      # it as a no-op so it doesn't spam "command not found" on every tab.
      compopt() { :; }
      source "#{bash_completion}/dwc-dp-analyser"
    ZSH
  end

  test do
    system "#{bin}/dwc-dp-analyser", "--help"
  end
end
