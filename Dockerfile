FROM nginx
COPY reader-data /usr/share/nginx/html/packages/elm-explorations/reader/latest
COPY reader-data /usr/share/nginx/html/packages/elm-explorations/reader/0.1.0
COPY root.html /usr/share/nginx/html/index.html
COPY all-packages.json /usr/share/nginx/html/all-packages.json
COPY reader.zip /usr/share/nginx/html/reader.zip
COPY nginx.conf /etc/nginx/nginx.conf
