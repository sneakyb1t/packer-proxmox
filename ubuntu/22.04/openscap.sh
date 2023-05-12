#!/bin/bash

# Install necessary dependencies
sudo apt-get update
sudo apt-get install -y git cmake make libopenscap8 libxml2-utils ninja-build python3-jinja2 python3-yaml python3-setuptools xsltproc

# Clone the ComplianceAsCode repository
git clone https://github.com/ComplianceAsCode/content.git
cd content/build/

# Make ubuntu profiles and xccdf
cmake ../
make -j4 ubuntu2204

# Execute the remediation using the profile and generate a report
sudo oscap xccdf eval --remediate --profile xccdf_org.ssgproject.content_profile_standard ssg-ubuntu2204-ds-1.2.xml

exit 0
