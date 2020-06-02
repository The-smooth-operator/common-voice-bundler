FROM node:14-buster

LABEL maintainer="Alberto del Barrio <alberto@mozilla.com>"
LABEL repo=https://github.com/Common-Voice/common-voice-bundler

# Add project source
COPY . /code
COPY mp3-duration-sum /bin

# Setup work directory
WORKDIR /code

# Install application dependencies
RUN apt-get update && apt-get install -y python3-pip
RUN git clone https://github.com/mozilla/CorporaCreator.git && pip3 install --upgrade setuptools
RUN mkdir corpora && cd CorporaCreator && python3 setup.py install

# Install yarn dependencies
RUN yarn

# Default command to start the server
CMD yarn download-and-process && create-corpora -d corpora -f out/clips.tsv && yarn upload-corpora
