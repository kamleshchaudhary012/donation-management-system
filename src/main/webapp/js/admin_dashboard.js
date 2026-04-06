/* js/admin_dashboard.js */
document.addEventListener('DOMContentLoaded', function() {
    // Confirm before any delete action (charities or users)
    document.querySelectorAll('.btn-confirm-delete').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            var name = btn.getAttribute('data-name') || 'this item';
            if (!confirm('Are you sure you want to delete "' + name + '"?\nThis action cannot be undone.')) {
                e.preventDefault();
            }
        });
    });
});
