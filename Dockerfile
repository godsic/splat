FROM quay.io/centos/centos:stream9-minimal 

RUN curl https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm --output epel-release && \
    rpm -i epel-release && \
    microdnf --enablerepo=epel --enablerepo=crb --setopt=install_weak_deps=0 --best --nodocs -y install cmake g++ bzip2-devel libpng-devel gdal-devel libjpeg-turbo-devel zlib-devel git python3.12

WORKDIR /root/
RUN git clone https://github.com/godsic/splat.git && \
    mkdir -p /root/splat/build && \
    sed -i 's/add_subdirectory(docs)//g' /root/splat/CMakeLists.txt

WORKDIR /root/splat/build
RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr ../ && \
    make install

WORKDIR /root/
RUN microdnf remove -y cmake-data cmake-rpm-macros cmake gcc\* cpp bzip2-devel libpng-devel gdal-devel libjpeg-turbo-devel zlib-devel perl-Git git\* openssh\* util-linux\* perl\* kernel\* binutils\* \*-devel && \
    microdnf clean all && \
    rm -fR splat epel-release