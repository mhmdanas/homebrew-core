class Tomsfastmath < Formula
  desc "Fast large integer arithmetic library written in portable ISO C"
  homepage "https://www.libtom.net/TomsFastMath/"
  url "https://github.com/libtom/tomsfastmath/releases/download/v0.13.1/tfm-0.13.1.tar.xz"
  sha256 "47c97a1ada3ccc9fcbd2a8a922d5859a84b4ba53778c84c1d509c1a955ac1738"
  # The development branch is licensed under the Unlicense now, but a release
  # with the new license hasn't been made yet.
  license any_of: [:public_domain, "WTFPL"]

  # Fixes some issues in `makefile.shared`, remove on next release.
  depends_on "libtool" => :build

  patch :DATA

  def install
    system "make", "-f", "makefile.shared", "install", "LT=glibtool", "LIBPATH=#{lib}", "INCPATH=#{include}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tfm.h>
      #include <assert.h>

      int main() {
        fp_int a;
        fp_set(&a, 43);

        fp_int b;
        fp_set(&b, 78);

        fp_int calculated_result;
        fp_mul(&a, &b, &calculated_result);

        fp_int expected_result;
        fp_set(&expected_result, 3354);

        assert(fp_cmp(&calculated_result, &expected_result) == FP_EQ);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltfm", "-o", "test"
    system "./test"
  end
end
__END__
--- a/makefile.shared	2022-05-13 15:07:18.000000000 +0000
+++ b/makefile.shared	2022-05-13 15:09:31.000000000 +0000
@@ -89,13 +89,13 @@
 	$(LTCOMPILE) $(CFLAGS) $(LDFLAGS) -o $@ -c $<
 
 $(LIBNAME): $(OBJECTS)
-	libtool --mode=link --tag=CC $(CC) $(CFLAGS) $(LDFLAGS) `find . -type f | LC_ALL=C sort | grep "[.]lo" | xargs` -o $(LIBNAME) -rpath $(LIBPATH) -version-info $(VERSION) -export-symbols libtfm.symbols
+	$(LT) --mode=link --tag=CC $(CC) $(CFLAGS) $(LDFLAGS) `find . -type f | LC_ALL=C sort | grep "[.]lo" | xargs` -o $(LIBNAME) -rpath $(LIBPATH) -version-info $(VERSION) -export-symbols libtfm.symbols
 
 install: $(LIBNAME)
-	install -d -g $(GROUP) -o $(USER) $(DESTDIR)$(LIBPATH)
-	libtool --mode=install install -c $(LIBNAME) $(DESTDIR)$(LIBPATH)/$(LIBNAME)
-	install -d -g $(GROUP) -o $(USER) $(DESTDIR)$(INCPATH)
-	install -g $(GROUP) -o $(USER) $(HEADERS_PUB) $(DESTDIR)$(INCPATH)
+	install -d $(DESTDIR)$(LIBPATH)
+	$(LT) --mode=install install -c $(LIBNAME) $(DESTDIR)$(LIBPATH)/$(LIBNAME)
+	install -d $(DESTDIR)$(INCPATH)
+	install $(HEADERS_PUB) $(DESTDIR)$(INCPATH)
 
 HEADER_FILES=$(notdir $(HEADERS_PUB))
 uninstall:
