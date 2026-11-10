# meemoo Atramhasis Docker image

This repository builds a customized [Atramhasis](https://github.com/OnroerendErfgoed/atramhasis) image for meemoo. It adds custom templates and styling, initializes the SQLite database, and imports the SKOS datasets listed in `data.csv`.

## Run locally

```sh
docker compose up --build
```

The application is available at <http://localhost:6543>. Building the image requires internet access to download the Python, npm, and SKOS data dependencies.
