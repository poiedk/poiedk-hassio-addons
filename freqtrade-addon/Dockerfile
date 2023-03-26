ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk add --no-cache python3-dev py3-pip gcc musl-dev linux-headers libffi-dev openssl-dev

RUN pip3 install --upgrade pip
RUN pip3 install freqtrade

COPY freqtrade.sh /freqtrade.sh
COPY config.json /config.json

CMD [ "/freqtrade.sh" ]