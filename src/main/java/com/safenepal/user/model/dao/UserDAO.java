package com.safenepal.user.model.dao;

import com.safenepal.user.model.User;
import com.safenepal.utils.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    public boolean insertUser(String name, String email, String phone, String password, String role)
            throws SQLException{
        String query = "INSERT INTO user (name, email, phone, password, role) VALUES (?, ?, ?,?,?)";
        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(query);
        ){
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);

            int rowsInserted = ps.executeUpdate();
            if(rowsInserted > 0){
                return true;
            }else{
                return false;
            }
        }
    }

    public User loginUser(String email, String phone, String password, String role)
            throws SQLException{
        String query = "SELECT * FROM user WHERE email = ?";
        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(query)){
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                String storeHashedPassword = rs.getString("password");
                if(BCrypt.checkpw(password, storeHashedPassword)){
                    int id = rs.getInt("id");
                    String name = rs.getString("name");

                    User userObj = new User(id,name,email,phone,storeHashedPassword,role);
                    return userObj;
                }
            }
        }
        return null;
    }
}
