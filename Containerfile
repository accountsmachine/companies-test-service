
FROM fedora:35

ENV KEY=987654321

RUN dnf update -y && dnf install -y python3-aiohttp && dnf clean all

ADD companies /usr/local/bin/companies
ADD companies.json /usr/local/etc/companies.json

WORKDIR /usr/local
CMD /usr/local/bin/companies -c /usr/local/etc/companies.json -k ${KEY}
EXPOSE 8080

