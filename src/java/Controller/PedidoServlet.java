
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.PedidoDAO;
import DAO.PedidoDetalleDAO;
import DAO.ProductoDAO;
import Model.PedidoDetalle;
import Model.Producto;
import Model.Usuario;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/PedidoServlet")
public class PedidoServlet extends HttpServlet {

    private PedidoDAO pedidoDAO = new PedidoDAO();
    private PedidoDetalleDAO detalleDAO = new PedidoDetalleDAO();
    private ProductoDAO productoDAO = new ProductoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String accion  = request.getParameter("accion");
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        try {
            if ("hacer_pedido".equals(accion)) {
                int prodId   = Integer.parseInt(request.getParameter("producto_id"));
                int cantidad = Integer.parseInt(request.getParameter("cantidad"));

                Producto p = productoDAO.obtenerPorId(prodId);

                if (p != null) {
                    // Verificar stock disponible
                    if (p.getStock() < cantidad) {
                        response.sendRedirect("CatalogoServlet?error=stock");
                        return;
                    }

                    // Crear pedido
                    int pedidoId = pedidoDAO.crearYRetornarId(usuario.getId(), p.getPrecio() * cantidad);

                    if (pedidoId > 0) {
                        // Agregar detalle
                        PedidoDetalle d = new PedidoDetalle();
                        d.setPedidoId(pedidoId);
                        d.setIdProducto(prodId);
                        d.setCantidad(cantidad);
                        d.setPrecioUnitario(p.getPrecio());
                        detalleDAO.agregar(d);

                        // Descontar stock
                        int nuevoStock = p.getStock() - cantidad;
                        productoDAO.actualizarStock(prodId, nuevoStock);

                        response.sendRedirect("MisPedidos.jsp?msg=creado");
                    }
                }

            } else if ("cancelar".equals(accion)) {
                int id = Integer.parseInt(request.getParameter("id"));
                pedidoDAO.cambiarEstado(id, "cancelado");

                String origen = request.getParameter("origen");
                if ("admin".equals(origen)) {
                    response.sendRedirect("PedidosAdmin.jsp?msg=cancelado");
                } else {
                    response.sendRedirect("MisPedidos.jsp?msg=cancelado");
                }

            } else if ("entregar".equals(accion)) {
                int id = Integer.parseInt(request.getParameter("id"));
                pedidoDAO.cambiarEstado(id, "entregado");
                response.sendRedirect("PedidosAdmin.jsp?msg=entregado");
            }

        } catch (SQLException e) {
            throw new ServletException("Error de base de datos en PedidoServlet", e);
        }
    }
}