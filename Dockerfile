# Base image for compiling Swift code on Amazon Linux 2
FROM public.ecr.aws/docker/library/swift:6.0.2-amazonlinux2

RUN yum -y install git jq tar zip openssl-devel
