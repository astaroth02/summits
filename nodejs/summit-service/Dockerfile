FROM node:8-alpine

WORKDIR /usr/local/app/
COPY package*.json /usr/local/app/
RUN npm install
COPY src/ /usr/local/app/src

USER node

EXPOSE 3000

CMD ["npm", "start"]
