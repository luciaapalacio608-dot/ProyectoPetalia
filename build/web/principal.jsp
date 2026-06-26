<%-- 
    Document   : principal.jsp
    Created on : 25 jun 2026
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.PedidoDAO, Model.Pedido, Model.Usuario" %>
<%
    // Declaración necesaria para el alcance de las variables
    Usuario usuarioNav = (Usuario) session.getAttribute("usuario");
    String rolNav = (usuarioNav != null) ? usuarioNav.getRol() : "invitado";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Petalia | Inicio</title>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="content">
        <div class="header">
            <h1>Bienvenido, <%= usuarioNav.getNombre() %></h1>
            <div class="subtitle">
                Un sistema donde cada flor cuenta una historia.
            </div>
        </div>

        <div class="hero">
            <div class="hero-text">
                Colección Petalia — Flores reales, emociones reales
            </div>
        </div>

        <% if ("admin".equals(rolNav)) { %>
            <div class="section">
                <h3>Resumen Administrativo</h3>
                <div class="stats-grid" style="display: flex; gap: 15px; margin-top: 15px;">
                    <div class="card" style="padding: 15px; width: 200px;">
                        <p>Pedidos Pendientes</p>
                        <span style="font-size: 20px; font-weight: bold;">
                            <%= new PedidoDAO().listarTodos().stream().filter(p -> "en espera".equals(p.getEstado())).count() %>
                        </span>
                    </div>
                </div>
            </div>
        <% } %>

        <div class="section">
            <h3>Flores destacadas</h3>
            <div class="grid">
                <div class="card"><img src="img/arreglo.jpg"><p>Arreglos</p></div>
                <div class="card"><img src="img/boda.jpg"><p>Bodas</p></div>
                <div class="card"><img src="img/graduacion.jpg"><p>Graduaciones</p></div>
            </div>
        </div>
    </div>
</body>
</html>