/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.hoteljpa.util;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;


/**
 *
 * @author DB7
 */
public class MySessionListener implements HttpSessionListener{
    private static int totalSessions;
    
    @Override
    public void sessionCreated(HttpSessionEvent hse) {
        totalSessions++;
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent hse) {
        System.out.println("SESSION DESTROYED");
    }
    
    public static int getTotalSessions(){
        return totalSessions;
    }
}
