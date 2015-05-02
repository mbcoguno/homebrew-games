class Mess < Formula
  homepage "http://www.mess.org/"
  url "https://github.com/mamedev/mame/archive/mame0161.tar.gz"
  sha256 "f7db934676e90d0d7f2b678ccf32e580417c754dd33117ec683560956c2130b9"
  version "0.161"

  head "https://github.com/mamedev/mame.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-games"
    cellar :any
    sha256 "a6f944ba99f67ddbe952046f366e22e938752e608e1a681813b8b3cbee373aa1" => :yosemite
    sha256 "7b4d2ec40ce12583951f1cfa31afdc8830fca43a09b666f1780c3e21111d803f" => :mavericks
    sha256 "7fe153d0847d4bafd32fac06321ebdc61bb9e4dddbb0a6cb18fb589c1011436b" => :mountain_lion
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

    system "make", "CC=#{ENV.cc}", "LD=#{ENV.cxx}",
                   "TARGET=mess", "SUBTARGET=mess"

    if MacOS.prefer_64_bit?
      bin.install "mess64" => "mess"
    else
      bin.install "mess"
    end
    man6.install "src/osd/sdl/man/mess.6"
  end

  test do
    system "#{bin}/mess", "-help"
  end
end
