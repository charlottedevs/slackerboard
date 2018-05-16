FROM node:8.4

RUN apt-get update -y && apt-get upgrade -y

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN npm install -g yarn
COPY package.json /usr/src/app/
COPY yarn.lock /usr/src/app/
RUN yarn install

COPY . ./

EXPOSE 4000
ENV PORT 4000
