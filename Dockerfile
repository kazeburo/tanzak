FROM kazeburo/perl:v5.20
RUN mkdir -p /opt/app
COPY ./cpanfile /opt/app/cpanfile
COPY ./cpanfile.snapshot /opt/app/cpanfile.snapshot
WORKDIR /opt/app
RUN carton install --deployment
EXPOSE 5000
COPY . /opt/app
CMD carton exec -- plackup -s Starlet --port 5000 -a app.psgi
