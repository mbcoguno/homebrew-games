require "formula"

class Mame < Formula
  homepage "http://mamedev.org/"
  url "svn://dspnet.fr/mame/trunk", :revision => "29406"
  version "0.153"

  head "svn://dspnet.fr/mame/trunk"

  depends_on :x11
  depends_on "sdl"

  def install
    ENV["MACOSX_USE_LIBSDL"] = "1"
    ENV["INCPATH"] = "-I#{MacOS::X11.include}"
    ENV["PTR64"] = (MacOS.prefer_64_bit? ? "1" : "0")

    system "make", "CC=#{ENV.cc}", "LD=#{ENV.cxx}",
                   "TARGET=mame", "SUBTARGET=mame"

    if MacOS.prefer_64_bit?
      bin.install "mame64" => "mame"
    else
      bin.install "mame"
    end
  end
end
