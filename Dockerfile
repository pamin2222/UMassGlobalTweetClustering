FROM tensorflow/tensorflow:1.11.0-py3
RUN apt-get update
RUN apt-get install locales

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install dependencies
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -qq wget unzip build-essential cmake gcc libcunit1-dev libudev-dev

WORKDIR /workdir
ADD . /workdir

RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y software-properties-common
RUN apt-get install -y curl
RUN apt-get install -y libgtk2.0-0
RUN apt-get install -y libicu-dev
RUN apt-get install -y git

#python 3.6.5
RUN apt install -y build-essential checkinstall libreadline-gplv2-dev \
	libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev \
	libbz2-dev openssl

RUN mkdir -p $HOME/opt
RUN cd $HOME/opt
RUN curl -O https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tgz
RUN tar -xzf Python-3.6.5.tgz
RUN cd Python-3.6.5/ && ./configure && make && make install


#py3 as default
RUN echo "alias python=python3 \n" > ~/.bashrc
RUN echo "alias pip=pip3" >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"
RUN rm /usr/bin/python
RUN ln -s /usr/bin/python3.6 /usr/bin/python

RUN pip3 install --upgrade pip
RUN cd /workdir
RUN pwd
RUN ls
RUN pip3 install -r requirements.txt
RUN apt install -y libsm6 libxext6
RUN python3 -m spacy download en

#matplotlib Support Thai font
RUN wget https://github.com/Phonbopit/sarabun-webfont/raw/master/fonts/thsarabunnew-webfont.ttf -P /usr/local/lib/python3.6/site-packages/matplotlib/mpl-data/fonts/ttf

RUN cd /.

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/lib

CMD /bin/bash
