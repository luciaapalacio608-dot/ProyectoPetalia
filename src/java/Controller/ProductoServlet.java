/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.ProductoDAO;
import Model.Producto;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/ProductoServlet")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // 5MB máximo
public class ProductoServlet extends HttpServlet {

    private ProductoDAO dao = new ProductoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");

        try {
            if ("agregar".equals(accion) || "editar".equals(accion)) {

                String nombre      = request.getParameter("nombre");
                String descripcion = request.getParameter("descripcion");
                double precio      = Double.parseDouble(request.getParameter("precio"));
                String categoria   = request.getParameter("categoria");
                int    stock       = Integer.parseInt(request.getParameter("stock"));

                // Manejar imagen subida
                String imagenUrl = request.getParameter("imagen_url_actual"); // URL actual (editar)
                Part filePart = request.getPart("imagen_file");

                if (filePart != null && filePart.getSize() > 0) {
                    String fileName = extraerNombreArchivo(filePart);
                    if (fileName != null && !fileName.isEmpty()) {
                        // Ruta absoluta de la carpeta img/ en el servidor
                        String uploadDir = getServletContext().getRealPath("/img");
                        File uploadFolder = new File(uploadDir);
                        if (!uploadFolder.exists()) uploadFolder.mkdirs();

                        // Guardar archivo
                        filePart.write(uploadDir + File.separator + fileName);
                        imagenUrl = "img/" + fileName;
                    }
                } else if (request.getParameter("imagen_url") != null
                           && !request.getParameter("imagen_url").trim().isEmpty()) {
                    // Si no subió archivo pero escribió una URL manual
                    imagenUrl = request.getParameter("imagen_url").trim();
                }

                Producto p = new Producto();
                p.setNombre(nombre);
                p.setDescripcion(descripcion);
                p.setPrecio(precio);
                p.setImagenUrl(imagenUrl);
                p.setCategoria(categoria);
                p.setStock(stock);

                if ("agregar".equals(accion)) {
                    dao.agregar(p);
                    response.sendRedirect("GestionCatalogo.jsp?msg=agregado");
                } else {
                    p.setId(Integer.parseInt(request.getParameter("id")));
                    dao.editar(p);
                    response.sendRedirect("GestionCatalogo.jsp?msg=editado");
                }

            } else if ("eliminar".equals(accion)) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.eliminar(id);
                response.sendRedirect("GestionCatalogo.jsp?msg=eliminado");
            }

        } catch (SQLException e) {
            throw new ServletException("Error en ProductoServlet", e);
        }
    }

    private String extraerNombreArchivo(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null) return null;
        for (String token : header.split(";")) {
            if (token.trim().startsWith("filename")) {
                String name = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                // Solo el nombre, sin la ruta completa (IE envía ruta completa)
                return new File(name).getName();
            }
        }
        return null;
    }
}