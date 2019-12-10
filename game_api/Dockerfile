FROM node:erbium

WORKDIR /code

COPY package.json package.json

RUN npm install --production

# This skips the test files because we have a .dockerignore file defined
COPY *.js ./

CMD node app.js