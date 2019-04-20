
# Setup and build the client

FROM node:carbon-alpine as client

LABEL maintainer "Carlos Mendez"

WORKDIR /usr/app/react_client/
COPY client/package*.json ./
RUN npm install -qy
COPY react_client/ ./
RUN npm run build

# Setup the database server



# Setup the node web server

FROM node:carbon-alpine

LABEL maintainer "Carlos Mendez"

WORKDIR /usr/app/
COPY --from=client /usr/app/client/build/ ./client/build/

WORKDIR /usr/app/server/
COPY node_server/package*.json ./
RUN npm install -qy
COPY server/ ./

ENV PORT 8000

EXPOSE 8000

CMD ["npm", "start"]
