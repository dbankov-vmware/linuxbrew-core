# Nethack the way God intended it to be played: from a terminal.

class Nethack < Formula
  desc "Single-player roguelike video game"
  homepage "https://www.nethack.org/"
  url "https://www.nethack.org/download/3.6.6/nethack-366-src.tgz"
  version "3.6.6"
  sha256 "cfde0c3ab6dd7c22ae82e1e5a59ab80152304eb23fb06e3129439271e5643ed2"
  license "NGPL"
  head "https://github.com/NetHack/NetHack.git"

  livecheck do
    url :head
    regex(/^NetHack[._-]v?(\d+(?:\.\d+)+)_Released?$/i)
  end

  bottle do
    sha256 "d4db0fc0aa73dd80ef2e32a521db2f67d597606217713dd5644adec265a7cab5" => :big_sur
    sha256 "9d9c5a416f9d3c7770a7d6243d504f05d9fbff7bba1340b39f58ba1b61438cd5" => :arm64_big_sur
    sha256 "69418bfcba43b656118140a7e50992772567c4c2ab4827ce0af343892a149945" => :catalina
    sha256 "4d186d190dcab9cc719a3868aa73a6c311407f8c1510e1d3bfd185a8070177bc" => :mojave
    sha256 "6b6b5eb3571c69d31ac0c88f42acae3cea5f42ec513bafd03960db8c9f994177" => :high_sierra
    sha256 "7b62ff8bc77a49942b76eb1e5bee8ebcc290a748d80079e492ef5008ffc94ae0" => :x86_64_linux
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  def install
    ENV.deparallelize

    # Fixes https://github.com/NetHack/NetHack/issues/274
    ENV.O0

    cd "sys/unix" do
      hintfile = if MacOS.version >= :mojave
        "macosx10.14"
      else
        "macosx10.10"
      end

      # Enable wizard mode for all users
      inreplace "sysconf", /^WIZARDS=.*/, "WIZARDS=*"

      # Enable curses interface
      # Setting VAR_PLAYGROUND preserves saves across upgrades
      inreplace "hints/#{hintfile}" do |s|
        s.change_make_var! "HACKDIR", libexec
        s.change_make_var! "CHOWN", "true"
        s.change_make_var! "CHGRP", "true"
        s.gsub! "#WANT_WIN_CURSES=1",
                "WANT_WIN_CURSES=1\nCFLAGS+=-DVAR_PLAYGROUND='\"#{HOMEBREW_PREFIX}/share/nethack\"'"
      end

      system "sh", "setup.sh", "hints/#{hintfile}"
    end

    system "make", "install"
    bin.install_symlink libexec/"nethack"
    man6.install "doc/nethack.6"
  end

  def post_install
    # These need to exist (even if empty) otherwise nethack won't start
    savedir = HOMEBREW_PREFIX/"share/nethack"
    mkdir_p savedir
    cd savedir do
      %w[xlogfile logfile perm record].each do |f|
        touch f
      end
      mkdir_p "save"
      touch "save/.keepme" # preserve on `brew cleanup`
    end
    # Set group-writeable for multiuser installs
    chmod "g+w", savedir
    chmod "g+w", savedir/"save"
  end

  test do
    system "#{bin}/nethack", "-s"
    assert_match (HOMEBREW_PREFIX/"share/nethack").to_s,
                 shell_output("#{bin}/nethack --showpaths")
  end
end
