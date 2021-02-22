FROM node:12.18

WORKDIR /build/api
ADD ./api .
RUN npm install


ENV WAIT_VERSION 2.7.2
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/$WAIT_VERSION/wait /wait
RUN chmod +x /wait

ENV PORT 3000
EXPOSE 3000

CMD ["npm", "start"]
