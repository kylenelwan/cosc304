<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Your Shopping Cart</title>
<script>
	function updateQty(newid, newqty) {
	  window.location = "showcart.jsp?update="+newid+"&newQty="+ newqty;
	}
</script>
<style>
	@font-face{
		font-family: customFont;
		src: url(NikkyouSans-mLKax.ttf);
	}
	h1{
		text-align: center;
		font-family: customFont;
		font-size: 40px;
		padding: 4px;
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
		font-size: 18px;
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
		font-weight: bold;
		padding: 6px;
		margin: 4px 2px;
		background: #F5CEC5;
		transition-duration: 0.4s;
		cursor: pointer;
		float: right;
	}
	.button2{
		padding: 4px;
		margin: 2px;
		font-size: 15px;
		text-align: center;
		font-weight: bold;
		float: center;
		background: #F5CEC5;
		transition-duration: 0.4s;
		cursor: pointer;
	}
	.button:hover, .button2:hover{
		background-color: #FAAA96;
	}
</style>
</head>
<body>
<%@ include file="header.jsp" %>

<h2>Your Shopping Cart &#128722
	<a href=index.jsp><button class='button'>Main Menu &#127968</button></a>
</h2>

<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{	out.println("<h3 style='color: red;'>Your shopping cart is empty!</h3>");
	out.println("<h3><a href=listprod.jsp><button class='button'>Begin Shopping 🛍 </button></a></h3>");
	productList = new HashMap<String, ArrayList<Object>>();
}
else
{
	try{
		String delId = request.getParameter("delete");
		if(delId != null && productList.containsKey(delId)){
			productList.remove(delId);
		}
		String updateId = request.getParameter("update");
		if(updateId != null && productList.containsKey(updateId)){
			String newQty = request.getParameter("newQty");
			int updateQty = Integer.parseInt(newQty);
			if(updateQty > 0){
				ArrayList<Object> temp = new ArrayList<>(productList.get(updateId));
				temp.set(3, updateQty);
				productList.put(updateId, temp);
			}
			else if(updateQty == 0)
				out.println("<h3 style='color:red;'>Please select 'remove item from cart' to update quantity to 0.</h3>");
			else
				out.println("<h3 style='color:red;'>Please enter a positive integer.</h3>");
		}
	}catch(NumberFormatException e){
		out.println("<h3 style='color:red;'>Update quantity is not an integer. input a correct number.</h3>");
	}

	NumberFormat currFormat = NumberFormat.getCurrencyInstance(Locale.US);

	out.println("<table><tr><td class='tableheader'>Product Id</td><td class='tableheader'>Product Name</td><td class='tableheader'>Quantity</td>");
	out.println("<td class='tableheader'>Update Quantity</td><td class='tableheader'>Remove Item 🗑</td>");
	out.println("<td class='tableheader'>Price</td><td class='tableheader'>Subtotal</td></tr>");

	double total =0;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext()) 
	{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		if (product.size() < 4)
		{
			out.println("<h3 style='color:red;'>Expected product with four entries. Got: "+product+"</h3>");
			continue;
		}
		
		out.print("<tr><td>"+product.get(0)+"</td>");
		out.print("<td>"+product.get(1)+"</td>");

		//out.print("<td>"+product.get(3)+"</td>");
		Object price = product.get(2);
		Object itemqty = product.get(3);
		double pr = 0;
		int qty = 0;
		
		try
		{
			pr = Double.parseDouble(price.toString());
		}
		catch (Exception e)
		{
			out.println("<h3 style='color:red;'>Invalid price for product: "+product.get(0)+" price: "+price+"</h3>");
		}
		try
		{
			qty = Integer.parseInt(itemqty.toString());
		}
		catch (Exception e)
		{
			out.println("<h3 style='color:red;'>Invalid quantity for product: "+product.get(0)+" quantity: "+qty+"</h3>");
		}		

		String tempId = "\"newqty"+product.get(0)+"\"";
		out.print("<td><input type=\"number\" id="+ tempId +" size=\"3\" value="+itemqty+"></td>");
		out.print("<td><input type='button' onclick='updateQty("+product.get(0)+", document.getElementById("+tempId+").value)' value='Update Quantity'></td>");
		out.print("<td><a href='showcart.jsp?delete="+ product.get(0) +"'><button class='button2'>🗑</button></a></td>");
		out.print("<td>"+currFormat.format(pr)+"</td>");
		out.print("<td>"+currFormat.format(pr*qty)+"</td></tr>");
		out.println("</tr></tr>");
		total = total +pr*qty;
	}
	out.println("<tr><td colspan='6' style='text-align: right;' class='tableheader'>Order Total</td>"
			+"<td style='font-size: 18px;'><b>"+currFormat.format(total)+"</b></td></tr>");
	out.println("</table>");

	out.println("<a href=\"checkout.jsp\"><button class='button'>Check Out &#128718</button></a>");
	out.println("<a href='listprod.jsp'><button class='button'>Continue Shopping 🛍 </button></a>");
}
// set the shopping cart
session.setAttribute("productList", productList);
%>

</body>
</html> 

