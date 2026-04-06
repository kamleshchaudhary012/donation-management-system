<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String subject = request.getParameter("subject");
    String message = request.getParameter("message");
    
    // Logic to save contact form or send email
    System.out.println("New message from " + name + ": " + subject);
    
    response.sendRedirect("contact.jsp?msg=sent");
%>
