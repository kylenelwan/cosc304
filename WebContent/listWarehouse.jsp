<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Konbini Grocery Warehouse List</title>
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
			table{
				width: 100%;
				border: 1px solid #7E8193;
				padding: 4px;
			}
            td{
                font-family: sans-serif;
                font-size: 14px;
                font-weight: bold;
				height: 25px;
				border: 1px solid #7E8193;
            }
			p{
				font-family:sans-serif;
				font-size: 25px;
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
			.tableheader{
				height: 30px;
				font-size: 18px;
				font-family: customFont;
				text-align: center;
				background-color: #F5CEC5;
			}
			button, input, .input2{
				font-family: sans-serif;
				font-size: 18px;
				text-align:center;
				font-weight: bold;
				padding: 6px;
				margin: 4px 2px;
				background: #F5CEC5;
				transition-duration: 0.4s;
				cursor: pointer;
			}
			button:hover, input:hover, .input2:hover{
				background-color: #FAAA96;
			}
            .input2{
                font-size: 18px;
				float:right
				;
            }
			input{
				font-size: 15px;
				padding: 4px;
				background: #FCFBF6;
			}
    </style>
</head>
<body>
<%@ include file="header.jsp" %>

	<h2>Warehouse List
		<a href=index.jsp><button style='float:right'>Main Menu &#127968</button></a>
		<a href=admin.jsp><button style='float:right'>Admin Page &#128100</button></a>
	</h2>

<%
// Write query to retrieve all order summary records
try
{
	getConnection();
	String SQL = "SELECT warehouseId, warehouseName FROM warehouse";
	PreparedStatement pst = con.prepareStatement(SQL);
	ResultSet rst = pst.executeQuery();
	ResultSetMetaData rstmd = rst.getMetaData();

	out.println("<table><tr>");
		for(int i = 1; i<3; i++) {
			out.println("<td class='tableheader'>"+rstmd.getColumnName(i)+"</td>");
		}
	out.println("</tr>");

	while(rst.next()){
		out.println("<tr>");
		for(int i = 1; i<3; i++) {
			out.println("<td>"+rst.getString(i)+"</td>");
		}
		out.println("</tr>");
	}
	out.println("</table><br>");

    out.println("<hr>");

    out.println("<h2>Update Warehouse</h2>");
	out.println("<form method='get' action='updateWarehouse.jsp'>");
		out.println("<table style='width:auto'>");
		out.println("<tr><td>Warehouse ID:</td><td><input type='text' name='warehouseId' size='20'></td></tr>");
        out.println("<tr><td>Warehouse Name:</td><td><input type='text' name='warehouseName' size='20'></td></tr>");
		out.println("<tr><td colspan=2><input class='input2' type='submit' value='Submit'></td></tr>");
		out.println("</table>");
	out.println("</form>");

    out.println("<br><hr>");

    out.println("<h2>Add New Warehouse</h2>");
	out.println("<form method='get' action='addWarehouse.jsp'>");
		out.println("<table style='width:auto'>");
		out.println("<tr><td>Warehouse Name:</td><td><input type='text' name='warehouseName' size='20'></td></tr>");
		out.println("<tr><td colspan=2><input class='input2' type='submit' value='Submit'></td></tr>");
		out.println("</table>");
	out.println("</form>");
	
	out.println("<br>");
}
catch (Exception e)
{
    out.print("<h3 style='color:red'>"+e+"</h3>");
}
finally
{	
	closeConnection();	
}
// Close connection
%>

</body>
</html>