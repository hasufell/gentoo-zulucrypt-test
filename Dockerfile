FROM        hasufell/gentoo-amd64-paludis:latest
MAINTAINER  Julian Ospald <hasufell@gentoo.org>

## global USE flags
# see http://paludis.exherbo.org/configuration/use.html for configuration
# see /usr/portage/profiles/use.desc for the list of global USE flags
RUN echo -e "*/* clang \
" \
	>> /etc/paludis/use.conf

# install clang
RUN chgrp paludisbuild /dev/tty && cave resolve sys-devel/clang -x

# more global USE flags
RUN echo -e "*/* qt4 qt3support X \
" \
	>> /etc/paludis/use.conf

## per-package USE flags
# see http://paludis.exherbo.org/configuration/use.html for configuration
# use 'cave show <package>' for a list of package-specific USE flags
RUN mkdir /etc/paludis/use.conf.d/ && \
	echo -e "app-crypt/zuluCrypt gnome gui kde udev \
\nsys-libs/zlib minizip \
\nsys-auth/consolekit policykit \
\nmedia-libs/phonon -vlc \
\napp-crypt/gcr gtk \
" \
	> /etc/paludis/use.conf.d/zulucrypt.conf

## allow these packages from unstable branch
# see http://paludis.exherbo.org/configuration/keywords.html for configuration
# see 'cave show -n <package>' to see which versions are masked by a keyword
RUN mkdir /etc/paludis/keywords.conf.d/ && \
	echo -e "app-crypt/zuluCrypt ~amd64 \
\ndev-libs/libgudev ~amd64 \
" \
	> /etc/paludis/keywords.conf.d/zulucrypt.conf

# install dependencies
RUN chgrp paludisbuild /dev/tty && \
	cave resolve -z \
	dev-libs/libgcrypt:0 \
	sys-fs/cryptsetup \
	app-crypt/libsecret \
	dev-libs/libpwquality \
	dev-qt/qtcore:4 \
	dev-qt/qtgui:4 \
	kde-base/kdelibs:4 \
	kde-apps/kwalletd:4 \
	virtual/udev \
	virtual/pkgconfig \
	-x

# update etc files... hope this doesn't screw up
RUN etc-update --automode -5
