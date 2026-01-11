// 技术培训网站 JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // 添加淡入动画
    const cards = document.querySelectorAll('.card');
    cards.forEach((card, index) => {
        setTimeout(() => {
            card.classList.add('fade-in');
        }, index * 100);
    });

    // 当前页面导航高亮
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('.navbar-nav .nav-link');

    navLinks.forEach(link => {
        if (link.getAttribute('href') === currentPath) {
            link.classList.add('active');
        }
    });

    // 平滑滚动
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // 卡片悬停效果增强
    const hoverCards = document.querySelectorAll('.hover-card');
    hoverCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.cursor = 'pointer';
        });
    });

    // 表单验证提示
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            if (!form.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
            }
            form.classList.add('was-validated');
        });
    });

    // 点赞功能示例
    const likeButtons = document.querySelectorAll('.btn-like');
    likeButtons.forEach(button => {
        button.addEventListener('click', function() {
            const icon = this.querySelector('i');
            if (icon.classList.contains('far')) {
                icon.classList.remove('far');
                icon.classList.add('fas');
                this.classList.add('text-danger');
            } else {
                icon.classList.remove('fas');
                icon.classList.add('far');
                this.classList.remove('text-danger');
            }
        });
    });

    // 搜索功能示例
    const searchInput = document.querySelector('#searchInput');
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const cards = document.querySelectorAll('.card');

            cards.forEach(card => {
                const title = card.querySelector('.card-title');
                if (title) {
                    const text = title.textContent.toLowerCase();
                    if (text.includes(searchTerm)) {
                        card.closest('.col-md-6, .col-lg-4, .col-md-4').style.display = '';
                    } else {
                        card.closest('.col-md-6, .col-lg-4, .col-md-4').style.display = 'none';
                    }
                }
            });
        });
    }

    // 返回顶部按钮
    const backToTop = document.querySelector('#backToTop');
    if (backToTop) {
        window.addEventListener('scroll', function() {
            if (window.scrollY > 300) {
                backToTop.style.display = 'block';
            } else {
                backToTop.style.display = 'none';
            }
        });

        backToTop.addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }
});

// 动态加载配置（用于扩展功能）
function reloadConfig() {
    fetch('/api/reload_config', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.status === 'success') {
            alert('配置已更新！');
            location.reload();
        }
    })
    .catch(error => {
        console.error('Error:', error);
    });
}

// 工具函数：格式化日期
function formatDate(dateString) {
    const options = { year: 'numeric', month: 'long', day: 'numeric' };
    return new Date(dateString).toLocaleDateString('zh-CN', options);
}

// 工具函数：防抖
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}
