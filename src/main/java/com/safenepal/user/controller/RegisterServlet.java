package com.safenepal.user.controller;

import com.safenepal.user.model.dao.UserDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet(name = "registerPage", value = "/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestDispatcher requestDispatcher = req.getRequestDispatcher("pages/register.jsp");
        requestDispatcher.forward(req,resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        String  fullName = req.getParameter("name");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String  password = req.getParameter("password");
        String role = req.getParameter("role");

        if(fullName.isEmpty() || email.isEmpty() || password.isEmpty()){
            RequestDispatcher requestDispatcher = req.getRequestDispatcher("pages/register.jsp");

            String message = "Please fill the all fields";
            req.setAttribute("error",message);

            requestDispatcher.forward(req,resp);
        }
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        try{
            UserDAO userDao=new UserDAO();
            boolean userInserted = userDao.insertUser(fullName, email, phone, hashedPassword, role);
            if(userInserted==true){
                req.getRequestDispatcher("pages/login.jsp").forward(req,resp);

            }else{
                req.setAttribute("error", "Something went wrong ! Please try again ");
                req.getRequestDispatcher("pages/register.jsp").forward(req,resp);
            }
        }
        catch (Exception e){
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("pages/register.jsp").forward(req, resp);

        }
    }
}