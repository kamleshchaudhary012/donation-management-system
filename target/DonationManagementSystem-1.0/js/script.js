// js/script.js
document.addEventListener('DOMContentLoaded', function() {
    // Login button (present on most pages)
    const loginBtn = document.getElementById('loginBtn');
    if (loginBtn) {
        loginBtn.addEventListener('click', function() {
            alert('Login modal would appear here. (Static design)');
        });
    }

    // Amount button behavior (for donation forms)
    const amountBtns = document.querySelectorAll('.amount-btn');
    const amountInput = document.getElementById('amount');
    if (amountBtns.length && amountInput) {
        amountBtns.forEach(btn => {
            btn.addEventListener('click', function() {
                amountBtns.forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                const amount = this.getAttribute('data-amount');
                amountInput.value = amount;
            });
        });
    }
});