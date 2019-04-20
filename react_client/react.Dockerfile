FROM node:carbon-alpine

LABEL maintainer "Carlos Mendez"

WORKDIR /usr/app

COPY package*.json ./

RUN npm install -qy
RUN npm audit fix

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
