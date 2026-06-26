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

@WebServlet("/RegistroServlet")
public class RegistroServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rol = request.getParameter("rol");
        String claveAdmin = request.getParameter("claveAdmin");

        if ("admin".equals(rol)) {
            if (!"PETALIA2026".equals(claveAdmin)) {
                response.sendRedirect("Registro.jsp?error=ClaveInvalida");
                return;
            }
        }

        Usuario nuevoUsuario = new Usuario(0, nombre, email, password, rol);
        boolean registrado = usuarioDAO.registrar(nuevoUsuario);

        if (registrado) {
            response.sendRedirect("index.jsp?mensaje=exito");
        } else {
            response.sendRedirect("Registro.jsp?error=fallo");
        }
    }
}