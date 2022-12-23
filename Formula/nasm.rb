class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "https://www.nasm.us/"
  url "https://www.nasm.us/pub/nasm/releasebuilds/2.16.01/nasm-2.16.01.tar.xz"
  sha256 "c77745f4802375efeee2ec5c0ad6b7f037ea9c87c92b149a9637ff099f162558"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.nasm.us/pub/nasm/releasebuilds/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86c9627036e1737daf6833c3d0ae95ecd9e6808fd11c6b4235df0bf6f15c1c7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "204a67941110b735ed0eb101fb4f8913b9706827446987c339f2a6431a888078"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df2356c1b5bc3bfee26ca38cb5576b74363641392b0a20bf84f641fdd1366fa2"
    sha256 cellar: :any_skip_relocation, ventura:        "8c1285c9dfacc1575971e4ed24ce1c7a239a3406e425bfff60daf28d40115b07"
    sha256 cellar: :any_skip_relocation, monterey:       "f0e25e83241434f6a23a6211079d634da7b9f337b5927d98678caf5125a3ce32"
    sha256 cellar: :any_skip_relocation, big_sur:        "094c65f9e94b7857a46b4c20585557f75e9933d00189674dda7c26e8e8299266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23cdf43daa59587b7766525bdb0d722054981bc4f1d57168b4393fbc17037f19"
  end

  head do
    url "https://github.com/netwide-assembler/nasm.git"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xmlto" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "manpages" if build.head?
    system "make", "install"
  end

  test do
    (testpath/"foo.s").write <<~EOS
      mov eax, 0
      mov ebx, 0
      int 0x80
    EOS

    system "#{bin}/nasm", "foo.s"
    code = File.open("foo", "rb") { |f| f.read.unpack("C*") }
    expected = [0x66, 0xb8, 0x00, 0x00, 0x00, 0x00, 0x66, 0xbb,
                0x00, 0x00, 0x00, 0x00, 0xcd, 0x80]
    assert_equal expected, code
  end
end
