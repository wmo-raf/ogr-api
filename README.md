# OGR API

This repository is the microservice that implements the OGR
functionality, which is exposed on the /convert endpoint.

The OGR service is used to convert various geo formats in to GeoJSON (in
a web mercator projection), mainly to be used on the EAHW map. For
example, it can convert uploaded Shapefiles to GeoJSON.

## Dependencies

The OGR API microservice is built using [Node.js](https://nodejs.org/en/), and can be executed either natively or using Docker, each of which has its own set of requirements.

Native execution requires:
- [Node.js](https://nodejs.org/en/)

Execution using Docker requires:
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

## Getting started

Start by cloning the repository from github to your execution environment

```
git clone https://github.com/icpac-igad/eahw-ogr.git && cd eahw-ogr
```

After that, follow one of the instructions below:

### Using native execution

1 - Set up your environment variables. See `.env.sample` for a list of variables you should set, which are described in detail in [this section](#environment-variables) of the documentation. Native execution will NOT load the `dev.env` file content, so you need to use another way to define those values

2 - Install node dependencies using yarn:
```
yarn
```

3 - Start the application server:
```
yarn start
```

The endpoints provided by this microservice should now be available through Control Tower's URL.

### Using Docker

1 - Create and complete your `.env` file with your configuration. The meaning of the variables is available in this [section](#configuration-environment-variables). You can find an example `.env.sample` file in the project root.

2 - Execute the following command"

```
./ogr.sh start
```
## Configuration

### Environment variables

- PORT => TCP port in which the service will run

You can optionally set other variables, see [this file](config/custom-environment-variables.json) for an extended list.
