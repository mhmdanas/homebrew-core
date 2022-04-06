class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v4.1.1/qalculate-gtk-4.1.1.tar.gz"
  sha256 "8bf7dee899ba480e4f82c70cb374ed1229da28f7d3b9b475a089630a8eeb32e5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "815aaa872c769fe92a4ebcdc05302eded0719cc31391426854023160bb587f94"
    sha256 arm64_big_sur:  "d7d42d9c0cabcb83b8ca07d450bc97065bb16646be7a5339c59cc114afe23947"
    sha256 monterey:       "5e56e60f9d551607f55257e0b2cc6a07b03bfeaaf4acf18949597dc63eba35fa"
    sha256 big_sur:        "49b4f3146e8c166880801fbe2b5962df83c79ff0b6cbe87ec59c23c8fe4e15be"
    sha256 catalina:       "81d643833a88969558f9417cfcf230fa4b83c23be9d2028da02af2395235c093"
    sha256 x86_64_linux:   "daf946c8961ba17b6b772bc180b92595e2696a73308e1d79b10166d6118bfb80"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "libqalculate"

  uses_from_macos "perl" => :build

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalculate-gtk", "-v"
  end
end
