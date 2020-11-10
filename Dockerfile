# set base image (host OS)
FROM python:3.7

# set the working directory in the container
WORKDIR /app

# copy the dependencies file to the working directory
ADD . /app/

# install dependencies
RUN pip install -r requirement.txt

# expose port
EXPOSE 5000
