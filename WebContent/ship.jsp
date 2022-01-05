<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="authAdmin.jsp"%>

<html>
<head>
<title>Konbini Grocery Shipment Processing</title>
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
		text-align: center;
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
	.tab {
        display: inline-block;
        margin-left: 40px;
    }
</style>
</head>
<body>
	<%@ include file="header.jsp" %>

	<h2>Add Shipment
		<a href=index.jsp><button style='float:right'>Main Menu &#127968</button></a>
		<a href=admin.jsp><button style='float:right'>Admin Page &#128100</button></a>
	</h2>
	<p style='text-align: left;'>
		&#127800<a href=listShipment.jsp>Shipment Page</a>
	</p>
	<br>
<%
	try{
		getConnection();
		Statement stmt = con.createStatement();
		// TODO: Get order id
		String orderId = request.getParameter("orderId");
		String desc = request.getParameter("shipmentDesc");
		
		// TODO: Check if valid order id
		int id = -1;
		try{
			id = Integer.parseInt(orderId);
		}
		catch(Exception e){
			out.println("<h3 style='color:red;'>Invalid order ID: " + orderId + "</h3>");
			out.println("<h3><a href='listShipment.jsp'><button style='float:center'>Retry</button></a></h3>");
		}
		// TODO: Start a transaction (turn-off auto-commit)
		con.setAutoCommit(false);
		
		// TODO: Retrieve all items in order with given id
		String sql = "SELECT * FROM orderproduct WHERE orderId = ?";
		PreparedStatement pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, id);
		ResultSet rs = pstmt.executeQuery();
		String sql_insert = "INSERT INTO shipment (shipmentDate, warehouseId, shipmentDesc) VALUES (?, 1, ?)";
		pstmt = con.prepareStatement(sql_insert);
		boolean success = false;
		int productId = -1;
		int productQty = -1;
		out.println("<p>PROCESSING SHIPMENT FOR ORDER ID: "+orderId+"</p>");
		while(rs.next()){
			productId = rs.getInt("productId");
			productQty = rs.getInt("quantity");
			// TODO: Create a new shipment record.
			pstmt = con.prepareStatement(sql_insert, Statement.RETURN_GENERATED_KEYS);
			java.util.Date utilDate = new java.util.Date();
    		java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
			pstmt.setDate(1, sqlDate);
			pstmt.setString(2, desc);
			pstmt.executeUpdate();
			ResultSet keys = pstmt.getGeneratedKeys();
			keys.next();
			int shipmentId = keys.getInt(1);
			// TODO: For each item verify sufficient quantity available in warehouse 1.
			sql = "SELECT quantity FROM productinventory WHERE productId = ? AND warehouseId = 1";
			PreparedStatement pstmt1 = con.prepareStatement(sql);
			pstmt1.setInt(1, productId);
			ResultSet rs1 = pstmt1.executeQuery();
			int inven_qty = 0;
			if(rs1.next())
				inven_qty = rs1.getInt("quantity");
			
			if(inven_qty >= productQty){
				int newInvenQty = inven_qty - productQty;
				pstmt = con.prepareStatement("UPDATE productinventory SET quantity = ? WHERE productId = ? AND warehouseId = 1");
				pstmt.setInt(1, newInvenQty);
				pstmt.setInt(2, productId);
				pstmt.executeUpdate();
				// print out productinventory summary
				out.println("<p>Ordered product: "+productId + "<br>Quantity: " + productQty);
				ResultSet qtyRs = stmt.executeQuery("SELECT quantity FROM productinventory WHERE productId = "+productId+" AND warehouseId = 1");
				qtyRs.next();
				int newQty = qtyRs.getInt("quantity");
				out.print("<br>Old inventory: "+ inven_qty);
				out.println("<span class='tab'> New inventory: " + newQty + "</span></p>");
				success = true;
			}
			else{
				// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
				success = false;
				break;
			}
		}
		if(success){
			con.commit();
			out.println("<h3 style='color: darkgreen;'>Shipment successfully processed.</h3>");
			out.println("<h3><a href='listShipment.jsp'><button style='float:center'>Back</button></a></h3>");
		}
		else{
			con.rollback();
			out.println("<h3 style='color:red;'>Shipment is not done.</h3><p>Insufficient inventory for product ID: "+productId+"</p>");
			out.println("<h3><a href='listShipment.jsp'><button style='float:center'>Retry</button></a></h3>");
		}
		// TODO: Auto-commit should be turned back on
		con.setAutoCommit(true);
	}
	catch(SQLException e){
		out.print("<h3 style='color:red'>"+e+"</h3>");
		out.println("<h3><a href='listShipment.jsp'><button style='float:center'>Retry</button></a></h3>");
		con.rollback();
	}
	finally
	{
		try
		{
			if (con != null)
				con.close();
		}
		catch (SQLException e)
		{
			out.print("<h3 style='color:red'>"+e+"</h3>");
			out.println("<h3><a href='listShipment.jsp'><button style='float:center'>Retry</button></a></h3>");
		}
	} 
%>                       				

</body>
</html>
