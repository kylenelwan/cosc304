<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="authAdmin.jsp"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
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
				padding: 4px;
			}
			table{
				width: 100%;
				padding: 4px;
			}
			table, td{
				border: 1px solid #7E8193;
			}
            td{
                font-family: sans-serif;
                font-size: 14px;
				height: 25px;
				text-align: center;
				width:fit-content;
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

	<h2>Inventory List
		<a href=index.jsp><button style='float:right'>Main Menu &#127968</button></a>
		<a href=admin.jsp><button style='float:right'>Admin Page &#128100</button></a>
	</h2>
	<p>
		&#127800<a href=updateInventory.jsp>Update inventory here</a>
	</p>
<%
//Note: Forces loading of SQL Server driver

// Useful code for formatting currency values:
NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);
// out.println(currFormat.format(5.0);  // Prints $5.00

// Write query to retrieve all order summary records
try
{
	getConnection();
	Statement stmt = con.createStatement();
	ResultSet warehouseIds = stmt.executeQuery("SELECT warehouseId FROM warehouse");
	String id = (String)request.getParameter("warehouseId");
	//if(id == null){
		out.println("<form method=post action='listInventory.jsp'>");
		out.println("<label for='warehouseId'>Select warehouse ID:</label>");
		out.println("<select name='warehouseId'>");
		while(warehouseIds.next()){
			int temp_id = warehouseIds.getInt(1);
			out.println("<option value='" + temp_id + "'" + temp_id+ "</option>");
			out.println(warehouseIds.getString(1));
		}
		out.println("</select><input type='submit'>");
		out.println("</form>");

	//}
	//else{
	if (id != null){
		int warehouse = Integer.parseInt(id);
		String SQL = "SELECT I.productId, P.productName, I.quantity, I.price FROM productInventory I JOIN product P ON I.productId = P.productId WHERE warehouseId = ?";
		PreparedStatement pst = con.prepareStatement(SQL);
		pst.setInt(1,warehouse);
		ResultSet rst = pst.executeQuery();
		ResultSetMetaData rstmd = rst.getMetaData();

		out.println("<table><tr>");
			for(int i = 1; i<5; i++) {
				out.println("<td class='tableheader'>"+rstmd.getColumnName(i)+"</td>");
			}
		out.println("</tr>");

		while(rst.next()){
			out.println("<tr>");
			for(int i = 1; i<5; i++) {
				if (i==4){
					out.println("<td>"+currFormat.format(rst.getDouble(i))+"</td>");
				}
				else 
					out.println("<td>"+rst.getString(i)+"</td>");
			}
			out.println("</tr>");
		}
		out.println("</table><br>");
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

