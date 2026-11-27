# Homebrew formula for a personal tap (D358), e.g. the repository
# <owner>/homebrew-hotdocs, installed with
#
#   brew install <owner>/hotdocs/hotdocs
#
# It installs the downloaded sdist, whose checksum is pinned below, and its
# pinned dependencies from PyPI into a private virtual environment.
# Dependencies are installed from wheels, not built from source (DuckDB's
# source build is impractical), so this formula suits a personal tap, not
# homebrew-core. After each PyPI release, set `url` and
# `sha256` to that release's sdist (`shasum -a 256 hotdocs-<v>.tar.gz`).
class Hotdocs < Formula
  desc "Spec-driven agentic development: specs in, verified code out"
  homepage "https://github.com/liam-selfors/hotdocs"
  url "https://files.pythonhosted.org/packages/c5/33/e8daecf98b7126e18f16ee0c11d200203693021aa1efa25e8bee1f0c7325/hotdocs-0.1.0a2.tar.gz"
  sha256 "0be2ed2df556f5cd8b358d9ffc3a439cc3f6bb6cc9740851c36eb45c673c55aa"
  license "Apache-2.0"

  depends_on "python@3.14"
  depends_on "node" => :recommended # only for components with javascript assets

  def install
    python = formula_opt_bin("python@3.14")/"python3.14"
    system python, "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--no-cache-dir", buildpath
    bin.install_symlink libexec/"bin/hotdocs"
  end

  test do
    system "git", "init", "-q", "-b", "main"
    # --yes takes the first available provider; with none, init says so and
    # carries on, so the test needs no model provider.
    system bin/"hotdocs", "init", "--example", "--yes"
    assert_match "0 hard failure(s)", shell_output("#{bin}/hotdocs lint")
  end
end
