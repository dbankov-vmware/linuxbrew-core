class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated every 50 releases on multiples of 50
  url "https://github.com/vim/vim/archive/v8.2.2250.tar.gz"
  sha256 "be1de89b4e41d17a4f27bb70210e9e7d334b80a8f488659617d0742e0cd1bbbd"
  license "Vim"
  revision 1
  head "https://github.com/vim/vim.git"

  bottle do
    sha256 "3606b6328f2fa6440c47793e37c8e243833efd836d5a57a0a6788fb703ac2696" => :big_sur
    sha256 "d95b0d7b51aacbdb476d43919750f7d124e669a616be60b20917e299f90fc042" => :arm64_big_sur
    sha256 "764e98ea72aea88b0f644ec2432c5ed883286e596cd7e5442c1d31a79a569208" => :catalina
    sha256 "0cad1117d350e630069c47b00d9f8903a2daf0aaf9560b31b92a8d0db1c6911c" => :mojave
    sha256 "e2487cefff7af9c8fbb8ae08ab5ed14bc0e53f7e91c923bbbd059ea3036a5c8c" => :x86_64_linux
  end

  depends_on "gettext"
  depends_on "lua"
  depends_on "perl"
  depends_on "python@3.9"
  depends_on "ruby"

  uses_from_macos "ncurses"

  conflicts_with "ex-vi",
    because: "vim and ex-vi both install bin/ex and bin/view"

  conflicts_with "macvim",
    because: "vim and macvim both install vi* binaries"

  # Fix vimscript issue that was fixed upstream in 8.2.2251 (just missed our cutoff of every 50 releases)
  # Remove the next time vim is updated.
  patch do
    url "https://github.com/vim/vim/commit/a04d447d3aaddb5b978dd9a0e0186007fde8e09e.patch?full_index=1"
    sha256 "ddc00f61dc75e3875ea490c56b9cf843f20292844bc34ad434c566ab30e2335a"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

    # https://github.com/Homebrew/homebrew-core/pull/1046
    ENV.delete("SDKROOT")

    # vim doesn't require any Python package, unset PYTHONPATH.
    ENV.delete("PYTHONPATH")

    # We specify HOMEBREW_PREFIX as the prefix to make vim look in the
    # the right place (HOMEBREW_PREFIX/share/vim/{vimrc,vimfiles}) for
    # system vimscript files. We specify the normal installation prefix
    # when calling "make install".
    # Homebrew will use the first suitable Perl & Ruby in your PATH if you
    # build from source. Please don't attempt to hardcode either.
    system "./configure", "--prefix=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--with-compiledby=Homebrew",
                          "--enable-cscope",
                          "--enable-terminal",
                          "--enable-perlinterp",
                          "--enable-rubyinterp",
                          "--enable-python3interp",
                          "--enable-gui=no",
                          "--without-x",
                          "--enable-luainterp",
                          "--with-lua-prefix=#{Formula["lua"].opt_prefix}"
    system "make"
    # Parallel install could miss some symlinks
    # https://github.com/vim/vim/issues/1031
    ENV.deparallelize
    # If stripping the binaries is enabled, vim will segfault with
    # statically-linked interpreters like ruby
    # https://github.com/vim/vim/issues/114
    system "make", "install", "prefix=#{prefix}", "STRIP=#{which "true"}"
    bin.install_symlink "vim" => "vi"
  end

  test do
    (testpath/"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin/"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", File.read("test.txt").chomp
    assert_match "+gettext", shell_output("#{bin}/vim --version")
  end
end
