class Plzip < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/plzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.8.tar.gz"
  sha256 "edafae3c15142ac0ebd84c2231ff81da4f68db58359a737e750f2780686c3612"
  license "GPL-2.0"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/plzip/"
    regex(/href=.*?plzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2298b8c622169d674adc1f9cbdd8099e9affff9cc4bc5b1365823b42954c4d02" => :big_sur
    sha256 "fc19ad8f6b927a88fed750b5df94fa7ad55baa09aff72835031317ede87483f7" => :arm64_big_sur
    sha256 "9cae6af29d979ef1e9ed1869f8a5013fe188f6c65ca138bed9a5f76ce178c881" => :catalina
    sha256 "3e266c42c66babd4fbdfe82645ab876fc7224846e94b26a39183c57404e17c35" => :mojave
    sha256 "0a5df85c11e9afb266709a907980424cd60f1d1fd3adda71e8b0f9939ddf72a7" => :high_sierra
    sha256 "c26a4b45c09173a4cb8ab2a56d2c5bb9018e16332e637d4d617bfcd75f90c0ad" => :sierra
    sha256 "814604d1403c40b36e714199c236f910105e87f4baa2646ee5746531a1456afe" => :x86_64_linux
  end

  depends_on "lzlib"

  # error: unknown type name 'pthread_mutex_t' and 'pthread_cond_t'
  # Reported 24 Nov 2017 to lzip-bug AT nongnu DOT org
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/68e2af8/plzip/pthread.diff"
    sha256 "9e6653248ade666922b353b362eda6383af73c85cd93936c70bd8257e027f2b1"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    text = "Hello Homebrew!"
    compressed = pipe_output("#{bin}/plzip -c", text)
    assert_equal text, pipe_output("#{bin}/plzip -d", compressed)
  end
end
