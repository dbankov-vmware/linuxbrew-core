class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https://github.com/xiph/rav1e"
  url "https://github.com/xiph/rav1e/archive/v0.3.5.tar.gz"
  sha256 "ab97209f52695dce740cffb61b0f53b53db5682bfbdd1dfbaf8c93ee36a69a84"
  license "BSD-2-Clause"
  head "https://github.com/xiph/rav1e.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "e6329616d64e121aa50928e2c3af36227cb510a7495abd1f74c134e8bdd25922" => :big_sur
    sha256 "1c974d467b6bf507aad84d05afff9b4622a774dd5fa69e5da873212fdf776ab9" => :arm64_big_sur
    sha256 "5364867cd28ec604b94f9eea1f861be71ef7e0cc99bc0bc67cb1b4abeff15cb8" => :catalina
    sha256 "9dfb724ec01ed6f2b1fdafb924ac883f6d64abaecb8482c904e92c3160553f4d" => :mojave
    sha256 "150034fd2609cf9f4a3d4a9f983a9abcd7c07b0dbab13f0fe3822f6b387ffd02" => :x86_64_linux
  end

  depends_on "cargo-c" => :build
  depends_on "nasm" => :build
  depends_on "rust" => :build

  resource "bus_qcif_7.5fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_7.5fps.y4m"
    sha256 "1f5bfcce0c881567ea31c1eb9ecb1da9f9583fdb7d6bb1c80a8c9acfc6b66f6b"
  end

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "cinstall", "--prefix", prefix
  end

  test do
    resource("bus_qcif_7.5fps.y4m").stage do
      system "#{bin}/rav1e", "--tile-rows=2",
                                   "bus_qcif_7.5fps.y4m",
                                   "--output=bus_qcif_15fps.ivf"
    end
  end
end
