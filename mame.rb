require "formula"

class Mame < Formula
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0155.tar.gz"
  sha1 "9f4e92491bf56f2ea76f136daa69dbf88e589b71"
  version "0.155"

  head "https://github.com/mamedev/mame.git"

  depends_on "sdl"

  def install
    ENV["MACOSX_USE_LIBSDL"] = "1"
    ENV["PTR64"] = (MacOS.prefer_64_bit? ? "1" : "0")
    ENV["LTO"] = "1" if ENV.compiler == :clang or ENV.compiler =~ /^gcc-(4\.[6-9])$/

    system "make", "CC=#{ENV.cc}", "LD=#{ENV.cxx}",
                   "TARGET=mame", "SUBTARGET=mame"

    if MacOS.prefer_64_bit?
      bin.install "mame64" => "mame"
    else
      bin.install "mame"
    end
  end
end
