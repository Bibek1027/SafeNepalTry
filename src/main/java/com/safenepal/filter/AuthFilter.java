package com.safenepal.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws ServletException, IOException {
        HttpServletResponse httpResponse = (HttpServletResponse) resp;
        HttpServletRequest httpRequest = (HttpServletRequest) req;

        String uri = httpRequest.getRequestURI();
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        boolean isAuthPage = (uri.contains("login") || uri.contains("register"));

        if(isLoggedIn && isAuthPage){
            httpResponse.sendRedirect("/");
            return;
        }

        if(isLoggedIn || isAuthPage){
            chain.doFilter(req,resp);
        }else{
            httpResponse.sendRedirect("/login");
        }
    }
}
