FROM debian:bookworm

ARG xltui_VERSION
ARG BUILD_VERSION
ARG FULL_VERSION
ARG ARCH
ARG XLTUI_RELEASE

RUN mkdir -p /output/usr/bin
RUN mkdir -p /output/usr/share/doc/xltui
RUN mkdir -p /output/DEBIAN

COPY ${XLTUI_RELEASE}/xltui /output/usr/bin/
RUN chmod 755 /output/usr/bin/xltui
COPY output/DEBIAN/control /output/DEBIAN/
COPY output/DEBIAN/postinst /output/DEBIAN/postinst
RUN chmod 755 /output/DEBIAN/postinst
COPY output/copyright /output/usr/share/doc/xltui/
COPY output/changelog.Debian /output/usr/share/doc/xltui/
COPY output/README.md /output/usr/share/doc/xltui/

RUN sed -i "s/FULL_VERSION/$FULL_VERSION/" /output/usr/share/doc/xltui/changelog.Debian
RUN sed -i "s/xltui_VERSION/$xltui_VERSION/" /output/DEBIAN/control
RUN sed -i "s/BUILD_VERSION/$BUILD_VERSION/" /output/DEBIAN/control
RUN sed -i "s/SUPPORTED_ARCHITECTURES/$ARCH/" /output/DEBIAN/control

RUN dpkg-deb -Zxz --build /output /xltui_${FULL_VERSION}.deb
