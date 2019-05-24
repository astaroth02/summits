FROM node:8-alpine

WORKDIR /home/node/app/
COPY package*.json /home/node/app/
RUN npm install
COPY src/ /home/node/app/src

RUN chown -R node: /home/node/app/

USER node

EXPOSE 3002

CMD ["npm", "start"]
