/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.hoteljpa.controller;


import com.mycompany.hoteljpa.ejb.HotelFacade;
import com.mycompany.hoteljpa.entity.Hotel;
import com.mycompany.hoteljpa.util.MySessionListener;
import java.io.IOException;
import java.util.List;
import javax.inject.Inject;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author DB7
 */
public class HotelController extends HttpServlet {
    private final static String RESULT_PAGE = "/hotel/hotels.jsp";  
    private final static String SAVE_HOTEL = "saveHotel";
    private final static String DELETE_HOTEL = "deleteHotel";
    private final static String LOGIN = "logIn";
    private final static String LOGOUT = "logOut";
    private final static String REORDER = "reorder";
    private final static String SEARCH = "search";
    
    @Inject
    private HotelFacade hs;
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();      


        RequestDispatcher view;
        if(session.getAttribute("orderField") == null){
            session.setAttribute("orderField", "hotelId");
        };        
        
        if(request.getParameter("action") != null){
            switch(request.getParameter("action")){
                case SAVE_HOTEL:
                    Hotel hotel = new Hotel();
                    hotel.setHotelId(Integer.parseInt(request.getParameter("hotelId")));
                    hotel.setHotelName(request.getParameter("hotelName"));
                    hotel.setStreetAddress(request.getParameter("streetAddress"));
                    hotel.setCity(request.getParameter("city"));
                    hotel.setState(request.getParameter("state"));
                    hotel.setPostalCode(request.getParameter("postalCode"));
                    hotel.setNotes(request.getParameter("notes"));

                    if(hotel.getHotelId() == 0){
                        hs.create(hotel);
                    } else {
                        hs.edit(hotel);
                    }
                    
                    break;
                case DELETE_HOTEL:
                    Hotel hotelDelete = new Hotel();

                    hotelDelete.setHotelId(Integer.parseInt(request.getParameter("hotelId")));
                    hs.remove(hotelDelete);
                    break;
                case LOGIN:
                    String sessionUser = request.getParameter("sessionName");
                    session.setAttribute("sessionUser", sessionUser);
                    break;
                case LOGOUT:
                    session.invalidate();
                    break;                  
                case REORDER:
                    switch(request.getParameter("order")){
                        case "hotelId":
                            session.setAttribute("orderField", "hotelId");
                            break;
                        case "hotelName":
                            session.setAttribute("orderField", "hotelName");
                            break;
                        case "city":
                            session.setAttribute("orderField", "city");
                            break;
                        case "state":
                            session.setAttribute("orderField", "state");
                        default:
                            break;
                    }
                    break;
                case SEARCH:
                    String searchTerm = request.getParameter("searchTerm");
                    String searchField = request.getParameter("searchColumn");
                    
                    List<Hotel> hotelList = hs.findHotelsBySearch(searchField, searchTerm, session.getAttribute("orderField").toString());
                    request.setAttribute("hotelList", hotelList);
                    
                    view = request.getRequestDispatcher(RESULT_PAGE);
                    view.forward(request, response);
                    break;
                default:
                    break;
            }     
        }
           
        List<Hotel> hotelList = hs.findAllWithOrder(session.getAttribute("orderField").toString());
        request.setAttribute("hotelList", hotelList);
        String sessionCount = Integer.toString(MySessionListener.getTotalSessions());
        request.setAttribute("activeSessionCount", sessionCount);
              
        
        view = request.getRequestDispatcher(RESULT_PAGE);
        view.forward(request, response);
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
