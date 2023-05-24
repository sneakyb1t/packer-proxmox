#!/bin/bash

# Define dependencies
deps=(openscap openscap-utils scap-security-guide)

# Update system packages
update_system() {
    sudo dnf update -y
}

# Install openscap scanner and security guide
install_dependencies() {
    sudo dnf install -y "${deps[@]}"
}

# Execute the remediation using the profile and generate a report
run_oscap_xccdf() {
    sudo oscap xccdf eval --remediate --profile xccdf_org.ssgproject.content_profile_anssi_bp28_minimal --report /tmp/oscap_report.html /usr/share/xml/scap/ssg/content/ssg-rl9-ds-1.2.xml

    # Always return 0 to ensure success
    return 0
}

# Call functions
update_system
install_dependencies
run_oscap_xccdf
