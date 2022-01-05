<%@ include file="auth.jsp"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<title>Add review</title>
</head>
<body>
<%
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}


// Make connection
String url = "jdbc:sqlserver://db:1433;DatabaseName=tempdb;";
String uid = "SA";
String pw = "YourStrong@Passw0rd";

// Write query to retrieve all order summary records
try (Connection con = DriverManager.getConnection(url, uid, pw);
		Statement stmt = con.createStatement();)
{
	int rating = Integer.parseInt(request.getParameter("productRating"));
	int cid = Integer.parseInt(request.getParameter("customerId"));
	int pid = Integer.parseInt(request.getParameter("productId"));
	String comment = request.getParameter("review");
	  
	String SQL = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?,?,?,?,?)";

	PreparedStatement pst = con.prepareStatement(SQL);
	pst.setInt(1,rating);
	LocalDateTime now = LocalDateTime.now(); pst.setTimestamp(2, java.sql.Timestamp.valueOf(now));
	pst.setInt(3,cid);
	pst.setInt(4,pid);
	pst.setString(5,comment);

	int check = pst.executeUpdate();

	if(check >0) {session.setAttribute("reviewStatus", "new review added"); response.sendRedirect("product.jsp?id=" + pid + "#reviewStatus");}
	else out.println("failed to add review");
}
catch (Exception e)
{
    out.print(e);
}



// Close connection
%>

</body>
</html>
