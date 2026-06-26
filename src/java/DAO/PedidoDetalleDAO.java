/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Model.PedidoDetalle;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PedidoDetalleDAO {

    // 1. AGREGAR (Se usa al crear un pedido)
    public boolean agregar(PedidoDetalle d) {
        String sql = "INSERT INTO pedido_detalle (pedido_id, id_producto, cantidad, precio_unitario) VALUES (?, ?, ?, ?)";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, d.getPedidoId());
            ps.setInt(2, d.getIdProducto());
            ps.setInt(3, d.getCantidad());
            ps.setDouble(4, d.getPrecioUnitario());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // 2. LISTAR POR PEDIDO (Para ver el contenido de un pedido en el historial)
    public List<PedidoDetalle> listarPorPedido(int pedidoId) {
        List<PedidoDetalle> lista = new ArrayList<>();
        String sql = "SELECT * FROM pedido_detalle WHERE pedido_id = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, pedidoId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PedidoDetalle d = new PedidoDetalle();
                    d.setId(rs.getInt("id"));
                    d.setPedidoId(rs.getInt("pedido_id"));
                    d.setIdProducto(rs.getInt("id_producto"));
                    d.setCantidad(rs.getInt("cantidad"));
                    d.setPrecioUnitario(rs.getDouble("precio_unitario"));
                    lista.add(d);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    // 3. ELIMINAR DETALLES (Útil si se borra un pedido del sistema)
    public boolean eliminarPorPedido(int pedidoId) {
        String sql = "DELETE FROM pedido_detalle WHERE pedido_id = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, pedidoId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}