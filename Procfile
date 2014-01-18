web: http-server ./client -p $PORT
watchify: watchify -t coffeeify -t node-lessify -t reactify -v --extension=".coffee" client/js/main.coffee -o client/app.js
