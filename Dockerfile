FROM alpine:latest
MAINTAINER Vladislav Bedilo <v.overdrive@gmail.com>

ARG HUNSPELL_BASE_URL="http://download.services.openoffice.org/contrib/dictionaries"

RUN apk add --no-cache \
    hunspell

RUN mkdir -p /tmp/hunspell /usr/share/hunspell \
  && { \
       echo "387e9fd6c24c34e27fe5f0eb227beec2522b8855dc44917a37a66571db15ed0d  ru_RU.zip"; \
       echo "8eecd25a1d16e43dde23fd72deb6c9290e0f328b7fb2956ec3fe07692ce8e653  ru_RU_ye.zip"; \
       echo "d0c06e4db5ee2f0b6ebb9b382437fab5f92af9cb9bf1bc3576d3a9d24d87d034  ru_RU_yo.zip"; \
       echo "9227f658f182c9cece797352f041a888134765c11bffc91951c010a73187baea  en_US.zip"; \
       
     } > /tmp/hunspell-sha256sum.txt \
  && cd /tmp/hunspell \
  && for file in $(awk '{print $2}' /tmp/hunspell-sha256sum.txt); do \
       wget -O "${file}" "${HUNSPELL_BASE_URL}/${file}"; \
       grep "${file}" /tmp/hunspell-sha256sum.txt | sha256sum -c -; \
       unzip "/tmp/hunspell/${file}"; \
     done \
  && cp *.aff *.dic /usr/share/hunspell \
  && rm -rf /tmp/*

RUN ln -s /usr/share/hunspell/en_US.aff /usr/share/hunspell/default.aff \
  && ln -s /usr/share/hunspell/en_US.dic /usr/share/hunspell/default.dic

WORKDIR /workdir