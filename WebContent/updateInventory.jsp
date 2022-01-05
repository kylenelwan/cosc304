<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="authAdmin.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>Update Inventory</title>
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
		p{
			font-family:sans-serif;
			font-size: 18px;
			text-align: left;
			font-weight: bold;
			padding: 4px;
		}
		a{
        	color: black;
    	}
    	a:hover{
        	color:#FAAA96;
    	}
		form{
			font-family: sans-serif;
			font-size: 15px;
		}
		table{
			width: auto;
			padding: 4px;
		}
		table, td{
			border: 1px solid #7E8193;
		}
        td{
            font-family: sans-serif;
            font-size: 14px;
			font-weight: bold;
			height: 25px;
			text-align: center;
        }
		.tableheader{
			height: 30px;
			font-size: 18px;
			font-family: customFont;
			text-align: center;
			background-color: #F5CEC5;
		}
		button, input{
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
		input{
			font-size: 15px;
			padding: 4px;
			background: #FCFBF6;
		}
		button:hover, input:hover{
			background-color: #FAAA96;
		}
	</style>
</head>
<body>
	<%@ include file="header.jsp" %>
		<h2>Update Inventory
			<a href=index.jsp><button style='float:right'>Main Menu &#127968</button></a>
			<a href=admin.jsp><button style='float:right'>Admin Page &#128100</button></a>
		</h2>
		<p>
			&#127800<a href=listInventory.jsp>Inventory List</a>
		</p>
		<br>
<%

try
{
	getConnection();
	Statement stmt = con.createStatement();
	ResultSet warehouseIds = stmt.executeQuery("SELECT warehouseId FROM warehouse");
	if(request.getParameter("warehouseId") == null){
		out.println("<form method=post action='updateInventory.jsp'>");
		out.println("<table>");
		out.println("<tr><td><label for='warehouseId'>Select warehouse ID: </label></td>");
		out.println("<td><select name='warehouseId'>");
		while(warehouseIds.next()){
			int temp_id = warehouseIds.getInt(1);
			out.println("<option value='" + temp_id + "'" + temp_id+ "</option>");
			out.println(warehouseIds.getString(1));
		}
		out.println("</select></td></tr>");
		out.println("<tr><td>");
		out.println("<label for='productId'>Product ID: </label></td>");
		out.println("<td><input name='productId'/>");
		out.println("</tr></td>");
		out.println("<tr><td>");
		out.println("<label for='newQty'>New Quantity: </label></td>");
		out.println("<td><input name='newQty'/>");
		out.println("</tr></td>");
		// out.println("<tr><td>");
		// out.println("<label for='newPrice'>New Price: </label></td>");
		// out.println("<td><input name='newPrice'/></td>");
		// out.println("</tr></td>");
		out.println("<tr><td colspan=2><input type='submit'></tr></td>");
		out.println("</table>");
		out.println("</form>");
	}else{
		int wid = Integer.parseInt(request.getParameter("warehouseId"));
		int pid = Integer.parseInt(request.getParameter("productId"));
		int quantity = Integer.parseInt(request.getParameter("newQty"));
		// double price = Double.parseDouble(request.getParameter("newPrice"));

		String SQL = "UPDATE productInventory SET quantity = ? WHERE productId = ? AND warehouseId = ?";

		PreparedStatement pst = con.prepareStatement(SQL);
		pst.setInt(1,quantity); 
		// pst.setDouble(2,price); 
		pst.setInt(2,pid);
		pst.setInt(3,wid);

		int check = pst.executeUpdate();
		if(check >0) {
			out.println("<h3 style='color: darkgreen;'>Product inventory in warehouse updated.</h3>");
		}
		else out.println("<h3 style='color: red;'>Failed to update product inventory in warehouse.</h3>");
	}
}
catch (Exception e)
{
    out.print("<h3 style='color:red'>"+e+"</h3>");
	out.println("<h3><a href='updateInventory.jsp'><button style='float:center'>Retry</button></a></h3>");
}
finally
{	
	closeConnection();	
}

// Close connection
%>

</body>
</html>
