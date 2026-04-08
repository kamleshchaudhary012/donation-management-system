<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>

    <title>Support Packages</title>

    <!-- Razorpay Script -->
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>

</head>

<body>

<h2>Choose Your Support Package</h2>

<p>
Select an amount to purchase a support package.
Payments are processed securely through Razorpay.
</p>

<!-- Amount Input -->

<input type="number"
       id="amount"
       placeholder="Enter Amount (Minimum ₹10)"
       min="10"
       required>

<br><br>

<button onclick="payNow()">
    Pay Now
</button>

<script>

function payNow() {

    var amount =
        document.getElementById("amount").value;

    // Amount validation
    if (amount == "" || amount < 10) {

        alert("Please enter a valid amount (minimum ₹10)");
        return;

    }

    fetch("CreateOrderServlet", {

        method: "POST",

        headers: {
            'Content-Type':
            'application/x-www-form-urlencoded'
        },

        body: "amount=" + amount

    })

    .then(response => response.json())

    .then(order => {

        var options = {

            "key": "rzp_test_Sa3XSlrlJcjWtY",

            "amount": order.amount,

            "currency": "INR",

            "order_id": order.id,

            "name": "SupportX",

            "description": "Support Package Payment",

            "handler": function (response) {

                window.location.href =
                "paymentSuccess.jsp?"
                + "payment_id="
                + response.razorpay_payment_id;

            },

            "theme": {
                "color": "#3399cc"
            }

        };

        var rzp =
            new Razorpay(options);

        rzp.open();

    });

}

</script>

</body>
</html>


<!--<script src="https://checkout.razorpay.com/v1/checkout.js"></script>

<input type="number"
       id="amount"
       placeholder="Enter Amount">

<button onclick="payNow()">
    Choose Support Package
</button>

<script>

    function payNow() {

        var amount =
                document.getElementById("amount").value;

        fetch("CreateOrderServlet", {

            method: "POST",

            headers: {
                'Content-Type':
                        'application/x-www-form-urlencoded'
            },

            body: "amount=" + amount

        })

                .then(response => response.json())

                .then(order => {

                    var options = {

                        "key": "rzp_test_Sa3XSlrlJcjWtY",

                        "amount": order.amount,

                        "currency": "INR",

                        "order_id": order.id,

                        "name": "CharityX",

                        "description": "Donation Payment",

                        handler: function (response) {

                            window.location.href =
                                    "paymentSuccess.jsp?"
                                    + "payment_id="
                                    + response.razorpay_payment_id;

                        }

                    };

                    var rzp =
                            new Razorpay(options);

                    rzp.open();

                });

    }

</script>-->