/* js/monthly.js */
document.addEventListener('DOMContentLoaded', function() {
    // Set progress bar widths from data attributes.
    document.querySelectorAll('[data-progress-width]').forEach(function(el) {
        var w = el.getAttribute('data-progress-width');
        if (w != null && w !== '') {
            el.style.width = w + '%';
        }
    });
});
