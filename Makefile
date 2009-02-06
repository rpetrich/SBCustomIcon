VERSION = 1.0
PROD = SBCustomIcon

OBJS = hook.o SBApplication.o UIApplication.o
DISTDIR = $(PROD)-deb
INSTALLDIR = /Library/MobileSubstrate/DynamicLibraries

CXX = arm-apple-darwin9-g++
LD = $(CC)
LDID = ldid
IPHONE = iphone

CFLAGS = -Wall -Werror -march=armv6 -mcpu=arm1176jzf-s \
         -fobjc-call-cxx-cdtors -fobjc-exceptions -ObjC++ \
         -DVERSION='"$(VERSION)"'

LDFLAGS = -framework Foundation \
          -framework UIKit \
          -framework CoreFoundation \
          -multiply_defined suppress \
          -lsubstrate -lobjc \
          -dynamiclib -init _SBCustomIconInitialize

all: $(PROD).dylib

$(PROD).dylib: $(OBJS)
	$(CXX) $(CFLAGS) $(LDFLAGS) -o $@ $^
	$(LDID) -S $(PROD).dylib

%.o: src/%.mm
	$(CXX) -c $(CFLAGS) $< -o $@

%.o: src/%.m
	$(CXX) -c $(CFLAGS) $< -o $@

clean-all: clean distclean

clean:
	rm -rf $(OBJS) $(PROD).dylib

distclean:
	rm -rf $(PROD).deb $(DISTDIR)

install: $(PROD).dylib
	scp $(PROD).dylib root@$(IPHONE):$(INSTALLDIR)/.
	scp dist/hook.plist root@$(IPHONE):$(INSTALLDIR)/$(PROD).plist

reinstall: $(PROD).dylib
	ssh root@$(IPHONE) "rm -f $(INSTALLDIR)/$(PROD).dylib"
	scp $(PROD).dylib root@$(IPHONE):$(INSTALLDIR)/.

reinstall-all: $(PROD).dylib
	ssh root@$(IPHONE) "rm -f $(INSTALLDIR)/$(PROD).dylib"
	scp $(PROD).dylib root@$(IPHONE):$(INSTALLDIR)/.
	scp dist/hook.plist root@$(IPHONE):$(INSTALLDIR)/$(PROD).plist

uninstall:
	ssh root@$(IPHONE) rm $(INSTALLDIR)/$(PROD).dylib $(INSTALLDIR)/$(PROD).plist

dist: $(PROD).deb
	
$(PROD).deb: $(PROD).dylib
# make directory structure
	mkdir -p $(DISTDIR)$(INSTALLDIR)
	mkdir -p $(DISTDIR)/DEBIAN
# copy hook and hook's plist
	cp dist/hook.plist $(DISTDIR)$(INSTALLDIR)/$(PROD).plist
	cp $(PROD).dylib $(DISTDIR)$(INSTALLDIR)/
# create apt control file
	sed 's/\$$VERSION/$(VERSION)/g' dist/control > $(DISTDIR)/DEBIAN/control
	echo Installed-Size: `du -ck $(DISTDIR) | tail -1 | cut -f 1` >> $(DISTDIR)/DEBIAN/control
# package
	COPYFILE_DISABLE="" COPY_EXTENDED_ATTRIBUTES_DISABLE="" dpkg-deb -b $(DISTDIR) $(PROD).deb
