#!/usr/bin/env sh

set -e
set -u

FIREFOX_VERSION="59.0"
GECKODRIVER_VERSION="0.20.0"

install_firefox() {
    echo "Installing Firefox $FIREFOX_VERSION"

    FIREFOX_DOWNLOAD_URL=https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 \
        && rm -rf /opt/firefox \
        && curl -sSL $FIREFOX_DOWNLOAD_URL -o /tmp/firefox.tar.bz2 \
        && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
        && rm /tmp/firefox.tar.bz2 \
        && mv /opt/firefox /opt/firefox-$FIREFOX_VERSION \
        && ln -fs /opt/firefox-$FIREFOX_VERSION/firefox /usr/bin/firefox

    if [ $? != 0 ]; then
        echo "Error installing Firefox $FIREFOX_VERSION" >&2
        exit 1
    fi
}

install_geckodriver() {
    echo "Installing Geckodriver $GECKODRIVER_VERSION"

    GECKODRIVER_DOWNLOAD_URL=https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz \
        && rm -rf /opt/geckodriver \
        && curl -sSL $GECKODRIVER_DOWNLOAD_URL -o /tmp/geckodriver.tar.gz \
        && tar -C /opt -zxf /tmp/geckodriver.tar.gz \
        && rm /tmp/geckodriver.tar.gz \
        && mv /opt/geckodriver /opt/geckodriver-$GECKODRIVER_VERSION \
        && chmod 755 /opt/geckodriver-$GECKODRIVER_VERSION \
        && ln -fs /opt/geckodriver-$GECKODRIVER_VERSION /usr/bin/geckodriver

    if [ $? != 0 ]; then
        echo "Error installing Geckodriver $GECKODRIVER_VERSION" >&2
        exit 1
    fi
}

main() {
    if [ ! "$(uname -s)" = "Linux" ]; then
        echo "install-firefox only supports linux at this point" >&2
        exit 1
    fi

    if [ ! "$(uname -m)" = "x86_64" ]; then
        echo "install-firefox only supports x86_64 architecture at this point" >&2
        exit 1
    fi

    while test $# -gt 0; do
        case "$1" in
        -f|--firefox)
            shift
            if [ $# -gt 0 ]; then
                export FIREFOX_VERSION="$1"
                shift
                continue
            fi
            echo "Require value for FIREFOX_VERSION" >&2
            exit 1
            ;;
        -g|--geckodriver)
            shift
            if [ $# -gt 0 ]; then
                export GECKODRIVER_VERSION="$1"
                shift
                continue
            fi
            echo "Require value for GECKODRIVER_VERSION" >&2
            exit 1
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            ;;
        esac
    done

    install_firefox
    install_geckodriver
}

usage() {
    cat 1>&2 <<EOF
install-firefox 0.1.0
Installer for Firefox and Geckodriver

USAGE:
    install-firefox [FLAGS] [OPTIONS]

FLAGS:
    -h, --help    Show help message

OPTIONS:
        --firefox [VERSION]        Firefox version to install
        --geckodriver [VERSION]    Geckodriver version to install
EOF
}


main "$@" || exit 1
