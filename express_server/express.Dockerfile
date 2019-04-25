# Choose the base image to use for building the working image
# As of APR2019 this is the lastest stable version in a Docker Official Image
FROM node:8.16.0-alpine

LABEL maintainer "Carlos Mendez"

# Create app directory
WORKDIR /usr/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install -qy
RUN npm audit fix
# If you are building your code for production, uncomment the following line.
# Requires testing.
# RUN npm ci --only=production

# Bundle app source
COPY . .

EXPOSE 8080

CMD ["npm", "start"]
