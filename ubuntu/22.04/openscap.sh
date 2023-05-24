#!/bin/bash

# Global variables
content_dir="content"

# Define dependencies
deps=(git cmake make libopenscap8 libxml2-utils ninja-build python3-jinja2 python3-yaml python3-setuptools xsltproc)


# Install necessary dependencies
install_dependencies() {
    sudo apt-get update
    sudo apt-get install -y "${deps[@]}"
}

# Clone the ComplianceAsCode repository
clone_complianceascode() {
    git clone https://github.com/ComplianceAsCode/content.git
    cd $content_dir/build/
}

# Make ubuntu profiles and xccdf
make_ubuntu_profiles() {
    cmake ../
    make -j4 ubuntu2204
}

# Execute the remediation using the profile and generate a report
run_oscap_xccdf() {
    sudo oscap xccdf eval --remediate --profile xccdf_org.ssgproject.content_profile_standard --report /tmp/oscap_report.html ssg-ubuntu2204-ds-1.2.xml

    # Always return 0 to ensure success
    return 0
}

install_dependencies
clone_complianceascode
make_ubuntu_profiles
run_oscap_xccdf

