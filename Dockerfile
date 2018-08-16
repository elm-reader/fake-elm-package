FROM nginx
RUN mkdir /cache
WORKDIR /usr/share/nginx/html

COPY browser-data ./packages/elm/browser/latest
COPY browser-data ./packages/elm/browser/1.0.0
COPY browser-data/releases.json ./packages/elm/releases.json
COPY browser.zip ./browser.zip

COPY root.html ./index.html
COPY all-packages.json ./all-packages.json
COPY nginx.conf /etc/nginx/nginx.conf
