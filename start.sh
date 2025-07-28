# node-red --port 64081 --userDir ./data;
pm2 stop ecosystem.config.js
pm2 start ecosystem.config.js
pm2 startup
pm2 save
