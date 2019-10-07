FROM ubuntu:eoan

RUN apt-get update && apt-get -qy install \
    build-essential git automake autoconf libtool wget strace

#RUN wget -N https://releases.linaro.org/archive/15.02/components/toolchain/binaries/arm-linux-gnueabihf/gcc-linaro-4.9-2015.02-3-x86_64_arm-linux-gnueabihf.tar.xz
#RUN tar -xf gcc-linaro-4.9-2015.02-3-x86_64_arm-linux-gnueabihf.tar.xz
#ENV PATH="${PWD}/gcc-linaro-4.9-2015.02-3-x86_64_arm-linux-gnueabihf/bin:${PATH}"

RUN wget https://releases.linaro.org/components/toolchain/binaries/7.4-2019.02/arm-linux-gnueabihf/gcc-linaro-7.4.1-2019.02-x86_64_arm-linux-gnueabihf.tar.xz
RUN tar -xf gcc-linaro-7.4.1-2019.02-x86_64_arm-linux-gnueabihf.tar.xz
ENV PATH="${PWD}/gcc-linaro-7.4.1-2019.02-x86_64_arm-linux-gnueabihf/bin:${PATH}"

COPY autofools autofools

RUN echo $PATH

RUN cd autofools && libtoolize && aclocal && autoconf && automake --add-missing && ./configure --build=x86_64-linux-gnu --host=arm-linux-gnueabihf && make
