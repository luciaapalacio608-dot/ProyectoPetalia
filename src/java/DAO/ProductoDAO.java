/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.Producto;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO {

    private Producto mapRow(ResultSet rs) throws SQLException {
        Producto p = new Producto();
        p.setId(rs.getInt("id_producto"));
        p.setNombre(rs.getString("nombre"));
        p.setDescripcion(rs.getString("descripcion"));
        p.setPrecio(rs.getDouble("precio"));
        p.setImagenUrl(rs.getString("imagen_url"));
        p.setCategoria(rs.getString("categoria"));
        p.setStock(rs.getInt("stock"));
        return p;
    }

    public List<Producto> listarTodos() throws SQLException {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT id_producto, nombre, descripcion, precio, imagen_url, categoria, stock FROM productos ORDER BY categoria, nombre";
        try (Connection con = DAO.Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapRow(rs));
        }
        return lista;
    }

    public List<Producto> listarPorCategoria(String categoria) throws SQLException {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT id_producto, nombre, descripcion, precio, imagen_url, categoria, stock FROM productos WHERE LOWER(categoria) = LOWER(?) ORDER BY nombre";
        try (Connection con = DAO.Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, categoria);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) lista.add(mapRow(rs));
            }
        }
        return lista;
    }

    public Producto obtenerPorId(int idProducto) throws SQLException {
        String sql = "SELECT id_producto, nombre, descripcion, precio, imagen_url, categoria, stock FROM productos WHERE id_producto = ?";
        try (Connection con = DAO.Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idProducto);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public void agregar(Producto p) throws SQLException {
        String sql = "INSERT INTO productos (nombre, descripcion, precio, imagen_url, categoria, stock) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DAO.Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getNombre());
            ps.setString(2, p.getDescripcion());
            ps.setDouble(3, p.getPrecio());
            ps.setString(4, p.getImagenUrl());
            ps.setString(5, p.getCategoria());
            ps.setInt(6, p.getStock());
            ps.executeUpdate();
        }
    }

    public void editar(Producto p) throws SQLException {
        String sql = "UPDATE productos SET nombre=?, descripcion=?, precio=?, imagen_url=?, categoria=?, stock=? WHERE id_producto=?";
        try (Connection con = DAO.Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, p.getNombre());
            ps.setString(2, p.getDescripcion());
            ps.setDouble(3, p.getPrecio());
            ps.setString(4, p.getImagenUrl());
            ps.setString(5, p.getCategoria());
            ps.setInt(6, p.getStock());
            ps.setInt(7, p.getId());
            ps.executeUpdate();
        }
    }

    public void eliminar(int id) throws SQLException {
        String sql = "DELETE FROM productos WHERE id_producto = ?";
        try (Connection con = DAO.Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
    public void actualizarStock(int id, int nuevoStock) throws SQLException {
    String sql = "UPDATE productos SET stock = ? WHERE id_producto = ?";
    try (Connection con = DAO.Conexion.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, nuevoStock);
        ps.setInt(2, id);
        ps.executeUpdate();
    }
}
}