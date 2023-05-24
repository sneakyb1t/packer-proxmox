#!/bin/bash

# Global variables
openscap_version=1.3.7
python_version=3.11.1
tmp_dir="/tmp"

# Define dependencies
build_deps=(build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev)
openscap_deps=(wget cmake libdbus-1-dev libdbus-glib-1-dev libcurl4-openssl-dev libgcrypt20-dev libselinux1-dev libxslt1-dev libgconf2-dev libacl1-dev libblkid-dev libcap-dev libxml2-dev libldap2-dev libpcre3-dev python-dev swig libxml-parser-perl libxml-xpath-perl libperl-dev libbz2-dev librpm-dev g++ libapt-pkg-dev libyaml-dev libxmlsec1-dev libxmlsec1-openssl)
complianceascode_deps=(git make libxml2-utils python3-jinja2 python3-yaml python3-setuptools xsltproc)

install_python() {
    # Install Python
    cd $tmp_dir
    wget https://www.python.org/ftp/python/${python_version}/Python-${python_version}.tgz
    tar -xzvf Python-${python_version}.tgz
    cd Python-${python_version}/

    # Install build tools for Python
    sudo apt update
    sudo apt install -y "${build_deps[@]}"
    ./configure --enable-optimizations
    make -j "$(nproc)"
    sudo make altinstall
    sudo ln -sf /usr/local/bin/python${python_version} /usr/local/bin/python
}

install_openscap() {
    # Install OpenSCAP dependencies
    sudo apt-get update
    sudo apt-get install -y "${openscap_deps[@]}"

    # Build OpenSCAP from source code
    cd $tmp_dir
    wget https://github.com/OpenSCAP/openscap/releases/download/${openscap_version}/openscap-${openscap_version}.tar.gz
    tar -xzpf openscap-${openscap_version}.tar.gz
    cd openscap-${openscap_version}
    mkdir -p build
    cd build/
    cmake ../
    make
    make install
}

install_complianceascode() {
    # Install ComplianceAsCode dependencies
    sudo apt-get install -y "${complianceascode_deps[@]}"

    # Clone the ComplianceAsCode repository
    cd $tmp_dir
    git clone https://github.com/ComplianceAsCode/content.git
    cd content/build/

    # Make Debian 11 profiles and xccdf
    cmake ../
    make -j4 debian11
}

run_oscap_xccdf() {
    # Execute the remediation using standard profile
    sudo oscap xccdf eval --remediate --profile xccdf_org.ssgproject.content_profile_standard --report /tmp/oscap_report.html ssg-debian11-ds-1.2.xml

    # Always return 0 to ensure success
    return 0
}

cleanup() {
    # Cleanup
    # Remove installed packages except Python
    sudo apt-mark hold sudo
    sudo apt-get purge -y "${build_deps[@]}" "${openscap_deps[@]}" "${complianceascode_deps[@]}"
    sudo apt-get autoremove -y
    sudo apt-get autoclean

    # Remove temporary folders
    sudo rm -rf $tmp_dir/Python-${python_version}*
    sudo rm -rf $tmp_dir/openscap-${openscap_version}*
    sudo rm -rf $tmp_dir/content
}

# Call functions
install_python
install_openscap
install_complianceascode
run_oscap_xccdf
cleanup
