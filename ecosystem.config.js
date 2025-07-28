module.exports = {
  apps : [{
    name: "node-red-64081", // Tên ứng dụng của bạn
    script: "node_modules/node-red/red.js", // Đường dẫn đến script gốc của Node-RED
    args: "--port 64081 --userDir ./data", // Các đối số bạn muốn truyền vào Node-RED
    exec_mode: "fork", // Chế độ thực thi (fork là phù hợp cho Node-RED)
    instances: 1, // Số lượng instance (thường là 1 cho Node-RED)
    autorestart: true, // Tự động khởi động lại nếu có lỗi
    watch: false, // Không giám sát thay đổi file để tự động khởi động lại (có thể bật nếu cần)
    max_memory_restart: "1G", // Khởi động lại nếu bộ nhớ vượt quá 1GB (có thể điều chỉnh)
    env: {
      NODE_ENV: "production"
    }
  }]
};