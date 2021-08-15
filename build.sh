#! /bin/sh
DIVI_SRC_PATH=$DIVI_SOURCES_PATH/Divi/divi
OPENSSL_SRC_PATH=$DIVI_SOURCES_PATH/openssl
DB_SRC_PATH=$DIVI_SOURCES_PATH/db-4.8.30
INSTALL_DIR=$DIVI_SOURCES_PATH/bin

CPP_FLAGS="-I${DB_SRC_PATH}/build_unix/ -I${OPENSSL_SRC_PATH}/include -I/usr/include" #Location of libdb-4.8
LIBS_DIR="-L${DB_SRC_PATH}/build_unix/.libs -L${OPENSSL_SRC_PATH}" #Location of openssl 1.0.2

options="--disable-tests --without-gui --prefix=$INSTALL_DIR"

do_configure() {
    export CPPFLAGS="$CPP_FLAGS"
    export LDFLAGS="$LIBS_DIR"
    mkdir -p $INSTALL_DIR
    ${DIVI_SRC_PATH}/configure $options
}

do_make() {
        export CPPFLAGS="$CPP_FLAGS"
        export LDFLAGS="$LIBS_DIR"

        # Makes sure our includes come before the default ones in the Bitcoin makefile
        sed -i 's|DEFAULT_INCLUDES = -I\. -I\$(top_builddir)/src/config|DEFAULT_INCLUDES = -I. -I\$(top_builddir)/src/config \$(CPPFLAGS)|' ${DIVI_SRC_PATH}/src/Makefile
        cd ${DIVI_SRC_PATH} && make V=1
}

do_install() {
    cd ${DIVI_SRC_PATH} && make install
}

do_clean() {
    cd ${DIVI_SRC_PATH} && make clean
}

do_distclean() {
    cd ${DIVI_SRC_PATH} && make distclean
}

case $1 in
    configure)
        do_configure
    ;;
    make)
        do_make
    ;;
    install)
        do_install
    ;;
    clean)
        do_clean
    ;;
    distclean)
        do_distclean
    ;;
    rebuild)
        do_clean
        do_distclean
        do_configure
        do_make
    ;;
    *)
        echo "Unknown target $1"
        exit 1
    ;;
esac
