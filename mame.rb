class Mame < Formula
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0162.tar.gz"
  sha256 "97b5154177cf7fa862f72be0a5a1241d4560a44bc00c2ac1785f0ae706deb899"
  version "0.162"

  head "https://github.com/mamedev/mame.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-games"
    cellar :any
    sha256 "2fd889ac6550c7a626ef4980acdc4ae06813e7c5be925839cb8e7ad5b8ecd13d" => :yosemite
    sha256 "3e1e8361d872e70cf46e8e58f35bb96642bdab45e9697bb69c14facafebbcfa9" => :mavericks
    sha256 "e3c19957e58f500fdc6aa7983a59495534f79a1f6772ea0144a837f30f803f14" => :mountain_lion
  end

  depends_on "sdl2"

  def install
    ENV["MACOSX_USE_LIBSDL"] = "1"
    ENV["PTR64"] = (MacOS.prefer_64_bit? ? "1" : "0")

    system "make", "CC=#{ENV.cc}", "LD=#{ENV.cxx}",
                   "TARGET=mame", "SUBTARGET=mame"

    if MacOS.prefer_64_bit?
      bin.install "mame64" => "mame"
    else
      bin.install "mame"
    end
    man6.install "src/osd/sdl/man/mame.6"
  end

  test do
    system "#{bin}/mame", "-help"
  end
end
