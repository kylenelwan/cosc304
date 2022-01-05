<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%-- <%@ include file="jdbc.jsp" %> --%>
<%@ include file="auth.jsp"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>List Review</title>
    <style>
            @font-face{
                    font-family: customFont;
                    src: url(NikkyouSans-mLKax.ttf);
            }
			h2{
            	text-align: center;
            	font-family: customFont;
            	font-size: 40px;
            	padding: 4px;
            	color: black;
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
				color: black;
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
				padding: 8px;
				margin: 4px 2px;
				background: #F5CEC5;
				transition-duration: 0.4s;
				cursor: pointer;
			}
			.button:hover{
				background-color: #FAAA96;
			}
			a{
        		color: black;
        		text-decoration: none;
    		}
    		a:hover{
        		color:#FAAA96;
        		text-decoration: none;
    		}
    </style>
</head>
<body>

<h2>Reviews</h2>

<%
// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection

// Write query to retrieve all order summary records
try
{
	getConnection();
	int id = Integer.parseInt(request.getParameter("id"));

	String SQL = "SELECT reviewRating, reviewComment FROM review WHERE productId = ?";
	PreparedStatement pst = con.prepareStatement(SQL);
	pst.setInt(1,id);
	ResultSet rst = pst.executeQuery();

	out.println("<table><tr><td class='tableheader'>Rating</td><td class='tableheader'>Comments</td></tr>");
	int numOfReviews = 0;
	while(rst.next()){
		out.println("<tr><td>"+rst.getInt(1)+"</td><td>"+rst.getString(2)+"</td></tr>");
		numOfReviews++;
	}
	if(numOfReviews == 0){
		out.println("<tr><td colspan=2>There are no reviews currently on this product. Be the first to <a href='product.jsp?id="+id+"&review#reviewBox'><b>review</b></a> this product!</td></tr>");
	}
	out.println("</table>");
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

