#!/bin/bash

#Install openscap scanner and security guide
sudo dnf update -y
sudo dnf install -y openscap openscap-utils scap-security-guide

# Execute the remediation using the profile and generate a report
sudo oscap xccdf eval --remediate --profile xccdf_org.ssgproject.content_profile_anssi_bp28_minimal \
/usr/share/xml/scap/ssg/content/ssg-rl9-ds-1.2.xml

exit 0
