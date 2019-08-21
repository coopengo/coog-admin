FROM jordanorc/docker-unoconv-flask

RUN addgroup -g 1000 unoconv \
    && adduser -u 1000 -G unoconv -s /bin/sh -D unoconv

# change default config (1 to 4 workers)
RUN sed -i -e 's/workers 100/workers 4/g' circus.ini \
    && sed -i -e 's/cheaper-initial 5/cheaper-initial 1/g' circus.ini \
    && sed -i -e 's/--logto \/var\/log\/unoconv.log //g' circus.ini

USER unoconv
