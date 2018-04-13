#!/usr/bin/env sh

set -e
set -u

FIREFOX_VERSION="59.0"
GECKODRIVER_VERSION="0.20.0"

install_firefox() {
    echo "Installing Firefox $FIREFOX_VERSION"
}

install_geckodriver() {
    echo "Installing Geckodriver $GECKODRIVER_VERSION"
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
