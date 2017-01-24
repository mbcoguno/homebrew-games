class Glulxe < Formula
  desc "Portable VM like the Z-machine"
  homepage "http://www.eblong.com/zarf/glulx/"
  url "http://eblong.com/zarf/glulx/glulxe-054.tar.gz"
  version "0.5.4"
  sha256 "1fc26f8aa31c880dbc7c396ede196c5d2cdff9bdefc6b192f320a96c5ef3376e"
  head "https://github.com/erkyrath/glulxe.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "245660f65870ae1839eebd31e61c89f17654cbe82aa5b41ea2e7eb1ea8f18fae" => :sierra
    sha256 "3dee7d6677f7162c744dc0fa74eeda736905208253b2aeb30b939c52cd563706" => :el_capitan
    sha256 "65d3a2989e1679fc20c589a00328bbc2f31cda12782a9a8dfe12d1c7611b1946" => :yosemite
  end

  option "with-glkterm", "Build with glkterm (without wide character support)"

  depends_on "cheapglk" => [:build, :optional]
  depends_on "glkterm" => [:build, :optional]
  depends_on "glktermw" => :build if build.without?("cheapglk") && build.without?("glkterm")

  def install
    if build.with?("cheapglk") && build.with?("glkterm")
      odie "Options --with-cheapglk and --with-glkterm are mutually exclusive."
    end

    if build.with? "cheapglk"
      glk = Formula["cheapglk"]
    elsif build.with? "glkterm"
      glk = Formula["glkterm"]
    else
      glk = Formula["glktermw"]
    end

    inreplace "Makefile", "GLKINCLUDEDIR = ../cheapglk", "GLKINCLUDEDIR = #{glk.include}"
    inreplace "Makefile", "GLKLIBDIR = ../cheapglk", "GLKLIBDIR = #{glk.lib}"
    inreplace "Makefile", "Make.cheapglk", "Make.#{glk.name}"

    system "make"
    bin.install "glulxe"
  end

  test do
    if build.with? "cheapglk"
      assert shell_output("#{bin}/glulxe").start_with? "Welcome to the Cheap Glk Implementation"
    else
      assert pipe_output("#{bin}/glulxe -v").start_with? "GlkTerm, library version"
    end
  end
end
