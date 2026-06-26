<%-- 
    Document   : PedidosAdmin
    Created on : 24 jun 2026, 1:10:44 a. m.
    Author     : lucia
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, DAO.PedidoDAO, Model.Pedido" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Petalia - Gestión de Pedidos</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <style>
        body { padding-top: 54px; padding-left: 230px; background: #f4f5f0; font-family: 'Segoe UI', Arial, sans-serif; color: #2c2c2a; min-height: 100vh; }
        .main-content { padding: 36px 40px; max-width: 1100px; }
        .page-title { font-family: 'Playfair Display', serif; font-size: 1.7rem; font-weight: 700; color: #3d4a26; margin-bottom: 24px; }
        
        /* Stats Grid */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 24px; }
        .stat-card { background: #fff; padding: 20px; border-radius: 10px; border: 1px solid #c8cdb8; }
        .stat-label { font-size: 0.75rem; text-transform: uppercase; color: #5c6b3a; font-weight: 700; margin-bottom: 8px; }
        .stat-value { font-size: 1.5rem; font-weight: 700; color: #3d4a26; }

        /* Search Bar & Table */
        .search-bar { display: flex; gap: 12px; margin-bottom: 18px; align-items: center; }
        .card { background: #fff; border: 1px solid #c8cdb8; border-radius: 10px; overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        thead { background: #3d4a26; color: #e8ead8; }
        th, td { padding: 14px 16px; font-size: 0.88rem; }
        tbody tr { border-bottom: 1px solid #f0f0ec; }

        .badge { padding: 4px 10px; border-radius: 20px; font-size: 0.7rem; font-weight: 700; text-transform: uppercase; }
        .badge-espera { background: #fff3cd; color: #856404; }
        .badge-entregado { background: #eaf3de; color: #3d4a26; }
        .badge-cancelado { background: #fdecea; color: #c0392b; }

        .btn { font-size: 0.72rem; padding: 6px 12px; border-radius: 6px; border: none; cursor: pointer; text-transform: uppercase; font-weight: 700; }
        .btn-primary { background: #3d4a26; color: #fff; }
        .btn-danger { background: #fdecea; color: #c0392b; border: 1px solid #f5c6c2; }
        
        @media (max-width: 768px) { body { padding-left: 0; } }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    <%
        if (!rolNav.equals("admin")) { response.sendRedirect("Clientes.jsp"); return; }
        
        PedidoDAO pedidoDAO = new PedidoDAO();
        List<Pedido> pedidos = pedidoDAO.listarTodos();
        String filtroEstado = request.getParameter("estado") != null ? request.getParameter("estado") : "";
        String msg = request.getParameter("msg");
        
        int espera = 0, entregados = 0, cancelados = 0;
        double totalVentas = 0;
        
        for (Pedido p : pedidos) {
            if ("en espera".equals(p.getEstado())) espera++;
            else if ("entregado".equals(p.getEstado())) { entregados++; totalVentas += p.getTotal(); }
            else if ("cancelado".equals(p.getEstado())) cancelados++;
        }
    %>
    <div class="main-content">
        <div class="page-title">Gestión de pedidos</div>
        
        <% if ("cancelado".equals(msg)) { %>
            <div style="margin-bottom: 20px; padding: 12px; background: #fdecea; color: #c0392b; border-radius: 6px;">Pedido cancelado.</div>
        <% } else if ("entregado".equals(msg)) { %>
            <div style="margin-bottom: 20px; padding: 12px; background: #eaf3de; color: #3d4a26; border-radius: 6px;">Pedido marcado como entregado.</div>
        <% } %>

        <div class="stats-grid">
            <div class="stat-card"><div class="stat-label">En espera</div><div class="stat-value"><%= espera %></div></div>
            <div class="stat-card"><div class="stat-label">Entregados</div><div class="stat-value"><%= entregados %></div></div>
            <div class="stat-card"><div class="stat-label">Cancelados</div><div class="stat-value"><%= cancelados %></div></div>
            <div class="stat-card"><div class="stat-label">Total cobrado</div><div class="stat-value">&#8353;<%= String.format("%,.0f", totalVentas) %></div></div>
        </div>

        <div class="search-bar">
            <form method="get" action="PedidosAdmin.jsp">
                <select name="estado" onchange="this.form.submit()" style="padding: 8px; border-radius: 6px;">
                    <option value="" <%= "".equals(filtroEstado) ? "selected" : "" %>>Todos</option>
                    <option value="en espera" <%= "en espera".equals(filtroEstado) ? "selected" : "" %>>En espera</option>
                    <option value="entregado" <%= "entregado".equals(filtroEstado) ? "selected" : "" %>>Entregados</option>
                    <option value="cancelado" <%= "cancelado".equals(filtroEstado) ? "selected" : "" %>>Cancelados</option>
                </select>
            </form>
            <input type="text" id="buscar-pedido" placeholder="Buscar por N de pedido..." oninput="filtrarTabla()" style="padding: 8px; border: 1px solid #c8cdb8; border-radius: 6px; flex: 1;">
        </div>

        <div class="card">
            <table>
                <thead>
                    <tr><th>N pedido</th><th>Usuario ID</th><th>Total</th><th>Estado</th><th>Fecha</th><th>Acciones</th></tr>
                </thead>
                <tbody id="tabla-pedidos">
                    <% for (Pedido p : pedidos) {
                       if (!filtroEstado.isEmpty() && !filtroEstado.equals(p.getEstado())) continue;
                       String badgeClass = "en espera".equals(p.getEstado()) ? "badge-espera" :
                                         "entregado".equals(p.getEstado()) ? "badge-entregado" : "badge-cancelado"; 
                    %>
                    <tr data-id="<%= p.getId() %>">
                        <td><strong>#<%= String.format("%03d", p.getId()) %></strong></td>
                        <td>Usuario #<%= p.getIdCliente() %></td>
                        <td>&#8353;<%= String.format("%,.0f", p.getTotal()) %></td>
                        <td><span class="badge <%= badgeClass %>"><%= p.getEstado() %></span></td>
                        <td><%= p.getFecha() != null ? p.getFecha().toString().substring(0,10) : "-" %></td>
                        <td>
                            <div style="display:flex; gap:6px;">
                                <% if ("en espera".equals(p.getEstado())) { %>
                                    <form action="PedidoServlet" method="post" onsubmit="return confirm('¿Marcar como entregado?')">
                                        <input type="hidden" name="accion" value="entregar">
                                        <input type="hidden" name="id" value="<%= p.getId() %>">
                                        <button type="submit" class="btn btn-primary">Entregar</button>
                                    </form>
                                    <form action="PedidoServlet" method="post" onsubmit="return confirm('¿Cancelar este pedido?')">
                                        <input type="hidden" name="accion" value="cancelar">
                                        <input type="hidden" name="id" value="<%= p.getId() %>">
                                        <button type="submit" class="btn btn-danger">Cancelar</button>
                                    </form>
                                <% } else { %>
                                    <span style="color:#aaa; font-size: 0.8rem;">Sin acciones</span>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <script>
        function filtrarTabla() {
            const q = document.getElementById('buscar-pedido').value;
            document.querySelectorAll('#tabla-pedidos tr').forEach(tr => {
                tr.style.display = tr.dataset.id.includes(q) ? '' : 'none';
            });
        }
    </script>
</body>
</html>