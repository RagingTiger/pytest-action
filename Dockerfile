# pinning base Python image
FROM python:3.10.5

# setting up args and env vars
ARG SOURCE_REPO=/pytest-action
ENV COVERAGE_RCFILE=${SOURCE_REPO}/.coveragerc

# getting necessary file
COPY . ${SOURCE_REPO}

# install python packages
RUN pip3 install -r ${SOURCE_REPO}/requirements.txt

# add chrome driver/browser
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list && \
    apt-get update && apt-get install -y \
    google-chrome-stable && \
    rm -rf /var/lib/apt/lists/* && \
    sbase install chromedriver

# setting final workdir
WORKDIR /testing

# setup command
CMD ["/${SOURCE_REPO}/run_tests.sh"]
