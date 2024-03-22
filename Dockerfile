FROM python:3.8.5-slim

ENV GIT_REPO 'https://github.com/dceldran/autoremove-torrents'
RUN ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
RUN echo 'Europe/Madrid' >/etc/timezone
WORKDIR /app
RUN apt update \
    && apt -y install cron git unzip\
    && apt clean
RUN git clone $GIT_REPO && cd autoremove-torrents && python3 setup.py install
RUN mkdir /etc/autoremove_torrents && touch /etc/autoremove_torrents/config.yml

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

COPY cron-autoremove-torrents /etc/cron.d/crontab

RUN chmod 0644 /etc/cron.d/crontab

RUN crontab /etc/cron.d/crontab

RUN mv /usr/local/lib/python3.8/site-packages/autoremove_torrents-1.5.4-py3.8.egg .
RUN unzip autoremove_torrents-1.5.4-py3.8.egg -d /usr/local/lib/python3.8/site-packages/autoremove_torrents-1.5.4-py3.8.egg

ENTRYPOINT ["/entrypoint.sh"]

CMD ["cron", "-f"]