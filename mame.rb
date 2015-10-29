class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0167.tar.gz"
  version "0.167"
  sha256 "fbb7fb8c98c2a26fed44441732d5c64c7c9c7417288e6b71a5cd0cea433e5064"
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "935a1244ad4f0fd4fb504f4672bc9365ac8466c45cba8330be9e7daaf4756ad9" => :el_capitan
    sha256 "950c9936f4a4216df7b73824dc16ba63e502f5e52d5475aa5380e4c5c8a4852e" => :yosemite
    sha256 "63e0f849e627c1070c34d683a3e7d522291e03358dc237bf30a7316520580740" => :mavericks
  end

  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "sdl2"
  depends_on "jpeg"
  depends_on "flac"
  depends_on "sqlite"
  depends_on "portmidi"

  def install
    inreplace "scripts/src/main.lua", /(targetsuffix) "\w+"/, '\1 ""'
    system "make", "PTR64=#{MacOS.prefer_64_bit? ? 1 : 0}", # for old Macs
                   "MACOSX_USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=", # brewed version not picked up
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_JPEG=1",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_LUA=", # lua53 not available yet
                   "USE_SYSETM_LIB_SQLITE3=1",
                   "USE_SYSTEM_LIB_PORTMIDI=1",
                   "USE_SYSTEM_LIB_PORTAUDIO=1" # currently not used yet
    bin.install "mame"
    man6.install "src/osd/sdl/man/mame.6"
    doc.install Dir["docs/*"]
    pkgshare.install %w[artwork hash keymaps samples]
    (pkgshare/"shader").install Dir["src/osd/modules/opengl/shader/*.[vf]sh"]
  end

  test do
    assert shell_output("#{bin}/mame -help").start_with? "M.A.M.E. v#{version}"
    system "#{bin}/mame", "-validate"
  end
end
