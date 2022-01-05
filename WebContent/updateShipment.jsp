<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="authAdmin.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>Update Shipment</title>
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

	<h2>Update Shipment
		<a href=index.jsp><button style='float:right'>Main Menu &#127968</button></a>
		<a href=admin.jsp><button style='float:right'>Admin Page &#128100</button></a>
	</h2>
	<p>
		&#127800<a href=listShipment.jsp>Shipment Page</a>
	</p>
	<br>
<%
// Write query to retrieve all order summary records
try
{
	getConnection();
	int id = Integer.parseInt(request.getParameter("shipmentId"));
	String desc = (String)request.getParameter("shipmentDesc");
	PreparedStatement pstmt = con.prepareStatement("SELECT * FROM shipment WHERE shipmentId=?");
	pstmt.setInt(1,id);
	ResultSet shipments = pstmt.executeQuery();
	int check = 0;
	if(!shipments.next()){ // if no shipment with given id, add shipment
		out.println("<h3 style='color: red;'>Shipment ID does not exist.</h3>");
		out.println("<h3><a href='listShipment.jsp'><button style='float:center'>Retry</button></a></h3>");
	}else{
		String SQL = "UPDATE shipment SET shipmentDesc = ? WHERE shipmentId = ?";


		PreparedStatement pst = con.prepareStatement(SQL);
		pst.setString(1,desc);
		pst.setInt(2,id);


		check = pst.executeUpdate();
	}
	if(check >0) {
		out.println("<h3 style='color: darkgreen;'>Shipment status updated.</h3>");
		response.sendRedirect("listShipment.jsp");
	}
	else {
		out.println("<h3 style='color: red;'>Failed to update shipment status.</h3>");
		out.println("<h3><a href='listShipment.jsp'><button style='float:center'>Retry</button></a></h3>");
	} 
}
catch (Exception e)
{
	out.print("<h3 style='color:red'>"+e+"</h3>");
	out.println("<h3><a href='listShipment.jsp'><button style='float:center'>Retry</button></a></h3>");
}
finally
{	
	closeConnection();	
}
// Close connection
%>

</body>
</html>
