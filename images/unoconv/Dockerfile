FROM jordanorc/docker-unoconv-flask

RUN sed -i -e 's/workers 100/workers 4/g' circus.ini
RUN sed -i -e 's/cheaper-initial 5/cheaper-initial 1/g' circus.ini
