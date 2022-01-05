<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>Konbini Grocery - Product Information</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <style>
        @font-face{
            font-family: customFont;
            src: url(NikkyouSans-mLKax.ttf);
        }
        h2, p{
            font-family: customFont;
		    font-size: 25px;
		    text-align: left;
            color: black;
            padding: 4px;
	    }
        .productTitle{
            text-align: left;
        }
        p{
            font-family: sans-serif;
            font-size: 18px;
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
		    text-align: center;
		    height: 25px;
	    }
	    form{
		    font-family: sans-serif;
		    font-size: 15px;
	    }
	    .tableheader{
		    height: 30px;
		    font-size: 18px;
		    font-family: customFont;
		    text-align: center;
		    background-color: #F5CEC5;
	    }
        .button, input, .input2{
            font-family: sans-serif;
            font-size: 18px;
            text-align: center;
            font-weight: bold;
            color:black;
            padding: 6px;
            margin: 2px;
            transition-duration: 0.4s;
            cursor: pointer;
            background: #F5CEC5;
            left: 50%;
        }
        input{
            background: #FCFBF6;
        }
        .button:hover, .input2:hover{
            background-color: #FAAA96;
        }
        input:hover {
		    background-color: #F5CEC5;
	    }
        img{
            margin-left: 2%;
            margin-right: auto;
            width: auto;
            height: 50%;
            display: block;
            float:left;
        }
        .container {
            width:100%;
            height:auto;
            padding:1%;
        }
        div.outerContainer {
            padding: 20px;
            overflow:auto;
        }
    </style>
</head>
<body>
<div class='outerContainer'>
<%@ include file="header.jsp" %>

<%
// Get product name to search for
String productId = request.getParameter("id");
NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);
try 
{
    getConnection();
    // TODO: Retrieve and display info for the product

    String sql = "SELECT productName, productPrice, productDesc, productImage, productImageURL FROM product WHERE ProductId = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, productId);
    ResultSet rst = pstmt.executeQuery();
    while(rst.next()){
        String productName = rst.getString("productName");
	    Double productPrice = rst.getDouble("productPrice");
        String productDesc = rst.getString("productDesc");
        String imageURL = rst.getString("productImageURL");
        String image = rst.getString("productImage");
        String link_image = "displayImage.jsp?id="+productId;
        
        out.println("<div class='container'>");
        out.println("<h2 class='productTitle'>"+productName+"<a href=index.jsp><button class='button' style='float:right'>Main Menu &#127968</button></a></h2>");
        out.println("<p>"+productDesc+"</p>");
        // TODO: If there is a productImageURL, display using IMG tag
        // TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
        if (imageURL != null && image != null){
            out.println("<img src='" + imageURL + "'>");
            out.println("<img src='" + link_image + "'>");
        }
        else if (imageURL != null && image == null){
            out.println("<img src='" + imageURL + "'>");
        }
        else if (imageURL == null && image != null){
            out.println("<img src='" + link_image + "'>");
        }
        
        // TODO: Add links to Add to Cart and Continue Shopping
        String nameEncoded = java.net.URLEncoder.encode(productName, "UTF-8").replace("+","%20");
	    String link = "addcart.jsp?id="+productId+"&name="+nameEncoded+"&price="+productPrice;
        out.println("<p><b>&nbsp&nbsp&nbspProduct ID: </b>"+productId+"</p><p><b>&nbsp&nbsp&nbspPrice: </b>"+currFormat.format(productPrice)+"</p>");
	    out.println("<p>&nbsp&nbsp&nbsp<a href="+link+"><button class='button'>Add to Cart 🛒</button></a>");
        out.println("<a href=listprod.jsp><button class='button'>Continue Shopping 🛍 </button></a></p></div>");
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

out.println("<div class='container'><a id='reviewButton' href='product.jsp?id="+productId+"&review#reviewBox'><button class='button'>Review this product 💬</button></a>");
if(session.getAttribute("reviewStatus") != null){
    out.println("<h4 id='reviewStatus'><b>Your review has been added! Thank you for sharing your experience.</b></h4>");
    session.setAttribute("reviewStatus", null);
}
ArrayList<String> user = (ArrayList<String>) session.getAttribute("user");
if(request.getParameter("review") != null)
{
    if(user != null){
        out.println("<form id='reviewBox' action='addReview.jsp' method=get>");
        out.println("<p><b>&nbspRating(1-5):</b> <input type='tel' name='productRating' pattern=\"[1-5]{1}\" required></p>");
        out.println("<input type='hidden' name='customerId' value ='"+user.get(0)+"' readonly>");
        out.println("<input type='hidden' name='productId' value ='"+productId+"' readonly>");
        out.println("<p><b>&nbspDescription:</b> <input type='text' name='review'></p>");
        out.println("<input class='input2' type='submit'>");
        out.println("</form></div><hr>");
    }
    else{
        response.sendRedirect("login.jsp");
    }
}
%>
<%@ include file='listReview.jsp' %>

</div>
</body>
</html>

