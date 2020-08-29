FROM node:10.19.0-stretch-slim
RUN mkdir -p /opt/apps
WORKDIR /opt/apps
COPY . .
RUN npm install express && npm install mongodb
ENV MONGODB_HOST=localhost \
    MONGODB_PORT=27017
EXPOSE 3000
CMD [ "node", "app.js" ]