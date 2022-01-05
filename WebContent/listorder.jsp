<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="authAdmin.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>Konbini Grocery Order List</title>
    <style>
            @font-face{
                font-family: customFont;
                src: url(NikkyouSans-mLKax.ttf);
            }
			h2{
				text-align: left;
				font-family: customFont;
				font-size: 30px;
				padding: 0px;
			}
			table{
				width: 100%;
			}
			table, td{
				border: 1px solid #7E8193;
			}
            td{
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
				text-align:center;
				font-weight: bold;
				padding: 6px;
				margin: 4px 2px;
				background: #F5CEC5;
				transition-duration: 0.4s;
				cursor: pointer;
				float:right;
			}
			.button:hover{
				background-color: #FAAA96;
			}
    </style>
</head>
<body>
<%@ include file="header.jsp" %>
	<h2>Order List
		<a href=index.jsp><button class="button">Main Menu &#127968</button></a>
		<a href=admin.jsp><button class="button">Admin Page &#128100</button></a>
	</h2>

<%
//Note: Forces loading of SQL Server driver

// Useful code for formatting currency values:
NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection


// Write query to retrieve all order summary records
try
{
	getConnection();
	String sql_1 = "SELECT OS.orderId, OS.orderDate, C.customerId, C.firstname, C.lastname, OS.totalAmount "
				+ " FROM orderSummary OS JOIN customer C ON OS.customerId = C.customerId";
	String sql_2 = "SELECT OP.productId, OP.quantity, OP.price "
					+ " FROM orderSummary OS JOIN orderProduct OP ON OS.orderId = OP.orderId "
					+ "WHERE OS.orderId = ?";
	PreparedStatement pstmt_1 = con.prepareStatement(sql_1);
	ResultSet rst_1 = pstmt_1.executeQuery();
	out.println("<table><tr><td class='tableheader'>Order Id</td><td class='tableheader'>Order Date</td><td class='tableheader'>Customer Id</td><td class='tableheader'>Customer Name</td><td class='tableheader'>Total Amount</td></tr>");
	while(rst_1.next())
	{
		out.println("<tr><td align='center'>"+rst_1.getInt("orderId")+"</td><td align='center'>"+rst_1.getDate("orderDate")+"</td><td align='center'>"+rst_1.getInt("customerId")+"</td><td align='center'>"+rst_1.getString("firstname")+ " " + rst_1.getString("lastname")+"</td><td align='center'>"+currFormat.format(rst_1.getDouble("totalAmount"))+ "</td></tr>");
		out.println("<tr><td colspan=5 align='right'><table style='width: 35%;'>");
		out.println("<tr><td class='tableheader'>Product Id</td><td class='tableheader'>Quantity</td><td class='tableheader'>Price</td></tr>");
		PreparedStatement pstmt_2 = con.prepareStatement(sql_2);
		pstmt_2.setInt(1,rst_1.getInt("orderId"));
		ResultSet rst_2 = pstmt_2.executeQuery();
		while(rst_2.next())
		   out.println("<tr><td align='center'>"+rst_2.getInt("productId")+"</td><td align='center'>"+rst_2.getInt("quantity")+"</td><td align='center'>"+currFormat.format(rst_2.getDouble("price"))+"</td></tr>");
		out.println("</table></td></tr>");
	}
	out.println("</table>");	
}
catch (Exception e)
{
    out.print(e);
}

// For each order in the ResultSet

	// Print out the order summary information
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
		// Write out product information 

// Close connection
%>

</body>
</html>

