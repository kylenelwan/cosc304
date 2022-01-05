<%@ include file="authAdmin.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<title>Update Customer</title>
</head>
<body>
<%
// Make connection

// Write query to retrieve all order summary records
try
{
	getConnection();
	int id = Integer.parseInt(request.getParameter("customerId")); // disable option to update custId
	String first = request.getParameter("firstName");
	String last = request.getParameter("lastName");
	String email = request.getParameter("email");
	String phone = request.getParameter("phonenum");
	String address = request.getParameter("address");
	String city = request.getParameter("city");
	String state = request.getParameter("state");
	String postal = request.getParameter("postalCode");
	String country = request.getParameter("country");
	// String userId = request.getParameter("userid");
	// String password = request.getParameter("password");

	String SQL = "UPDATE customer SET firstName = ?, lastName = ?, email = ?, phonenum = ?, address = ?, city = ?, state = ?, postalCode  = ?, country = ? WHERE customerId = ?";


	PreparedStatement pst = con.prepareStatement(SQL);
	pst.setString(1,first);
	pst.setString(2,last);
	pst.setString(3,email);
	pst.setString(4,phone);
	pst.setString(5,address);
	pst.setString(6,city);
	pst.setString(7,state);
	pst.setString(8,postal);
	pst.setString(9,country);
	//pst.setString(10,userId);
	//pst.setString(11,password);
	pst.setInt(10, id);


	int check = pst.executeUpdate();
	if(check >0) {out.println("Customer updated"); response.sendRedirect("listCust.jsp");}
	else out.println("failed to update Customer");
}
catch (Exception e)
{
    out.print("<h3 style='color:red'>"+e+"</h3>");
}
finally
{	
	closeConnection();	
}


// Close connection
%>

</body>
</html>