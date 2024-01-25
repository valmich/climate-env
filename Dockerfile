FROM python:3.12-alpine3.19

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY ./climapp /climapp
COPY ./scripts /scripts

EXPOSE 8000

# install psycopg2 dependencies.
RUN python -m venv /venv &&\
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r /climapp/requirements.txt && \
    adduser --desabled-password --no-create-home duser && \
    mkdir -p /data/web/static && \
    mkdir -p /data/web/media && \
    chown -R duser:duser /venv && \
    chown -R duser:duser /data/web/static && \
    chown -R duser:duser /data/web/media && \
    chmod -R 755 /data/web/static && \
    chmod -R 755 /data/web/media && \
    chmod -R +x /scripts && \
    apt-get update && apt-get install -y \
    binutils \
    libproj-dev \
    libgdal-dev \
    gdal-bin \
    python3-gdal \
    postgressql-client \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/scripts:/venv/bin:$PATH"

USER duser

CMD ["commands.sh"]
