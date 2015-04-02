<%-- 
    Document   : hotels
    Created on : Feb 10, 2015, 12:30:14 PM
    Author     : DB7
--%>
<%
 Object objData = request.getAttribute("hotelList");
 if(objData == null){
     response.sendRedirect("/HotelJPA/HotelController");
 };
 
 String loggedIn;
 String loginField;
 Object user = session.getAttribute("sessionUser");
 if(user == null){
     loginField = " <input type='text' name='sessionName' placeholder='Log In'><input type='submit' name='submit' value='Submit'>";
     loggedIn = "";
 } else {
     loggedIn = "Welcome " + user.toString() + " <a href='HotelController?action=logOut'>(Log Out)</a>";
     loginField = "";
 }
 %>
 
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        
        <link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
        <link href='<%= request.getContextPath() + "/Content/Styles/jquery-ui.theme.css"%>' rel="stylesheet" type="text/css"/>
        <link href='<%= request.getContextPath() + "/Content/Styles/hotels.css"%>' rel="stylesheet" type="text/css"/>
        
        <title>Hotel List</title>
        
    </head>
    
    <body>
        <div class="container">
        <h3>Hotel Directory - Session Count: ${activeSessionCount}</h3>
        <div class='row'>
            <div class='col-md-6'>
                <form method="POST" action='<%= request.getContextPath() + "/HotelController?action=logIn"%>'><%= loginField %><%=loggedIn%></form>
                <br>
                <form method="POST" action='<%= request.getContextPath() + "/HotelController?action=reorder"%>'>
                    Order By:
                    <select name='order'>
                        <option value="hotelId">Hotel ID</option>
                        <option value="hotelName">Hotel Name</option>
                        <option value="city">City</option>
                        <option value="state">State</option>
                    </select>
                    <input type="submit" name="submit" class="btn btn-sm btn-warning" value='Go'>
                </form>
            </div>
            <div class='col-md-6 pull-right'>
                <form method="POST" action='<%= request.getContextPath() + "/HotelController?action=search"%>' class='pull-right'>
                    Search for keyword: <br><input type='text' name='searchTerm' placeholder='Search'><br>in 
                    <select name='searchColumn'>
                        <option value="hotelId" selected>Hotel ID</option>
                        <option value="hotelName">Hotel Name</option>
                        <option value="city">City</option>
                        <option value="state">State</option>
                    </select>
                    <input type="submit" name="submit" class="btn btn-md btn-warning" value='Search'>
                </form>
                <sec:authorize ifAnyGranted="ROLE_ADMIN,ROLE_USER">
                    Logged in as: <sec:authentication property="principal.username"></sec:authentication> ::
                    <a href='<%= this.getServletContext().getContextPath() + "/j_spring_security_logout"%>'>Log Me Out</a>
                </sec:authorize>
            </div>
        </div>
        <div id="tabs">
            <ul>
                <c:forEach var="hotel" items="${hotelList}" varStatus="rowCount">
                    <li><a href="#tabs-${hotel.hotelId}" class="clickableTab">${hotel.hotelName}</a></li>
                </c:forEach>
            </ul>
            <c:forEach var="hotel" items="${hotelList}" varStatus="rowCount">
                <div id="tabs-${hotel.hotelId}">
                        <div id="editHotel">
                            <form id="formSave" name="formSave" method="POST" action='<%= request.getContextPath() + "/HotelController?action=saveHotel"%>'>
                                <table>
                                    <tbody>
                                        <tr>
                                            <td>Hotel ID</td>
                                            <td>${hotel.hotelId}<input type="hidden" name="hotelId" value="${hotel.hotelId}"</td>
                                        </tr>
                                        <tr>
                                            <td>Hotel Name</td>
                                            <td><input type="text" name="hotelName" value="${hotel.hotelName}"></td>
                                        </tr>
                                        <tr>
                                            <td>Street Address</td>
                                            <td><input type="text" name="streetAddress" value="${hotel.streetAddress}"></td>
                                        </tr>
                                        <tr>
                                            <td>City</td>
                                            <td><input type="text" name="city" value="${hotel.city}"></td>
                                        </tr>
                                        <tr>
                                            <td>State</td> 
                                            <td><input type="text" name="state" value="${hotel.state}"></td>
                                        </tr>
                                        <tr>
                                            <td>Postal Code</td>
                                            <td><input type="text" name="postalCode" value="${hotel.postalCode}"></td>
                                        </tr>
                                        <tr>
                                            <td>Notes</td>
                                            <td><textarea name="notes" value="${hotel.notes}" cols="19" rows="2">${hotel.notes}</textarea></td>
                                        </tr>
                                    </tbody>
                                </table>
                                
                                <input type="submit" name="submit" class="btn btn-lg btn-primary" value="Save Hotel" />
                            </form>
                            <form class="confirm" id="formDelete" name="formDelete" method="POST" action='<%= request.getContextPath() + "/HotelController?action=deleteHotel"%>'>
                                <input type="text" name="hotelId" value="${hotel.hotelId}" hidden>
                                <input type="submit" name="btnDelete" id="btnDelete" class="btn btn-lg btn-warning" value ="Delete Hotel"/>
                            </form>
                        </div>   
                </div>   
            </c:forEach>
        </div>      
        <input type="button" name="addHotel" id="addHotel" class="btn btn-lg btn-success" value="Add Hotel" />
        <div id="addHotelForm">
            <br>
            <form id="formAdd" name="formAdd" method="POST" action='<%= request.getContextPath() + "/HotelController?action=saveHotel"%>'>
                <table>
                        <tbody>
                                        <tr>
                                            <td>Hotel ID</td>
                                            <td>Not yet assigned<input type="text" name="hotelId" value="0" hidden></td>
                                        </tr>
                                        <tr>
                                            <td>Hotel Name</td>
                                            <td><input type="text" name="hotelName" placeholder="Hotel Name"></td>
                                        </tr>
                                        <tr>
                                            <td>Street Address</td>
                                            <td><input type="text" name="streetAddress" placeholder="Street Address"></td>
                                        </tr>
                                        <tr>
                                            <td>City</td>
                                            <td><input type="text" name="city" placeholder="City"></td>
                                        </tr>
                                        <tr>
                                            <td>State</td> 
                                            <td><input type="text" name="state" placeholder="State"></td>
                                        </tr>
                                        <tr>
                                            <td>Postal Code</td>
                                            <td><input type="text" name="postalCode" placeholder="Zip Code"></td>
                                        </tr>
                                        <tr>
                                            <td>Notes (optional)</td>
                                            <td><input type="text" name="notes" placeholder="Notes"  cols="25" rows="6"></td>
                                        </tr>
                                    </tbody>
                    </table>
                <br>
                <input type="submit" name="submit" class="btn btn-lg btn-success" value="Save Hotel" />
                <input type="button" name="cancelAdd" id="cancelAdd" value="Cancel" class="btn btn-lg btn-danger">
            </form>
            
        </div>
        </div>   
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
        <script src="//code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
        <script src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.13.1/jquery.validate.min.js"></script>
        <script src='<%= request.getContextPath() + "/Content/Scripts/hotels.js"%>' type="text/javascript"></script>
    </body>
</html>
