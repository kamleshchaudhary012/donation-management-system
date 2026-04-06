<script src="https://checkout.razorpay.com/v1/checkout.js"></script>

<input type="number"
       id="amount"
       placeholder="Enter Amount">

<button onclick="payNow()">
    Donate Now
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

</script>