#node:10 provided by rearc documentation as a working base
FROM node:10

#secret word acquired by visiting the index page
ENV SECRET_WORD TwelveFactor

#setting working dir
WORKDIR /app

#copy all files
COPY . .

# install commmand for npm
RUN npm install

#rearc listening on port 3000
EXPOSE 3000

#start command for npm
CMD ["npm", "start"]
