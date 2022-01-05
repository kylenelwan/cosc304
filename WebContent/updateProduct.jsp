<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="authAdmin.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>Update Product</title>
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
		<h2>Update Product: Status
			<a href=index.jsp><button style='float:right'>Main Menu &#127968</button></a>
			<a href=admin.jsp><button style='float:right'>Admin Page &#128100</button></a>
		</h2>
		<%-- <p>
			&#127800<a href=listprod.jsp>List Products</a>
		</p>
		<p>
			&#127800<a href=addProduct.jsp>Add Product</a>
		</p> --%>
		<br>
<%
// Write query to retrieve all order summary records
int check = 0;
try
{
	getConnection();
	int id = Integer.parseInt(request.getParameter("productId"));
	String prodName = request.getParameter("productName");
	double prodPrice = Double.parseDouble(request.getParameter("productPrice"));
	String prodDesc = request.getParameter("productDesc");
	int categoryId = Integer.parseInt(request.getParameter("categoryId"));

	String SQL = "UPDATE product SET productName = ?, productPrice = ?, productDesc = ?, categoryId = ? WHERE productId = ?";

	PreparedStatement pst = con.prepareStatement(SQL);
	pst.setString(1,prodName); 
	pst.setDouble(2,prodPrice);
	pst.setString(3,prodDesc);
	pst.setInt(4,categoryId);
	pst.setInt(5,id);

	check = pst.executeUpdate();
}
catch (Exception e)
{
    out.print("<h3 style='color: red;'>"+e+"</h3>");
}
finally
{	
	closeConnection();
	if(check >0) {
		out.println("<h3 style='color: darkgreen;'>Product updated.</h3>");
		out.println("<h3><a href='listprod.jsp'><button style='float:center'>List Product</button></a></h3>");
		out.println("<h3><a href='addProduct.jsp'><button style='float:center'>Go Back</button></a></h3>");
	}
	else {
		out.println("<h3 style='color: red;'>Failed to update product.</h3>");
		out.println("<h3><a href='addProduct.jsp'><button style='float:center'>Retry</button></a></h3>");
	}
}
// Close connection
%>

</body>
</html>
