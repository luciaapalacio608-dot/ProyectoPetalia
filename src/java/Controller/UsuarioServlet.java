/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.UsuarioDAO;
import Model.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/UsuarioServlet")
public class UsuarioServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if (accion == null) {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            Usuario u = usuarioDAO.validar(email, password);
            if (u != null) {
                HttpSession session = request.getSession();
                session.setAttribute("usuario", u);
                if ("admin".equals(u.getRol())) {
                    response.sendRedirect("Admin.jsp");
                } else {
                    response.sendRedirect("Clientes.jsp");
                }
            } else {
                response.sendRedirect("index.jsp?error=1");
            }
            return;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        if ("editar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String nombre = request.getParameter("nombre");
            String email = request.getParameter("email");
            String rol = request.getParameter("rol");
            String password = request.getParameter("password");
            usuarioDAO.editar(id, nombre, email, rol, password);
            response.sendRedirect("Empleados.jsp?msg=editado");

        } else if ("eliminar".equals(accion)) {
            int id = Integer.parseInt(request.getParameter("id"));
            usuarioDAO.eliminar(id);
            response.sendRedirect("Empleados.jsp?msg=eliminado");
        }
    }
}