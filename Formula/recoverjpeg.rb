class Recoverjpeg < Formula
  desc "Tool to recover JPEG images from a file system image"
  homepage "https://rfc1149.net/devel/recoverjpeg.html"
  url "https://rfc1149.net/download/recoverjpeg/recoverjpeg-2.6.3.tar.gz"
  sha256 "db996231e3680bfaf8ed77b60e4027c665ec4b271648c71b00b76d8a627f3201"
  license "GPL-2.0"

  livecheck do
    url "https://rfc1149.net/download/recoverjpeg/"
    regex(/href=.*?recoverjpeg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bd56d3048f05834faf5181f4372fe49a8ef3895c291fe0ca2a434a416e305495" => :big_sur
    sha256 "68e1a85a85e46ac4b90b093c36f9e461e6566351518b76891ebd3283b95fa8c2" => :arm64_big_sur
    sha256 "87b3d9adf8b59d91350b7e655a78b68525caaaad0a614c5b7e1b6097d29cf6d9" => :catalina
    sha256 "0f424efc21d5e07c2cdce7a870e28ee1aea42ac8f65f12eb5a845895c49ed958" => :mojave
    sha256 "5366edde2383098f7ee4ac866d0d2ff528efbf63af934dd469c3b8e6739678ed" => :high_sierra
    sha256 "0d505f521d4e36b8f4828e0ea2ec4ae6fe523e5a3527f7efb0ac583683f61dd1" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recoverjpeg -V")
  end
end
