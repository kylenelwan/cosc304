<%@ page language="java" import="java.io.*,java.sql.*,java.util.ArrayList"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		session.setAttribute("authenticatedUser", null);
		session.setAttribute("user", null);
		authenticatedUser = validateLogin(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("index.jsp");		// Successful login
	else
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;
		ArrayList<String> user = new ArrayList<>();

		if(username == null || password == null)
				return null;
		if((username.length() == 0) || (password.length() == 0))
				return null;

		try 
		{
			getConnection();
			String sql = "SELECT * FROM Customer WHERE userId = ? and password = ?";
			PreparedStatement pstmt = con.prepareStatement(sql);			
			pstmt.setString(1, username);
			pstmt.setString(2, password);
			
			ResultSet rst = pstmt.executeQuery();

			if (rst.next()){
				retStr = username; // Login successful
				user.add(rst.getString(1));
				user.add(rst.getString(2));
				user.add(rst.getString(3));
				user.add(rst.getString(4));
				user.add(rst.getString(5));
				user.add(rst.getString(6));
				user.add(rst.getString(7));
				user.add(rst.getString(8));
				user.add(rst.getString(9));
				user.add(rst.getString(10));
				user.add(rst.getString(11));
			}	
		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	
		
		if(retStr != null)
		{	
			session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
			session.setAttribute("user", user);
		}
		else
			session.setAttribute("loginMessage","Could not connect to the system using that username/password.");

		return retStr;
	}
%>