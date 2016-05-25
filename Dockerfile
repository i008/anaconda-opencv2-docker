FROM 	debian:7.4

RUN 	apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    	libglib2.0-0 libxext6 libsm6 libxrender1 \
    	git mercurial subversion

RUN 	echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    	wget --quiet https://repo.continuum.io/archive/Anaconda2-4.0.0-Linux-x86_64.sh && \
    	/bin/bash /Anaconda2-4.0.0-Linux-x86_64.sh -b -p /opt/conda && \
    	rm /Anaconda2-4.0.0-Linux-x86_64.sh

RUN 	apt-get install -y curl grep sed dpkg && \
    	TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    	curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    	dpkg -i tini.deb && \
    	rm tini.deb && \
    	apt-get clean

ENV 	PATH /opt/conda/bin:$PATH

RUN 	pip install --upgrade pip
RUN 	apt-get update
RUN 	apt-get install -y python-dev
RUN 	apt-get install make
RUN 	apt-get install git
RUN 	apt-get install gcc
RUN 	apt-get install build-essential cmake pkg-config -y
RUN 	apt-get install unzip

RUN 	mkdir opencv && \
	cd opencv && \
	wget -O opencv-2.4.10.zip http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.4.10/opencv-2.4.10.zip/download && \ 
	unzip opencv-2.4.10.zip && \ 
	cd opencv-2.4.10 && \ 
	mkdir build

RUN 	cd /opencv/opencv-2.4.10/build &&  \
	cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D BUILD_NEW_PYTHON_SUPPORT=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON  -D BUILD_EXAMPLES=ON .. && \
	make -j4 && \ 
	make install && \ 
	ldconfig

RUN 	ln /opencv/opencv-2.4.10/build/lib/cv2.so /opt/conda/lib/python2.7/site-packages/cv2.so


ENV LANG C.UTF-8
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]


