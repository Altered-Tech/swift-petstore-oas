# image used to compile your Swift code
FROM public.ecr.aws/docker/library/swift:6.0.2-amazonlinux2
RUN yum -y install git jq tar zip openssl-devel
