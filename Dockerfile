ARG DIGEST
FROM debian/eol@$DIGEST as needs-squashing

RUN apt-get update && \
    apt-get install -y lsb cups && \
    apt-get clean -y

RUN /etc/init.d/cups start && \
    cupsctl --remote-admin --share-printers && \
    sed -i -r -e 's/^Port [0-9]+/Listen localhost:632/' -e 's/^([[:blank:]]+(AuthType|Require user).*)/#\1/' /etc/cups/cupsd.conf && \
    /etc/init.d/cups stop

ARG ARCH

COPY drv/$ARCH/* /mnt/

RUN for i in /mnt/*.deb ; do \
        dpkg --force all -i $i; \
    done

RUN rm -rf /var/log/apt/lists/* /var/log/dpkg/info/* /mnt/*

FROM scratch
COPY --from=needs-squashing / /

ARG ARCH
ARG IMAGE

ENV ARCH=$ARCH
ENV IMAGE=$IMAGE

COPY entrypoint /bin
COPY cups-docker /bin

ENTRYPOINT [ "/bin/entrypoint" ]
CMD [ "help" ]