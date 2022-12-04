#!/bin/bash
DIGEST_i386=sha256:10166dad34cdf72a266a441988344f477cd7af7c05ed5b07006a08f46e006fac
DIGEST_amd64=sha256:303c4ff282901160a0009411a7f0e76b1f1439e20c2f64703bf8f49ef0a18daa

ARCH=$1
VERSION=$2

[ -n "$VERSION" ] && VERSION=-$VERSION

IMAGE=thednp/cups-docker:epson-$ARCH$VERSION

[ -z "$ARCH" ] || [[ ! "$ARCH" =~ ^(amd64|i386)$ ]] && {
    echo "./build.sh (amd64|i386) [VERSION]" && exit 
}

PLATFORM=$ARCH
[ "$ARCH" == i386 ] && PLATFORM=386

DIGEST=$(eval echo \${DIGEST_$ARCH})
DRIVER_SRC_URL=https://download.ebz.epson.net/dsc/op/stable/debian/dists/lsb3.2/main/binary

download-drivers () {
    echo "Downloading drivers... "
    EPSON_DRIVERS=( \
        $(curl $DRIVER_SRC_URL-$ARCH/ 2>/dev/null \
                        | sed -re 's/.*(epson-[^[:blank:]]+.deb).*/\1/' \
                        | grep ^epson) \
    )
    mkdir -p drv/$ARCH
    for EPSON_DRIVER in ${EPSON_DRIVERS[*]} ; do
        if ! [ -e drv/$ARCH/$EPSON_DRIVER ] ; then 
            echo "Get $EPSON_DRIVER"
            curl $DRIVER_SRC_URL-$ARCH/$EPSON_DRIVER 2>/dev/null \
            -o drv/$ARCH/$EPSON_DRIVER
        else
            echo "Found $EPSON_DRIVER"
        fi
    done
}

# build image
cat <<EOF
Building image...
  Tag   : $IMAGE
  Arch  : $ARCH
  Base  : debian/eol@$DIGEST
EOF

download-drivers

docker build \
    -t $IMAGE \
    --build-arg DIGEST=$DIGEST \
    --build-arg ARCH=$ARCH \
    --build-arg IMAGE=$IMAGE \
    --platform linux/$PLATFORM \
    .

echo $IMAGE > /tmp/IMAGE