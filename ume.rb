class Ume < Formula
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0157.tar.gz"
  sha1 "cac1ccb4194715be63dd4d4754a575b9e1c11ea3"
  version "0.157"

  head "https://github.com/mamedev/mame.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/games"
    cellar :any
    sha1 "bc3f565fcc3cd4075f286756af4542df4753d1f2" => :yosemite
    sha1 "1a7c7e5cb089562c24df6ca59af7cacc650fb8e5" => :mavericks
    sha1 "b3a2f25c4b0983315440a95914f3fa6213530725" => :mountain_lion
  end

  depends_on "sdl2"

  def install
    ENV["MACOSX_USE_LIBSDL"] = "1"
    ENV["PTR64"] = MacOS.prefer_64_bit? ? "1" : "0"
    ENV["LTO"] = "1" if ENV.compiler == :clang or ENV.compiler =~ /^gcc-(4\.[6-9])$/

    system "make", "CC=#{ENV.cc}", "LD=#{ENV.cxx}", "TARGET=ume"

    if MacOS.prefer_64_bit?
      bin.install "ume64" => "ume"
    else
      bin.install "ume"
    end
  end
end
