class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://bintray.com/homebrew/mirror/download_file?file_path=patchelf-0.12.tar.gz"
  sha256 "2848beb6bbdfbf4efd12d627bdc315b74e7a5ed94a6a7b01c62641cdf4560e51"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/NixOS/patchelf.git"

  livecheck do
    url :head
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d83931e807f58c62f0b321b9523d16de6602415f0e19b3702d072b4dec382cb6" => :big_sur
    sha256 "d600655f0357e24341513f4688532d920baca6c302ba8be53b4a8b84a9db1bb0" => :arm64_big_sur
    sha256 "344c4459a5b03099308520eb7ef906242bca77f08ac1660ac61b74ccd7871b1c" => :catalina
    sha256 "906cd9171c62947d8133b990bbc15ad7803bb5623f5b72332fa792a01c9634ac" => :mojave
    sha256 "56a0ff9acc9ab6c5d7f53d6f8ecce4878fd8c547a581960519504cf9e9dfac51" => :x86_64_linux
  end

  resource "helloworld" do
    url "http://timelessname.com/elfbin/helloworld.tar.gz"
    sha256 "d8c1e93f13e0b7d8fc13ce75d5b089f4d4cec15dad91d08d94a166822d749459"
  end

  # Fix unsupported overlap of SHT_NOTE and PT_NOTE
  # See https://github.com/NixOS/patchelf/pull/230
  patch do
    url "https://github.com/rmNULL/patchelf/commit/6edec83653ce1b5fc201ff6db93b966394766814.patch?full_index=1"
    sha256 "072eff6c5b33298b423f47ec794c7765a42d58a2050689bb20bf66076afb98ac"
  end

  def install
    on_linux do
      # Fix ld.so path and rpath
      # see https://github.com/Homebrew/linuxbrew-core/pull/20548#issuecomment-672061606
      ENV["HOMEBREW_DYNAMIC_LINKER"] = File.readlink("#{HOMEBREW_PREFIX}/lib/ld.so")
      ENV["HOMEBREW_RPATH_PATHS"] = nil
    end

    system "./configure", "--prefix=#{prefix}",
      "CXXFLAGS=-static-libgcc -static-libstdc++",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules"
    system "make", "install"
  end

  test do
    resource("helloworld").stage do
      assert_equal "/lib/ld-linux.so.2\n", shell_output("#{bin}/patchelf --print-interpreter chello")
      assert_equal "libc.so.6\n", shell_output("#{bin}/patchelf --print-needed chello")
      assert_equal "\n", shell_output("#{bin}/patchelf --print-rpath chello")
      assert_equal "", shell_output("#{bin}/patchelf --set-rpath /usr/local/lib chello")
      assert_equal "/usr/local/lib\n", shell_output("#{bin}/patchelf --print-rpath chello")
    end
  end
end
