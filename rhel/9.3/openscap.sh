#!/bin/bash

#Install openscap scanner and security guide
sudo dnf update
sudo dnf install openscap-scanner scap-security-guide

# Execute the remediation using the profile and generate a report
sudo oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_anssi_bp28_minimal \
/usr/share/xml/scap/ssg/content/ssg-rhel9-ds.xml

exit 0
