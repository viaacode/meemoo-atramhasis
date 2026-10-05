FROM python:3.12-alpine
ARG branch=main
# The latest alpine images don't have some tools like (`git` and `bash`).
# Adding bash and openssh to the image
RUN apk update && apk upgrade && \
    apk add --no-cache bash openssh git nodejs npm

COPY . /app/atramhasis

WORKDIR /app/atramhasis

# RUN pip install atramhasis==2.1.1
# Install atramhasis from the git repository, as the latest release doesn't include the scss files, which are needed to generate the css.
RUN npm install -g pnpm@latest-11
RUN pip install --upgrade pip pip-tools
RUN pip install atramhasis==4.0.0

# Generate custom
RUN npm install -g sass

# Atramhasis no longer bundles font-awesome/foundation-sites scss itself, so
# fetch those separately; its own scss partials still ship under the
# package's static/scss dir, so app.scss/settings.scss don't need to change.
RUN npm install --no-save --prefix /tmp/scss-deps foundation-sites@5.5.3 font-awesome@4.7.0
RUN cd ./meemoo_atramhasis/static && sass \
      -I /usr/local/lib/python3.12/site-packages/atramhasis/static/scss \
      -I /tmp/scss-deps/node_modules/foundation-sites/scss \
      -I /tmp/scss-deps/node_modules/font-awesome/scss \
      --embed-source-map --quiet scss/app.scss css/app.css

RUN pip install -e .[dev]

# create or update database
RUN alembic upgrade head

# Add SKOS data
RUN mkdir /data
COPY data.csv /data
RUN bash load.sh

EXPOSE 6543

RUN addgroup --system appgroup --gid 1001 && adduser -u 1000 --system appuser --ingroup appgroup

RUN chown -R appuser:appgroup /app/atramhasis

USER appuser

CMD ["pserve", "development.ini"] 