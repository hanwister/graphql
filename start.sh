# node-red --port 64081 --userDir ./data;

pm2 start start.sh --interpreter bash --name "graphql-server"
pm2 startup
pm2 save
