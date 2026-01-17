# -*- coding: utf-8 -*-
"""
技术培训网站
可扩展的栏目管理系统
"""

from flask import Flask, render_template, jsonify, request
import json
import os
import re

app = Flask(__name__)

# 自定义Jinja2过滤器：从B站URL中提取BV号
@app.template_filter('extract_bv')
def extract_bv_filter(url):
    """从B站视频URL中提取BV号"""
    if not url:
        return ""
    # 匹配BV号模式
    match = re.search(r'BV[a-zA-Z0-9]+', url)
    return match.group(0) if match else ""

# 加载配置文件
def load_config():
    with open('config.json', 'r', encoding='utf-8') as f:
        return json.load(f)

config = load_config()

@app.route('/')
def index():
    """首页"""
    return render_template('index.html',
                         config=config,
                         featured_courses=config['courses'][:3])

@app.route('/courses')
def courses():
    """课程中心"""
    category = request.args.get('category', None)
    level = request.args.get('level', None)

    courses_list = config['courses']

    # 筛选课程
    if category:
        courses_list = [c for c in courses_list if c['category'] == category]
    if level:
        courses_list = [c for c in courses_list if c['level'] == level]

    return render_template('courses.html',
                         config=config,
                         courses=courses_list,
                         categories=list(set([c['category'] for c in config['courses']])),
                         levels=['初级', '中级', '高级'])

@app.route('/course/<int:course_id>')
def course_detail(course_id):
    """课程详情"""
    course = next((c for c in config['courses'] if c['id'] == course_id), None)
    if not course:
        return "课程不存在", 404

    # 推荐相关课程
    related_courses = [c for c in config['courses']
                      if c['id'] != course_id and c['category'] == course['category']][:2]

    return render_template('course_detail.html',
                         config=config,
                         course=course,
                         related_courses=related_courses)

@app.route('/videos')
def videos():
    """视频教程"""
    return render_template('videos.html',
                         config=config,
                         videos=config['videos'])

@app.route('/articles')
def articles():
    """技术文章"""
    category = request.args.get('category', None)
    articles_list = config['articles']

    if category:
        articles_list = [a for a in articles_list if a['category'] == category]

    categories = list(set([a['category'] for a in config['articles']]))

    return render_template('articles.html',
                         config=config,
                         articles=articles_list,
                         categories=categories)

@app.route('/article/<int:article_id>')
def article_detail(article_id):
    """文章详情"""
    article = next((a for a in config['articles'] if a['id'] == article_id), None)
    if not article:
        return "文章不存在", 404

    return render_template('article_detail.html',
                         config=config,
                         article=article)

@app.route('/development')
def development():
    """技术开发"""
    return render_template('development.html',
                         config=config,
                         services=config['development_services'])

@app.route('/service/<int:service_id>')
def service_detail(service_id):
    """技术开发服务详情"""
    service = next((s for s in config['development_services'] if s['id'] == service_id), None)
    if not service:
        return "服务不存在", 404

    return render_template('service_detail.html',
                         config=config,
                         service=service)

@app.route('/about')
def about():
    """关于我们"""
    return render_template('about.html',
                         config=config,
                         about=config['about'])

@app.route('/api/reload_config', methods=['POST'])
def reload_config():
    """重新加载配置（用于动态添加栏目）"""
    global config
    config = load_config()
    return jsonify({"status": "success", "message": "配置已重新加载"})

@app.route('/custom/<page_id>')
def custom_page(page_id):
    """自定义页面（扩展功能）"""
    # 从配置中读取自定义页面内容
    custom_pages = config.get('custom_pages', {})
    page_data = custom_pages.get(page_id, None)

    if not page_data:
        return "页面不存在", 404

    return render_template('custom_page.html',
                         config=config,
                         page_data=page_data)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001)
