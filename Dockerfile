FROM node:latest AS build-deps
WORKDIR /opt/vue-2048
COPY package.json yarn.lock ./
RUN yarn
COPY . ./
RUN yarn build
#CMD yarn dev
FROM nginx:latest
COPY --from=build-deps /opt/vue-2048/dist /usr/share/nginx/html
#COPY --from=build-deps /opt/vue-2048/index /usr/share/nginx/html
