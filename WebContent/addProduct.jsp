<%@ include file="authAdmin.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<title>Add and Update Product</title>
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
			float:right;
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

	<h2>Add or Update Products
		<a href=index.jsp><button>Main Menu &#127968</button></a>
		<a href=admin.jsp><button>Admin Page &#128100</button></a>
	</h2>


	<p>
		&#127800<a href=listprod.jsp>List Products</a>
	</p>

	<form method='post' action='addProduct.jsp?add&#status'>
	<table>
	<tr><td>Product Name:</td><td><input type='text' name='productName' size='20'></td></tr>
	<tr><td>Product Price:</td><td><input type='text' name='productPrice' size='20'></td></tr>
	<tr><td>Product Description:</td><td><input type='text' name='productDesc' size='20'></td></tr>
	<tr><td>Category ID:</td><td><input type='text' name='categoryId' size='20'></td></tr>
	<tr><td>Product ID:</td><td><input type='text' name='productId' size='20'></td></tr>
	<tr><td colspan=2>(enter product ID to update existing product)</td></tr>
	<tr><td>Warehouse ID:</td><td><input type='text' name='warehouseId' size='20'></td></tr>
	<tr><td>Quantity:</td><td><input type='text' name='quantity' size='20'></td></tr>
	<tr><td colspan=2>(enter warehouse ID and Quantity to update existing product)</td></tr>
	<tr><td colspan=2><input type='submit' value='Add Product'> <input type='submit' value='Update Product' formaction="updateProduct.jsp"></td></tr>
	</table>
	</form>
	<br>

	
<%
if(request.getParameter("add") != null){
	// Write query to retrieve all order summary records
	int check = 0;
	try
	{
		getConnection();
		String prodName = request.getParameter("productName");
		double prodPrice = Double.parseDouble(request.getParameter("productPrice"));
		String prodDesc = request.getParameter("productDesc");
		int categoryId = Integer.parseInt(request.getParameter("categoryId"));
		int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
		int quantity = Integer.parseInt(request.getParameter("quantity"));

		String SQL_1 = "INSERT INTO product (productName, productPrice, productDesc, categoryId) VALUES (?,?,?,?)";

		PreparedStatement pst_1 = con.prepareStatement(SQL_1);
		pst_1.setString(1,prodName);
		pst_1.setDouble(2,prodPrice);
		pst_1.setString(3,prodDesc);
		pst_1.setInt(4,categoryId);
		pst_1.executeUpdate();

		String SQL_2 = "SELECT productId FROM product WHERE productName = ?";
		PreparedStatement pst_2 = con.prepareStatement(SQL_2);
		pst_2.setString(1,prodName);
		ResultSet rst = pst_2.executeQuery();

		int pid = 0;
		while(rst.next()){
			pid = Integer.parseInt(rst.getString(1));
		}

		String SQL_3 = "INSERT INTO productinventory (productId, warehouseId, quantity,price) VALUES (?,?,?,?)";
		PreparedStatement pst_3 = con.prepareStatement(SQL_3);
		pst_3.setInt(1,pid);
		pst_3.setInt(2,warehouseId);
		pst_3.setInt(3,quantity);
		pst_3.setDouble(4,prodPrice);

		check = pst_3.executeUpdate();

	}
	catch (Exception e)
	{
		out.print("<h3 style='color: red;'>"+e+"</h3>");
	}
	finally
	{	
		closeConnection();
		if(check >0) out.println("<h3 id='status' style='color: darkgreen;'>New product added.</h3>");
		else out.println("<h3 id='status' style='color: red;'>Failed to add product.</h3>");	
	}
	// Close connection
}
%>

</body>
</html>
