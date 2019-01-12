FROM alpine:latest

LABEL "com.github.actions.name"="pylint"
LABEL "com.github.actions.description"="Run pylint on a pull request and provide feedback in a single comment"
LABEL "com.github.actions.icon"="check-square"
LABEL "com.github.actions.color"="yellow"

RUN apk add --no-cache \
   python3-dev \
   gcc \
   build-base \
   curl

RUN python3 -m ensurepip
RUN pip3 install --upgrade pip
RUN pip3 install \
   linty-fresh \
   pylint

COPY "run-linty-fresh.sh" /usr/bin/run-linty-fresh

CMD ["sh", "/usr/bin/run-linty-fresh"]
