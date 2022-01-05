<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="authAdmin.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>Update Warehouse</title>
	<style>
		@font-face{
            font-family: customFont;
            src: url(NikkyouSans-mLKax.ttf);
        }
		h2{
			text-align: left;
			font-family: customFont;
			font-size: 30px;
			padding: 4px;
		}
		h3{
			text-align: center;
			font-family: sans-serif;
			font-size: 20px;
			padding: 4px;
		}
		a{
        	color: black;
    	}
    	a:hover{
        	color:#FAAA96;
    	}
		p{
			font-family:sans-serif;
			font-size: 18px;
			text-align: left;
			font-weight: bold;
			padding: 4px;
		}
		button{
			font-family: sans-serif;
			font-size: 18px;
			font-weight: bold;
			text-align:center;
			padding: 6px;
			margin: 4px 2px;
			background: #F5CEC5;
			transition-duration: 0.4s;
			cursor: pointer;
		}
		button:hover{
			background-color: #FAAA96;
		}
	</style>
</head>
<body>
	<%@ include file="header.jsp" %>

	<h2>Update Warehouse
		<a href=index.jsp><button style='float:right'>Main Menu &#127968</button></a>
		<a href=admin.jsp><button style='float:right'>Admin Page &#128100</button></a>
	</h2>
	<p>
		&#127800<a href=listWarehouse.jsp>Warehouse List</a>
	</p>
	<br>
<%
String warehouseId = request.getParameter("warehouseId");
String warehouseName = request.getParameter("warehouseName");
try
{
	getConnection();
	int id=-1;
	try
	{
		id = Integer.parseInt(warehouseId);
	} 
	catch(Exception e)
	{
		out.println("<h3 style='color: red;'>Invalid warehouse ID!  Please try again.</h3>");
		out.println("<h3><a href='listWarehouse.jsp'><button style='float:center'>Retry</button></a></h3>");
		return;
	}

	String SQL = "UPDATE warehouse SET warehouseName = ? WHERE warehouseId = ?";

	PreparedStatement pst = con.prepareStatement(SQL);
	pst.setString(1,warehouseName); 
	pst.setInt(2,id);

	int check = pst.executeUpdate();
	if(check > 0) {
		out.println("<h3 style='color: darkgreen;'>Warehouse updated.</h3>");
		response.sendRedirect("listWarehouse.jsp");
	}
	else {
		out.println("<h3 style='color: red;'>Failed to update warehouse. Please try again.</h3>");
		out.println("<h3><a href='listWarehouse.jsp'><button style='float:center'>Retry</button></a></h3>");
	}
}
catch (Exception e)
{
    out.print("<h3 style='color:red'>"+e+"</h3>");
	out.println("<h3><a href='listWarehouse.jsp'><button style='float:center'>Retry</button></a></h3>");
}
finally
{	
	closeConnection();	
}
// Close connection
%>

</body>
</html>
