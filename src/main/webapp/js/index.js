/* js/index.js */
document.addEventListener('DOMContentLoaded', function() {
    // Apply background images and href links from data attributes (set by JSP)
    document.querySelectorAll('.card-img[data-img]').forEach(function(el) {
        el.style.background = "url('" + el.getAttribute('data-img') + "')";
        el.style.backgroundSize = 'cover';
        el.style.backgroundPosition = 'center';
    });

    document.querySelectorAll('a.card-link[data-id]').forEach(function(el) {
        el.href = 'charity.jsp?id=' + el.getAttribute('data-id');
    });

    const monthlyBtn = document.getElementById('monthlyBtn');
    if (monthlyBtn) {
        monthlyBtn.addEventListener('click', () => {
            window.location.href = 'monthly.jsp';
        });
    }
});
