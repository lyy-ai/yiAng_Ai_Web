#!/bin/bash

# 技术培训网站 - 服务器部署脚本
# 适用于Ubuntu/Debian服务器

set -e  # 遇到错误立即退出

echo "========================================="
echo "  技术培训网站 - 自动部署脚本"
echo "========================================="

# 检查是否为root用户
if [ "$EUID" -ne 0 ]; then
    echo "请使用root用户运行此脚本"
    exit 1
fi

# 更新系统
echo "📦 更新系统软件包..."
apt update && apt upgrade -y

# 安装必要软件
echo "📦 安装Python和依赖..."
apt install -y python3 python3-pip python3-venv nginx

# 设置项目目录
PROJECT_DIR="/var/www/tech-training"
echo "📁 设置项目目录: $PROJECT_DIR"

# 如果目录不存在，需要先上传代码
if [ ! -d "$PROJECT_DIR" ]; then
    echo "⚠️  项目目录不存在！"
    echo "请先上传代码到服务器："
    echo "  scp -r /Users/yangyang.li5/Desktop/claude_code/yyy root@服务器IP:$PROJECT_DIR"
    exit 1
fi

cd $PROJECT_DIR

# 创建虚拟环境
echo "🐍 创建Python虚拟环境..."
python3 -m venv venv
source venv/bin/activate

# 安装依赖
echo "📦 安装Python依赖..."
pip install --upgrade pip
pip install -r requirements.txt

# 创建systemd服务
echo "⚙️  配置systemd服务..."
cat > /etc/systemd/system/tech-training.service <<EOF
[Unit]
Description=Tech Training Website
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=$PROJECT_DIR
Environment="PATH=$PROJECT_DIR/venv/bin"
ExecStart=$PROJECT_DIR/venv/bin/gunicorn --workers 3 --bind 0.0.0.0:5000 app:app
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# 设置文件权限
echo "🔐 设置文件权限..."
chown -R www-data:www-data $PROJECT_DIR

# 启动服务
echo "🚀 启动应用服务..."
systemctl daemon-reload
systemctl enable tech-training
systemctl restart tech-training

# 配置Nginx
echo "🌐 配置Nginx反向代理..."
cat > /etc/nginx/sites-available/tech-training <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /static {
        alias $PROJECT_DIR/static;
        expires 30d;
    }
}
EOF

# 启用站点
ln -sf /etc/nginx/sites-available/tech-training /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# 测试Nginx配置
echo "🔍 测试Nginx配置..."
nginx -t

# 重启Nginx
echo "🔄 重启Nginx..."
systemctl restart nginx

# 检查服务状态
echo ""
echo "========================================="
echo "  部署完成！"
echo "========================================="
echo ""

# 获取服务器IP
SERVER_IP=$(hostname -I | awk '{print $1}')

echo "✅ 应用状态："
systemctl status tech-training --no-pager | head -n 10

echo ""
echo "🌐 访问地址："
echo "   http://$SERVER_IP"
echo ""

echo "📝 有用的命令："
echo "   查看应用日志: journalctl -u tech-training -f"
echo "   重启应用:    systemctl restart tech-training"
echo "   停止应用:    systemctl stop tech-training"
echo "   Nginx日志:   tail -f /var/log/nginx/error.log"
echo ""

echo "🔐 配置HTTPS（可选）："
echo "   1. 确保域名已解析到此服务器"
echo "   2. 运行: apt install certbot python3-certbot-nginx"
echo "   3. 运行: certbot --nginx -d yourdomain.com"
echo ""

echo "========================================="
