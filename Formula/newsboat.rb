class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.22/newsboat-2.22.tar.xz"
  sha256 "5286f815d9a00b4752a5572d99bbd9bc512b69c06931453faa415968881cd790"
  license "MIT"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    rebuild 1
    sha256 "108d81129186739db42022a6b1ef994573960eb70075bcf345ff6c5aeacd8672" => :big_sur
    sha256 "6a58727530b31f47289e5a9d900e57681f4747f4b3c31a4f89c515e4898b28ee" => :arm64_big_sur
    sha256 "3582b1ceb1fdd4374419b7465d317f1bbd0ac82969ed4a84ef108e4eb4da2ab8" => :catalina
    sha256 "b1395cff81242530b750bdb81b56357b5eb1a4d6dcb47be625961b835f000a1b" => :mojave
    sha256 "885d725e9209b1211e98cd99e284109e27aeee078c10192d755d38e93f1ff458" => :x86_64_linux
  end

  depends_on "asciidoctor" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    gettext = Formula["gettext"]

    ENV["GETTEXT_BIN_DIR"] = gettext.opt_bin.to_s
    ENV["GETTEXT_LIB_DIR"] = gettext.lib.to_s
    ENV["GETTEXT_INCLUDE_DIR"] = gettext.include.to_s
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"urls.txt").write "https://github.com/blog/subscribe"
    assert_match /newsboat - Exported Feeds/m, shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
