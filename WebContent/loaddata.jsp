<%@ page import="java.sql.*" %>
<%@ page import="java.util.Scanner" %>
<%@ page import="java.io.File" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Load data</title>
<style>
    @font-face{
        font-family: customFont;
        src: url(NikkyouSans-mLKax.ttf);
    }
    h1{
        text-align: center;
        font-family: customFont;
        font-size: 50px;
        padding: 10px 16px;
    }
    h3{
		text-align: center;
		font-family: sans-serif;
		font-size: 20px;
		padding: 4px;
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
		left: 50%;
	}
	button:hover{
		background-color: #FAAA96;
	}
</style>
</head>
<body>
<%@ include file="header.jsp" %>
<%

out.print("<h1 style='color:darkgreen'>Connecting to database.</h1><br><br>");

String fileName = "/usr/local/tomcat/webapps/shop/orderdb_sql.ddl";

try
{
    getConnection();
    // Create statement
    Statement stmt = con.createStatement();
    
    Scanner scanner = new Scanner(new File(fileName));
    // Read commands separated by ;
    scanner.useDelimiter(";");
    while (scanner.hasNext())
    {
        String command = scanner.next();
        if (command.trim().equals(""))
            continue;
        // out.print(command);        // Uncomment if want to see commands executed
        try
        {
            stmt.execute(command);
        }
        catch (Exception e)
        {	// Keep running on exception.  This is mostly for DROP TABLE if table does not exist.
            out.print("<h3 style='color:red'>"+e+"</h3>");
        }
    }	 
    scanner.close();
    
    out.print("<br><br><h1 style='color:darkgreen'>Database loaded.</h1>");
}
catch (Exception e)
{
    out.print("<h3 style='color:red'>"+e+"</h3>");
}
finally
{	
	closeConnection();	
}  
%>
<h3>
    <a href=index.jsp><button><b>Main Page &#127968</b></button></a>
    <a href=admin.jsp><button><b>Admin Page &#128100</b></button></a>
</h3>


</body>
</html> 
