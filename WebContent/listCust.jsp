<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="authAdmin.jsp"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Konbini Grocery Customer List</title>
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
			form{
		        font-family: sans-serif;
		        font-size: 15px;
	        }
			table{
				width: 100%;
				border: 1px solid #7E8193;
				padding: 4px;
			}
            td{
                font-family: sans-serif;
                font-size: 14px;
				text-align: center;
				height: 25px;
				border: 1px solid #7E8193;
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
			.tableheader{
				height: 30px;
				font-size: 18px;
				font-family: customFont;
				text-align: center;
				background-color: #F5CEC5;
			}
			button{
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
			button:hover{
				background-color: #FAAA96;
			}
			input{
		        font-family: sans-serif;
		        font-size: 18px;
		        text-align: center;
		        font-weight: bold;
		        padding: 4px;
		        margin: 2px;
		        transition-duration: 0.4s;
		        cursor: pointer;
		        background: #FCFBF6;
                width: 98%;
	        }
			input:hover {
		        background-color: #F5CEC5;
	        }
    </style>
</head>
<body>
<%@ include file="header.jsp" %>

	<h2>Customer List
		<a href=index.jsp><button >Main Menu &#127968</button></a>
		<a href=admin.jsp><button>Admin Page &#128100</button></a>
	</h2>

	<p>
		&#127800 <a href=register.jsp>Add new customer here</a>
	</p>
	<p>
		&#127800 <a href=listCust.jsp?edit>Edit existing customer here</a>
	</p>

<%
// Write query to retrieve all order summary records
try
{
	getConnection();
	Statement stmt = con.createStatement();
	ResultSet rs = stmt.executeQuery("SELECT * FROM customer");
	ResultSetMetaData metaData = rs.getMetaData();
	if(request.getParameter("edit") != null){
		out.println("<form class='register' method='get' action='updateCustomer.jsp'>");
		out.println("<table>");
		for(int i = 1; i<=metaData.getColumnCount()-2; i++) { // -2, changing user's username/password is diabled
			out.println("<tr><td class='tableheader' name='"+metaData.getColumnName(i)+"'>"+metaData.getColumnName(i)+"</td>");
			out.println("<td><input name='"+metaData.getColumnName(i)+"'</td>");
			out.println("</tr>");
		}
		out.println("<tr><td colspan=2><input type='submit' value='Submit'></td></tr>");
		out.println("</table>");
		out.println("</form>");
		out.println("<br><br><br>");
	}

	String SQL = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userId FROM customer";
	PreparedStatement pst = con.prepareStatement(SQL);
	ResultSet rst = pst.executeQuery();
	ResultSetMetaData rstmd = rst.getMetaData();

	out.println("<table><tr>");
		for(int i = 1; i<12; i++) {
			out.println("<td class='tableheader'>"+rstmd.getColumnName(i)+"</td>");
		}
	out.println("</tr>");

	while(rst.next()){
		out.println("<tr>");
		for(int i = 1; i<12; i++) {
			out.println("<td>"+rst.getString(i)+"</td>");
		}
		out.println("</tr>");
	}
	out.println("</table><br>");
	
}
catch (Exception e)
{
    out.print("<p style='color:red'>"+e+"</p>");
	out.println("<a href='listCust.jsp'><button style='float:left'>Retry</button></a>");
}
finally
{	
	closeConnection();	
}
// Close connection
%>

</body>
</html>

