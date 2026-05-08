package com.safenepal.location.model.dao;

import com.safenepal.location.model.Location;
import com.safenepal.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LocationDAO {

    public List<Location> getAllLocations() throws SQLException {
        List<Location> list = new ArrayList<>();
        String query = "SELECT * FROM locations ORDER BY location_name ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement st = conn.prepareStatement(query);
             ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                Location loc = new Location();
                loc.setLocationId(rs.getInt("location_id"));
                loc.setLocationName(rs.getString("location_name"));
                loc.setDistrict(rs.getString("district"));
                loc.setProvince(rs.getString("province"));
                loc.setRiskLevel(rs.getString("risk_level"));
                list.add(loc);
            }
        }
        return list;
    }
}
