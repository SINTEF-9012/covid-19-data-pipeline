FROM ubuntu:20.04

# Install wget
RUN apt-get --yes update
RUN apt-get --yes install git
WORKDIR /gitrepo/
RUN git clone https://github.com/folkehelseinstituttet/surveillance_data.git
WORKDIR /gitrepo/surveillance_data/

# Copy the scripts into the container
COPY ./bash_scripts /code
COPY ./common_scripts /code

ENTRYPOINT ["/code/main.sh"]