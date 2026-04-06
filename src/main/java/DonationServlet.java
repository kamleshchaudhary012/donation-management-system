import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// Note: URL mapping is handled by web.xml — no @WebServlet annotation needed
public class DonationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        // Fix: login_process.jsp sets "userId", not "user"
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get parameters
        String charityId = request.getParameter("charityId");
        String charityName = request.getParameter("charityName");
        String amountStr = request.getParameter("amount");

        double amount = 0;
        if (amountStr != null && !amountStr.trim().isEmpty()) {
            try {
                amount = Double.parseDouble(amountStr);
            } catch (NumberFormatException e) {
                amount = 0;
            }
        }

        if (charityId == null || charityId.trim().isEmpty() || amount <= 0) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid donation details");
            return;
        }

        // Get logged-in user details from session
        String userEmail = (String) session.getAttribute("userEmail");
        String userName  = (String) session.getAttribute("userName");

        System.out.println("Donation received:");
        System.out.println("User: " + userName + " (" + userEmail + ")");
        System.out.println("Charity: " + charityName + " (ID: " + charityId + ")");
        System.out.println("Amount: ₹" + amount);

        // Redirect to thank-you page (thankyou.jsp handles the DB insert)
        response.sendRedirect("thankyou.jsp?charity=" + charityName + "&amount=" + amount);
    }
}
