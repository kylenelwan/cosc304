<%
// remember to include jdbc.jsp before using this file!
String userid = (String) session.getAttribute("authenticatedUser");
	try
	{
		getConnection();

		PreparedStatement pstmt = con.prepareStatement("SELECT userid FROM admin WHERE userid = ?");
		pstmt.setString(1, userid);

		ResultSet rs = pstmt.executeQuery();
		if(!rs.next())
		{
			String loginMessage = "You have not been authorized to access the URL "+request.getRequestURL().toString();
			session.setAttribute("loginMessage",loginMessage);        
			response.sendRedirect("login.jsp");
		}
	}
	catch(SQLException e){
		out.println(e);
	}
	finally{
		closeConnection();
	}
%>