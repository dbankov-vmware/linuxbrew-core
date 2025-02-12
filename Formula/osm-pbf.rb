class OsmPbf < Formula
  desc "Tools related to PBF (an alternative to XML format)"
  homepage "https://wiki.openstreetmap.org/wiki/PBF_Format"
  url "https://github.com/scrosby/OSM-binary/archive/v1.3.3.tar.gz"
  sha256 "a109f338ce6a8438a8faae4627cd08599d0403b8977c185499de5c17b92d0798"
  license "LGPL-3.0"
  revision 6

  bottle do
    cellar :any_skip_relocation
    sha256 "bb6525bab64e792c04a42dc14f4c282357a1ca810528291c708ad4bb675850ef" => :big_sur
    sha256 "d69b8678764efa4aa16a5eebd85610bdd3ec411655946447d56ca7571f8057db" => :arm64_big_sur
    sha256 "848d0ffd20470d7988d5bb9f4a93e5b58f799646a4c551732c271d4d57b5a1f8" => :catalina
    sha256 "324c716503518b77533db927144643db877d3cf3297234333c056ae45f85d911" => :mojave
    sha256 "1bd74afe54bdcee7e36262e89ae97ce7ed2cbf98f35f4f34400f3de2c0aa2e71" => :x86_64_linux
  end

  depends_on "protobuf"

  def install
    ENV.cxx11

    cd "src" do
      system "make"
      lib.install "libosmpbf.a"
    end
    include.install Dir["include/*"]
  end
end
