# 技术培训网站部署指南

本文档提供多种部署方案，从免费到付费，从简单到高级。

## 🎯 快速部署方案对比

| 平台 | 费用 | 难度 | 域名 | 部署时间 | 推荐指数 |
|------|------|------|------|----------|----------|
| Render | 免费 | ⭐ | yourapp.onrender.com | 5分钟 | ⭐⭐⭐⭐⭐ |
| PythonAnywhere | 免费 | ⭐ | yourusername.pythonanywhere.com | 10分钟 | ⭐⭐⭐⭐ |
| Railway | 免费/$5 | ⭐⭐ | yourapp.railway.app | 5分钟 | ⭐⭐⭐⭐ |
| Vercel | 免费 | ⭐⭐ | yourapp.vercel.app | 3分钟 | ⭐⭐⭐ |
| 阿里云/腾讯云 | 付费 | ⭐⭐⭐⭐ | 自定义域名 | 30分钟 | ⭐⭐⭐⭐⭐ |

---

## 方案一：Render 部署（推荐 - 免费且简单）

**最终域名格式**：`https://yourapp.onrender.com`

### 优势
- ✅ 完全免费（免费tier）
- ✅ 自动HTTPS
- ✅ 从GitHub自动部署
- ✅ 提供免费域名
- ✅ 支持自定义域名

### 部署步骤

#### 1. 准备GitHub仓库

```bash
cd /Users/yangyang.li5/Desktop/claude_code/yyy

# 初始化Git（如果还没有）
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: Tech Training Website"

# 创建GitHub仓库并推送（需要先在GitHub创建仓库）
git remote add origin https://github.com/你的用户名/tech-training.git
git branch -M main
git push -u origin main
```

#### 2. 在Render部署

1. 访问 https://render.com 并注册账号
2. 点击 "New" → "Web Service"
3. 连接你的GitHub仓库
4. 配置如下：
   - **Name**: `tech-training-site`（你的应用名称）
   - **Environment**: `Python 3`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `gunicorn app:app`
   - **Instance Type**: `Free`
5. 点击 "Create Web Service"

#### 3. 等待部署完成

大约3-5分钟后，你会获得一个网址：
```
https://tech-training-site.onrender.com
```

### 注意事项

- ⚠️ 免费版会在15分钟无活动后休眠，首次访问需要等待30秒唤醒
- ⚠️ 免费版有每月750小时的限制
- ✅ 可以升级到付费版获得更好性能（$7/月）

---

## 方案二：PythonAnywhere 部署（适合Python项目）

**最终域名格式**：`https://yourusername.pythonanywhere.com`

### 优势
- ✅ 专为Python设计
- ✅ 免费tier
- ✅ 无需Git
- ✅ 提供Web控制台

### 部署步骤

#### 1. 注册PythonAnywhere

访问 https://www.pythonanywhere.com 注册免费账号

#### 2. 上传代码

在PythonAnywhere控制台：

```bash
# 在Bash Console中
cd ~
git clone https://github.com/你的用户名/tech-training.git
cd tech-training
```

或者直接上传文件：
- 使用Files页面上传项目ZIP
- 解压到 `/home/你的用户名/tech-training`

#### 3. 创建虚拟环境

```bash
cd ~/tech-training
python3.10 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

#### 4. 配置Web App

1. 进入 "Web" 页面
2. 点击 "Add a new web app"
3. 选择 "Manual configuration"
4. 选择 "Python 3.10"
5. 配置WSGI文件：

编辑 `/var/www/你的用户名_pythonanywhere_com_wsgi.py`：

```python
import sys
import os

# 添加项目路径
project_home = '/home/你的用户名/tech-training'
if project_home not in sys.path:
    sys.path.insert(0, project_home)

# 激活虚拟环境
activate_this = os.path.join(project_home, 'venv/bin/activate_this.py')
with open(activate_this) as f:
    exec(f.read(), {'__file__': activate_this})

# 导入Flask应用
from app import app as application
```

6. 设置虚拟环境路径：`/home/你的用户名/tech-training/venv`
7. 点击 "Reload" 重新加载应用

#### 5. 访问网站

```
https://你的用户名.pythonanywhere.com
```

### 限制
- ⚠️ 免费版不支持自定义域名
- ⚠️ CPU时间有限制（每天100秒）
- ⚠️ 只能访问白名单API

---

## 方案三：Railway 部署（现代化平台）

**最终域名格式**：`https://yourapp.railway.app`

### 优势
- ✅ 现代化界面
- ✅ 免费$5额度/月
- ✅ 自动从GitHub部署
- ✅ 提供数据库支持

### 部署步骤

1. 访问 https://railway.app
2. 使用GitHub登录
3. 点击 "New Project" → "Deploy from GitHub repo"
4. 选择你的仓库
5. Railway自动检测Flask应用并部署
6. 点击 "Generate Domain" 获取网址

**最终网址**：`https://tech-training-production.railway.app`

---

## 方案四：Vercel 部署（需要适配）

**最终域名格式**：`https://yourapp.vercel.app`

Vercel主要支持Serverless，需要修改代码结构。

### 创建 `vercel.json`

```json
{
  "version": 2,
  "builds": [
    {
      "src": "app.py",
      "use": "@vercel/python"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "app.py"
    }
  ]
}
```

### 修改 `app.py`（底部添加）

```python
# 用于Vercel部署
if __name__ != '__main__':
    # Vercel serverless
    app = app
```

### 部署

1. 安装Vercel CLI：`npm i -g vercel`
2. 在项目目录运行：`vercel`
3. 跟随提示完成部署

---

## 方案五：Docker + 云服务器部署（完全控制）

适用于阿里云、腾讯云、AWS等任何支持Docker的服务器。

### 1. 购买云服务器

推荐配置：
- CPU: 1核
- 内存: 2GB
- 带宽: 1Mbps
- 系统: Ubuntu 22.04

价格参考：
- 阿里云：约¥100/年（学生优惠）
- 腾讯云：约¥100/年（新用户）

### 2. 服务器配置

```bash
# 连接服务器
ssh root@你的服务器IP

# 安装Docker
curl -fsSL https://get.docker.com | sh
systemctl start docker
systemctl enable docker

# 安装Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

### 3. 部署应用

```bash
# 上传代码到服务器
scp -r /Users/yangyang.li5/Desktop/claude_code/yyy root@你的服务器IP:/root/

# 在服务器上
cd /root/yyy

# 构建并运行
docker build -t tech-training .
docker run -d -p 80:5000 --name tech-training-app tech-training

# 或使用docker-compose（创建docker-compose.yml）
docker-compose up -d
```

### 4. 配置域名

1. 购买域名（阿里云、腾讯云、GoDaddy等）
2. 添加A记录指向你的服务器IP
3. 等待DNS生效（通常5-30分钟）

### 5. 配置HTTPS（可选但推荐）

```bash
# 安装Certbot
apt update
apt install certbot python3-certbot-nginx

# 安装Nginx
apt install nginx

# 配置Nginx反向代理
cat > /etc/nginx/sites-available/tech-training <<EOF
server {
    listen 80;
    server_name yourdomain.com;

    location / {
        proxy_pass http://localhost:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

ln -s /etc/nginx/sites-available/tech-training /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx

# 申请SSL证书
certbot --nginx -d yourdomain.com
```

**最终网址**：`https://yourdomain.com`

---

## 方案六：国内云平台（阿里云/腾讯云 - 推荐国内用户）

### 阿里云轻量应用服务器

#### 1. 购买服务器

1. 访问 https://www.aliyun.com
2. 选择 "轻量应用服务器"
3. 配置：
   - 镜像：Ubuntu 22.04
   - 规格：2核2G
   - 带宽：3Mbps
   - 价格：约¥60/年

#### 2. 一键部署脚本

创建 `deploy.sh`：

```bash
#!/bin/bash

# 更新系统
apt update && apt upgrade -y

# 安装Python
apt install python3 python3-pip python3-venv -y

# 上传代码（在本地执行）
# scp -r /Users/yangyang.li5/Desktop/claude_code/yyy root@你的服务器IP:/root/

# 在服务器上部署
cd /root/yyy
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# 使用systemd管理服务
cat > /etc/systemd/system/tech-training.service <<EOF
[Unit]
Description=Tech Training Website
After=network.target

[Service]
User=root
WorkingDirectory=/root/yyy
Environment="PATH=/root/yyy/venv/bin"
ExecStart=/root/yyy/venv/bin/gunicorn --bind 0.0.0.0:5000 app:app
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start tech-training
systemctl enable tech-training

# 安装Nginx
apt install nginx -y

# 配置Nginx
cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

systemctl restart nginx

echo "部署完成！访问 http://你的服务器IP"
```

#### 3. 执行部署

```bash
chmod +x deploy.sh
./deploy.sh
```

#### 4. 绑定域名（需要备案）

1. 购买域名
2. 完成ICP备案（约15天）
3. 添加解析记录
4. 配置HTTPS

**最终网址**：`http://你的服务器IP` 或 `https://yourdomain.com`

---

## 🎯 推荐方案总结

### 个人学习/测试
→ **Render** 或 **Railway**（免费，5分钟搞定）

### 小型项目/展示
→ **PythonAnywhere**（免费，稳定）

### 商业项目（国外）
→ **Render付费版** 或 **Railway Pro**（$7-10/月）

### 商业项目（国内）
→ **阿里云/腾讯云**（完全控制，需备案）

---

## 常见问题

### Q: 如何获得自定义域名？

**A**: 购买域名后在DNS设置中添加CNAME或A记录指向部署平台提供的域名或IP。

### Q: 免费方案的限制？

**A**:
- Render免费版：15分钟无活动休眠
- PythonAnywhere：CPU时间限制
- Railway：每月$5额度

### Q: 如何更新网站内容？

**A**:
1. 修改本地代码
2. 提交到GitHub
3. 部署平台自动检测并重新部署

或者直接修改 `config.json` 并重启服务。

### Q: 如何监控网站运行状态？

**A**: 使用：
- UptimeRobot (免费监控)
- Better Uptime
- 各平台自带的监控功能

---

## 下一步

选择一个部署方案后：

1. 将代码推送到GitHub
2. 按照对应方案的步骤部署
3. 测试访问
4. 配置自定义域名（可选）
5. 设置监控（推荐）

需要帮助？查看各平台的官方文档或联系技术支持。
