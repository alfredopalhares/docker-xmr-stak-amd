FROM ubuntu AS builder

LABEL maintainer="Alfredo Palhares <alfredo@palhares.me>"

ENV CMAKE_OPTS '-DMICROHTTPD_ENABLE=OFF -DXMR-STAK_COMPILE=generic -DHWLOC_ENABLE=OFF -DCPU_ENABLE=OFF -DCUDA_ENABLE=OFF'

WORKDIR /srv/build

## Compile XMR
## TODO Use a tag uinstead of master
RUN  apt update && apt install -y libmicrohttpd-dev libssl-dev cmake curl build-essential libhwloc-dev git ca-certificates libssl-dev ocl-icd-opencl-dev  \
    && git clone https://github.com/fireice-uk/xmr-stak.git \
    && mkdir -p xmr-stak/build && cd xmr-stak/build \
    && cmake ${CMAKE_OPTS} .. \
    && make install

# ConfD
ENV CONFD_SHA=255d2559f3824dd64df059bdc533fd6b697c070db603c76aaf8d1d5e6b0cc334

RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 -o /usr/bin/confd \
  && echo "${CONFD_SHA} /usr/bin/confd" | sha256sum -c - \
  && chmod a+x /usr/bin/confd \
  && mkdir -p /etc/confd/{conf.d,templates}

### AMD Drivers
ENV AMD_DRIVER_VERSION "18.20-606296"
ENV AMD_DRIVER_URL "https://www2.ati.com/drivers/linux/ubuntu/amdgpu-pro-${AMD_DRIVER_VERSION}.tar.xz"
ENV AMD_DRIVER_REFERER "http://support.amd.com/en-us/kb-articles/Pages/AMDGPU-PRO-Install.aspx"

RUN curl -L -O -H "Referer: ${AMD_DRIVER_REFERER}" ${AMD_DRIVER_URL} \
    && tar -xvJf amdgpu-pro-${AMD_DRIVER_VERSION}.tar.xz \
    && rm amdgpu-pro-${AMD_DRIVER_VERSION}.tar.xz \
    && ./amdgpu-pro-${AMD_DRIVER_VERSION}/amdgpu-install -y --no-install-recommends --headless --opencl=legacy,rocm \
    && rm -r amdgpu-pro-${AMD_DRIVER_VERSION}

RUN mkdir -p /srv/xmr-stak \
  && cp -v /srv/build/xmr-stak/build/bin/* /srv/xmr-stak/
COPY config.txt.tmpl /etc/confd/templates/
COPY pools.txt.tmpl /etc/confd/templates/
COPY config.txt.toml /etc/confd/conf.d/
COPY pools.txt.toml /etc/confd/conf.d/
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod a+x /usr/local/bin/entrypoint.sh

WORKDIR /srv/xmr-stak/

# TODO: Create unprivildged user

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]