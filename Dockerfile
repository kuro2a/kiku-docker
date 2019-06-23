FROM alpine:latest

# Environment variables.
ENV GROUP_ID 3000
ENV USER_ID 3000
ENV GITHUB_USER your_github_account
ENV GITHUB_TOKEN your_github_accounts_token
ENV GIT_BRANCH your_developing_git_branch

# Change root user.
USER root

# Install python libraries.
RUN apk --update add python3 build-base python3-dev libffi-dev postgresql-dev git
RUN pip3 install --upgrade pip && pip3 install \
  falcon==2.0.0 \
  jinja2 \
  bcrypt \
  elasticsearch \
  pymongo \
  tinydb \
  redis \
  pytest \
  sqlalchemy \
  psycopg2 \
  pymysql

# Create User.
RUN addgroup -g ${GROUP_ID} app && \
    adduser -D -G app -u ${USER_ID} -h /home/app app

# Change app user.
USER app

# Clone from GitHub.
RUN cd /home/app && git clone https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/kuro2a/kiku && \
    cd /home/app/kiku && git checkout -b ${GIT_BRANCH} origin/${GIT_BRANCH}

# Change app user.
WORKDIR /home/app/kiku

# Execute server application.
CMD [ "/usr/bin/python3", "main.py"]

