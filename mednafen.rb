class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "http://mednafen.fobby.net/"
  url "http://mednafen.fobby.net/releases/files/mednafen-0.9.39.2.tar.bz2"
  sha256 "b42470b2ddf68ce0747f5b8ba4e1d1c3047fa8c45b8e168da43f3e2461ec34cc"

  bottle do
    sha256 "6e5f8e9773db1b2763d85ba48f35398b18f5a81829112de8c0f284642cc94ec2" => :sierra
    sha256 "f97aa8b4332b031dd41b88d14dee487e5d8ffad19519b228f96b58bf6f937c61" => :el_capitan
    sha256 "c69d3c0532d67644b09bc672e42db21919a48e008f69718ce21019c45c4b127a" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "sdl"
  depends_on "libsndfile"
  depends_on "gettext"

  needs :cxx11

  fails_with :clang do
    build 800
    cause <<-EOS.undent
      LLVM miscompiles some loop code with optimization
      https://llvm.org/bugs/show_bug.cgi?id=15470
      EOS
  end

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mednafen -dump_modules_def M >/dev/null || head -n 1 M").chomp
  end
end
