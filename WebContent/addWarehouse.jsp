<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="authAdmin.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>Add Warehouse</title>
	<style>
		h3{
			text-align: center;
			font-family: sans-serif;
			font-size: 20px;
		}
	</style>
</head>
<body>
<%

// Write query to retrieve all order summary records
try
{
	getConnection();
	String name = request.getParameter("warehouseName");
	String SQL = "INSERT INTO warehouse (warehouseName) VALUES (?)";
	PreparedStatement pst = con.prepareStatement(SQL);
	pst.setString(1,name);

	int check = pst.executeUpdate();

	if(check >0) {
		out.println("<h3 style='color: darkgreen;'>New warehouse added.</h3>");
		response.sendRedirect("listWarehouse.jsp");
	}
	else {
		out.println("<h3 style='color: red;'>Failed to add warehouse.</h3>");
		out.println("<h3><a href='listWarehouse.jsp'><button style='float:center'>Retry</button></a></h3>");
	}
}
catch (Exception e)
{
    out.print(e);
}
finally
{	
	closeConnection();	
}


// Close connection
%>

</body>
</html>