/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.hoteljpa.ejb;

import com.mycompany.hoteljpa.entity.Hotel;
import com.mycompany.hoteljpa.entity.Hotel_;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

/**
 *
 * @author DB7
 */
@Stateless
public class HotelFacade extends AbstractFacade<Hotel> {
    @PersistenceContext(unitName = "hotelP")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public HotelFacade() {
        super(Hotel.class);
    }
      
    public List<Hotel> findHotelsBySearch(String searchField, String searchTerm, String orderBy) {
        Query q = this.getEntityManager().createQuery("select h from Hotel h where h." 
                + searchField + " LIKE '%" + searchTerm + "%' order by h." + orderBy );
        
        return q.getResultList();
    }
    
    public List<Hotel> findAllWithOrder(String orderBy){
        CriteriaBuilder builder = this.getEntityManager().getCriteriaBuilder();
        CriteriaQuery<Hotel> criteriaQuery = builder.createQuery(Hotel.class);
        Root<Hotel> hotel = criteriaQuery.from(Hotel.class);
        criteriaQuery.orderBy(builder.desc(hotel.get(Hotel_.hotelId)));
        TypedQuery<Hotel> q = this.getEntityManager().createQuery(criteriaQuery);
        List<Hotel> hotels = q.getResultList();
        
        return hotels;
    }
    
    
    
}
