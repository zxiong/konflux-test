FROM registry.access.redhat.com/ubi9/ubi-minimal:9.5
FROM quay.io/enterprise-contract/ec-cli:snapshot@sha256:dc7d404596385e7d3c624ec0492524a1d57efe2b0c10cf0ec2158d49c0290a83 AS ec-cli

ENV POLICY_PATH="/project"
# Install required packages
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    microdnf -y --setopt=tsflags=nodocs install \
    clamav \
    clamd \
    clamav-server \
    clamav-update \
    jq \
    tar \
    skopeo \
    && microdnf clean all

# Add clamav user and group
RUN groupadd -r clamav && useradd -r -g clamav clamav

# Create necessary directories
RUN mkdir -p /var/run/clamd.scan /var/log/clamav /var/lib/clamav && \
    chmod -R 0777 /var/run/clamd.scan /var/log/clamav /var/lib/clamav

COPY ./test/utils.sh /utils.sh


# Update ClamAV virus definitions
RUN freshclam

COPY clamav/whitelist.ign2 /var/lib/clamav/whitelist.ign2

COPY policies $POLICY_PATH
COPY test/conftest.sh $POLICY_PATH

# Update clamd config
COPY clamav/scan.conf /etc/clamd.d/scan.conf

# Download and install oc
RUN ARCH="$(uname -m)" && \
    curl -fsSL https://mirror.openshift.com/pub/openshift-v4/"$ARCH"/clients/ocp/stable/openshift-client-linux.tar.gz --output oc.tar.gz && \
    cp oc.tar.gz /usr/bin/oc && \
    tar -xzvf oc.tar.gz -C /usr/bin && \
    rm oc.tar.gz

# Expose scan socket
VOLUME ["/scan"]
VOLUME ["/var/run/clamd.scan"]
