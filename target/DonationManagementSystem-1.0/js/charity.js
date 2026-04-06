/* js/charity_detail.js */
document.addEventListener('DOMContentLoaded', function() {
    function applyProgressFromAttributes() {
        document.querySelectorAll('.progress-bar-fill[data-progress-width]').forEach(function(el) {
            const width = el.getAttribute('data-progress-width');
            if (width !== null && width !== '') {
                el.style.width = width + '%';
            }
        });
    }

    function refreshProgressFromServer() {
        const bars = document.querySelectorAll('.progress-bar-fill[data-charity-id]');
        if (!bars.length) return;

        fetch('charity_progress.jsp', { cache: 'no-store' })
            .then(function(res) { return res.json(); })
            .then(function(payload) {
                if (!payload || !payload.success || !Array.isArray(payload.data)) return;

                payload.data.forEach(function(item) {
                    const bar = document.querySelector('.progress-bar-fill[data-charity-id="' + item.id + '"]');
                    if (bar) {
                        bar.style.width = item.progress + '%';
                    }
                });
            })
            .catch(function() {
                // Keep current widths if refresh fails.
            });
    }

    // Initial render from server-side values.
    applyProgressFromAttributes();
    // Then keep updating using latest DB data.
    refreshProgressFromServer();
    setInterval(refreshProgressFromServer, 15000);


    const amountBtns = document.querySelectorAll('.amount-btn');
    const amountInput = document.getElementById('amount');
    
    if (amountBtns.length && amountInput) {
        amountBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                // Remove active class from all buttons
                amountBtns.forEach(b => b.classList.remove('active'));
                
                // Add active class to clicked button
                this.classList.add('active');
                
                // Set the amount input value
                const amount = this.getAttribute('data-amount');
                amountInput.value = amount;
            });
        });
        
        // Clear buttons if manual input is used
        amountInput.addEventListener('input', function() {
            amountBtns.forEach(b => b.classList.remove('active'));
        });
    }
});
