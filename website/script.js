// Modal logic
function showModal(modalId) {
    document.getElementById(modalId).style.display = 'block';
    document.getElementById(modalId + 'Overlay').style.display = 'block';
}
function hideModal(modalId) {
    document.getElementById(modalId).style.display = 'none';
    document.getElementById(modalId + 'Overlay').style.display = 'none';
}
document.addEventListener('DOMContentLoaded', function() {
    var loginModal = document.getElementById('loginModal');
    var loginOverlay = document.getElementById('loginOverlay');
    var loginBtn = document.querySelector('.binhi-btn-login');
    if (loginBtn && loginModal && loginOverlay) {
        loginBtn.addEventListener('click', function() {
            showModal('loginModal');
        });
        var loginClose = loginModal.querySelector('.close');
        if (loginClose) {
            loginClose.addEventListener('click', function() {
                hideModal('loginModal');
            });
        }
        loginOverlay.addEventListener('click', function() {
            hideModal('loginModal');
        });
    }
    document.querySelectorAll('#showSignupBtn').forEach(function(signupBtn) {
        signupBtn.addEventListener('click', function(e) {
            e.preventDefault();
            hideModal('loginModal');
            showModal('signupModal');
        });
    });
    var signupModal = document.getElementById('signupModal');
    var signupOverlay = document.getElementById('signupOverlay');
    if (signupModal && signupOverlay) {
        var signupClose = signupModal.querySelector('.close');
        if (signupClose) {
            signupClose.addEventListener('click', function() {
                hideModal('signupModal');
            });
        }
        signupOverlay.addEventListener('click', function() {
            hideModal('signupModal');
        });
    }
});

// Slideshow auto-advance logic with title and subtitle
var binhiTitles = [
    'Seed of Hope',
    'Growth Together',
    'Community Roots',
    'Green Future',
    'Empowering Farmers'
];
var binhiSubtitles = [
    'Empowering Farmers & Cooperatives for a Greener Tomorrow',
    'Connecting Filipino Farmers for a Brighter Future',
    'Growing Stronger, Growing Smarter',
    'Building Community, Planting Change',
    'Sowing Seeds for Sustainable Agriculture'
];
function showSlide(index) {
    var slides = document.querySelectorAll('.slide');
    var indicators = document.querySelectorAll('.indicator');
    slides.forEach(function(slide, i) {
        slide.classList.toggle('active', i === index);
    });
    indicators.forEach(function(indicator, i) {
        indicator.classList.toggle('active', i === index);
    });
    // Update title and subtitle
    var titleElem = document.getElementById('heroTitle');
    var subtitleElem = document.getElementById('heroSubtitle');
    if (titleElem && subtitleElem) {
        titleElem.textContent = binhiTitles[index % binhiTitles.length];
        subtitleElem.textContent = binhiSubtitles[index % binhiSubtitles.length];
    }
}
var currentSlideIndex = 0;
function nextSlide() {
    var slides = document.querySelectorAll('.slide');
    currentSlideIndex = (currentSlideIndex + 1) % slides.length;
    showSlide(currentSlideIndex);
}
function goToSlide(index) {
    currentSlideIndex = index;
    showSlide(currentSlideIndex);
}
document.addEventListener('DOMContentLoaded', function() {
    var slides = document.querySelectorAll('.slide');
    var indicators = document.querySelectorAll('.indicator');
    if (slides.length > 0) {
        showSlide(currentSlideIndex);
        setInterval(nextSlide, 5000);
        // Add click event to indicators
        indicators.forEach(function(indicator, i) {
            indicator.addEventListener('click', function() {
                goToSlide(i);
            });
        });
    }
});