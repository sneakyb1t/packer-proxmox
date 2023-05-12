#!/bin/bash

# Install necessary dependencies
sudo yum install -y  cmake make openscap-utils openscap-scanner python3 python3-pyyaml python3-jinja2 python3-setuptools

# Clone the ComplianceAsCode repository
git clone https://github.com/ComplianceAsCode/content.git
cd content/build/

# Make ubuntu profiles and xccdf
cmake ../
make -j4 rocky9

# Execute the remediation using the profile and generate a report
sudo oscap xccdf eval --remediate --profile xccdf_org.ssgproject.content_profile_standard ssg-rocky9.xml --report /tmp/openscap_ubuntu2204_report.html
