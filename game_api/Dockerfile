FROM node:erbium

WORKDIR /code

COPY package.json package.json

RUN npm install --production

# This skips the test files because we have a .dockerignore file defined
COPY *.js ./

COPY database.json database.json
COPY migrations/ migrations/

# Give postgres time to setup before we try to migrate.
CMD sleep 5 && npm run migratedb:pg && node app.js