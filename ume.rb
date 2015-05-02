class Ume < Formula
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0161.tar.gz"
  sha256 "f7db934676e90d0d7f2b678ccf32e580417c754dd33117ec683560956c2130b9"
  version "0.161"

  head "https://github.com/mamedev/mame.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-games"
    cellar :any
    sha1 "2bf12725b28257832a65c3df2ccab4518511b30c" => :yosemite
    sha1 "4344cafb83d3c51185df99588353d39133198dc0" => :mavericks
    sha1 "512b83dd3e8001e622efca1c8d080e23b028c28d" => :mountain_lion
  end

  depends_on "sdl2"

  # Use OpenGL extensions for non-framework SDL 2 environment.
  # Upstream: <https://github.com/mamedev/mame/pull/170>
  patch do
    url "https://github.com/mbcoguno/mame/commit/05f71a27f9.diff"
    sha256 "d7c82d97cc9367226b44bcd174b98ce56f96b034f12a0af7cae1da76065a947c"
  end

  def install
    ENV["MACOSX_USE_LIBSDL"] = "1"
    ENV["PTR64"] = MacOS.prefer_64_bit? ? "1" : "0"

    system "make", "CC=#{ENV.cc}", "LD=#{ENV.cxx}", "TARGET=ume"

    if MacOS.prefer_64_bit?
      bin.install "ume64" => "ume"
    else
      bin.install "ume"
    end
  end

  test do
    system "#{bin}/ume", "-help"
  end
end
