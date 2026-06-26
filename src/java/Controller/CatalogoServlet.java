/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.ProductoDAO;
import Model.Producto;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CatalogoServlet")
public class CatalogoServlet extends HttpServlet {

    private ProductoDAO productoDAO = new ProductoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categoria = request.getParameter("categoria");
        List<Producto> productos;

        try {
            if (categoria != null && !categoria.trim().isEmpty()) {
                productos = productoDAO.listarPorCategoria(categoria.trim());
            } else {
                productos = productoDAO.listarTodos();
            }
        } catch (SQLException e) {
            throw new ServletException("Error al consultar productos", e);
        }

        request.setAttribute("productos", productos);
        request.getRequestDispatcher("/Catalogo.jsp").forward(request, response);
    }
}