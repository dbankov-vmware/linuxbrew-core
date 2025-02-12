class Bnfc < Formula
  desc "BNF Converter"
  homepage "https://bnfc.digitalgrammars.com/"
  url "https://github.com/BNFC/bnfc/archive/v2.9.0.tar.gz"
  sha256 "677715b204a047a986656ab76cc850488cfabdb9eb6e3f37663b55d708207238"
  license "BSD-3-Clause"
  head "https://github.com/BNFC/bnfc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a2afc650c8c46d1f5ccde4600a4ea9d6f3de37abfae7165e6b2a4fc7755125a" => :big_sur
    sha256 "3736f6616615c973d2a1cc356fb1aac47e639976408368254232c4149c25a54e" => :catalina
    sha256 "626c0f644bc2fbcaed3439ea01438368df9d86ce68af37328c4f27b975507ce2" => :mojave
    sha256 "1b316e74f6b9e22b9d49d6476f93074348dfbb03778c843c3d0e0077c707592b" => :x86_64_linux
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "sphinx-doc" => :build
  depends_on "antlr" => :test
  depends_on "openjdk" => :test

  uses_from_macos "bison" => :test
  uses_from_macos "flex" => :test

  def install
    cd "source" do
      system "cabal", "v2-update"
      system "cabal", "v2-install", *std_cabal_v2_args
      doc.install "CHANGELOG.md"
      doc.install "src/BNFC.cf" => "BNFC.cf"
    end
    cd "docs" do
      system "make", "text", "man", "SPHINXBUILD=#{Formula["sphinx-doc"].bin/"sphinx-build"}"
      cd "_build" do
        doc.install "text" => "manual"
        man1.install "man/bnfc.1" => "bnfc.1"
      end
    end
    doc.install %w[README.md examples]
  end

  test do
    ENV.prepend_create_path "PATH", testpath/"tools-bin"

    (testpath/"calc.cf").write <<~EOS
      EAdd. Exp  ::= Exp  "+" Exp1 ;
      ESub. Exp  ::= Exp  "-" Exp1 ;
      EMul. Exp1 ::= Exp1 "*" Exp2 ;
      EDiv. Exp1 ::= Exp1 "/" Exp2 ;
      EInt. Exp2 ::= Integer ;
      coercions Exp 2 ;
      entrypoints Exp ;
      comment "(#" "#)" ;
    EOS
    (testpath/"test.calc").write "14 * (# Parsing is fun! #) (3 + 2 / 5 - 8)"
    treespace = if build.head?
      " "
    else
      ""
    end
    check_out = <<~EOS

      Parse Successful!

      [Abstract Syntax]
      (EMul (EInt 14) (ESub (EAdd (EInt 3) (EDiv (EInt 2) (EInt 5))) (EInt 8)))

      [Linearized Tree]
      14 * (3 + 2 / 5 - 8) #{treespace}

    EOS

    mktemp "c-test" do
      system bin/"bnfc", "-m", "-o.", "--c", testpath/"calc.cf"
      system "make", "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}"
      test_out = shell_output("./Testcalc #{testpath}/test.calc")
      assert_equal check_out, test_out
    end

    mktemp "cxx-test" do
      system bin/"bnfc", "-m", "-o.", "--cpp", testpath/"calc.cf"
      system "make", "CC=#{ENV.cxx}", "CCFLAGS=#{ENV.cxxflags}"
      test_out = shell_output("./Testcalc #{testpath}/test.calc")
      assert_equal check_out, test_out
    end

    mktemp "haskell-test" do
      system "cabal", "v2-update"
      system "cabal", "v2-install",
             "--jobs=#{ENV.make_jobs}", "--max-backjumps=100000",
             "--install-method=copy", "--installdir=#{testpath/"tools-bin"}",
             "alex", "happy"
      system bin/"bnfc", "-m", "-o.", "--haskell", "--ghc", "-d", testpath/"calc.cf"
      system "make"
      test_out = shell_output("./Calc/Test #{testpath/"test.calc"}")
      check_out_hs = <<~EOS
        #{testpath/"test.calc"}

        Parse Successful!

        [Abstract Syntax]

        EMul (EInt 14) (ESub (EAdd (EInt 3) (EDiv (EInt 2) (EInt 5))) (EInt 8))

        [Linearized tree]

        14 * (3 + 2 / 5 - 8)
      EOS
      assert_equal check_out_hs, test_out
    end

    mktemp "java-test" do
      ENV.deparallelize # only the Java test needs this
      jdk_dir = Formula["openjdk"].bin
      antlr_bin = Formula["antlr"].bin/"antlr"
      antlr_jar = Dir[Formula["antlr"].prefix/"antlr-*-complete.jar"][0]
      ENV["CLASSPATH"] = ".:#{antlr_jar}"
      system bin/"bnfc", "-m", "-o.", "--java", "--antlr4", testpath/"calc.cf"
      system "make", "JAVAC=#{jdk_dir/"javac"}", "JAVA=#{jdk_dir/"java"}", "LEXER=#{antlr_bin}", "PARSER=#{antlr_bin}"
      test_out = shell_output("#{jdk_dir}/java calc.Test #{testpath}/test.calc")
      space = " "
      check_out_j = <<~EOS

        Parse Succesful!

        [Abstract Syntax]

        (EMul (EInt 14) (ESub (EAdd (EInt 3) (EDiv (EInt 2) (EInt 5))) (EInt 8)))#{space}

        [Linearized Tree]

        14 * (3 + 2 / 5 - 8)
      EOS
      assert_equal check_out_j, test_out
    end
  end
end
