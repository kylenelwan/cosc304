<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
<style>
	@font-face{
        font-family: customFont;
        src: url(NikkyouSans-mLKax.ttf);
    }
	h2{
		text-align: left;
		font-family: customFont;
		font-size: 30px;
	}
	table{
		width: 100%;
	}
	table, td{
		border: 1px solid #7E8193;
	}
    td, p{
        font-family: sans-serif;
        font-size: 14px;
		height: 25px;
    }
	.tableheader{
		height: 30px;
		font-size: 18px;
		font-family: customFont;
		text-align: center;
		background-color: #F5CEC5;
	}
	.button{
		font-family: sans-serif;
		font-size: 18px;
		font-weight: bold;
		text-align:center;
		padding: 6px;
		margin: 4px 2px;
		background: #F5CEC5;
		transition-duration: 0.4s;
		cursor: pointer;
		left: 50%;
		float: right;
	}
	.button:hover{
		background-color: #FAAA96;
	}
</style>
</head>
<body>
	<%@ include file="header.jsp" %>
		<h2>Customer Profile
		<a href=index.jsp><button class="button">Main Menu &#127968</button></a>
		<a href=showcart.jsp><button class="button">Your Cart &#128722</button></a>
		<a href=logout.jsp><button class='button'>Log out &#9940</button></a>
		</h2>
		<br>

<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%
// Make connection

// Write query to retrieve all order summary records
NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);

try {
	String SQL = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid "
				+"FROM Customer"
				+" WHERE userid = ?";
	getConnection();
	PreparedStatement pstmt = con.prepareStatement(SQL);
	pstmt.setString(1, userName);	
	ResultSet rst = pstmt.executeQuery();

	int customerId = 0;

	if (rst.next())
	{
		customerId = rst.getInt(1);
		if(request.getParameter("edit") == null){
			out.println("<table>");
			out.println("<tr><td class='tableheader'>Id</td><td align='center'>"+customerId+"</td></tr>");	
			out.println("<tr><td class='tableheader'>First Name</td><td align='center'> "+rst.getString(2)+"</td></tr>");
			out.println("<tr><td class='tableheader'>Last Name</td><td align='center'>"+rst.getString(3)+"</td></tr>");
			out.println("<tr><td class='tableheader'>Email</td><td align='center'>"+rst.getString(4)+"</td></tr>");
			out.println("<tr><td class='tableheader'>Phone</td><td align='center'>"+rst.getString(5)+"</td></tr>");
			out.println("<tr><td class='tableheader'>Address</td><td align='center'>"+rst.getString(6)+"</td></tr>");
			out.println("<tr><td class='tableheader'>City</td><td align='center'>"+rst.getString(7)+"</td></tr>");
			out.println("<tr><td class='tableheader'>State</td><td align='center'>"+rst.getString(8)+"</td></tr>");
			out.println("<tr><td class='tableheader'>Postal Code</td><td align='center'>"+rst.getString(9)+"</td></tr>");
			out.println("<tr><td class='tableheader'>Country</td><td align='center'>"+rst.getString(10)+"</td></tr>");
			out.println("<tr><td class='tableheader'>User id</td><td align='center'>"+rst.getString(11)+"</td></tr>");		
			out.println("</table>");
		}
		else{
			out.println("<table><form method='post' action='updateCustomer.jsp'");
			out.println("<tr><td class='tableheader'>Id</td><td align='center'><input type='text' name='id' value='"+rst.getString(1)+"' readonly></td></tr>");	
			out.println("<tr><td class='tableheader'>First Name</td><td align='center'><input type='text' name='firstName' value='"+rst.getString(2)+"'></td></tr>");
			out.println("<tr><td class='tableheader'>Last Name</td><td align='center'><input type='text' name='lastName' value='"+rst.getString(3)+"'></td></tr>");
			out.println("<tr><td class='tableheader'>Email</td><td align='center'><input type='text' name='email' value='"+rst.getString(4)+"'></td></tr>");
			out.println("<tr><td class='tableheader'>Phone</td><td align='center'><input type='text' name='phoneNumber' value='"+rst.getString(5)+"'></td></tr>");
			out.println("<tr><td class='tableheader'>Address</td><td align='center'><input type='text' name='address' value='"+rst.getString(6)+"'></td></tr>");
			out.println("<tr><td class='tableheader'>City</td><td align='center'><input type='text' name='city' value='"+rst.getString(7)+"'></td></tr>");
			out.println("<tr><td class='tableheader'>State</td><td align='center'><input type='text' name='state' value='"+rst.getString(8)+"'></td></tr>");
			out.println("<tr><td class='tableheader'>Postal Code</td><td align='center'><input type='text' name='postalCode' value='"+rst.getString(9)+"'></td></tr>");
			out.println("<tr><td class='tableheader'>Country</td><td align='center'><input type='text' name='country' value='"+rst.getString(10)+"'></td></tr>");
			out.println("<tr><td class='tableheader'>User id</td><td align='center'><input type='text' name='username' name='id' value='"+rst.getString(11)+"'></td></tr>");		
			out.println("<tr><td class='tableheader'><input type=submit val='submit'></td></tr></form></table>");
			out.println("<h2><a href='logout.jsp'><button class='button'>Log out &#9940</button></a></h2>");
		}
	}
	out.println("<h2>Order History</h2>");
	String sql_2 = "SELECT OS.orderId, OS.orderDate, OS.totalAmount "
				+ " FROM orderSummary OS"
				+ " WHERE OS.customerId = ?";
	String sql_3 = "SELECT OP.productId, OP.quantity, OP.price "
				+ " FROM orderSummary OS JOIN orderProduct OP ON OS.orderId = OP.orderId "
				+ " WHERE OS.customerId = ?";
	PreparedStatement pstmt_2 = con.prepareStatement(sql_2);
	pstmt_2.setInt(1, customerId);	
	ResultSet rst_2 = pstmt_2.executeQuery();

	PreparedStatement pstmt_3 = con.prepareStatement(sql_3);
	pstmt_3.setInt(1, customerId);	
	ResultSet rst_3 = pstmt_3.executeQuery();
	if(rst_2.next())
	{
		out.println("<table><tr><td class='tableheader'>Order Id</td><td class='tableheader'>Order Date</td><td class='tableheader'>Total Amount</td></tr>");
		out.println("<tr><td align='center'>"+rst_2.getInt("orderId")+"</td><td align='center'>"+rst_2.getDate("orderDate")+"</td><td align='center'>"+currFormat.format(rst_2.getDouble("totalAmount"))+ "</td></tr>");
		out.println("<tr><td colspan=3 align='right'><table style='width: 35%;'>");
		out.println("<tr><td class='tableheader'>Product Id</td><td class='tableheader'>Quantity</td><td class='tableheader'>Price</td></tr>");
		while(rst_3.next())
		   out.println("<tr><td align='center'>"+rst_3.getInt("productId")+"</td><td align='center'>"+rst_3.getInt("quantity")+"</td><td align='center'>"+currFormat.format(rst_3.getDouble("price"))+"</td></tr>");
		out.println("</table></td></tr>");
		out.println("</table>");
	} 
	else
		out.println("<p style='font-weight: bold;'>No order history.</p>");
	
}
catch (SQLException ex) {
	out.println(ex); 
}
finally {	
	closeConnection();	
}
// Make sure to close connection
%>

</body>
</html>