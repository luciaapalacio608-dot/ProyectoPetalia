<%--
    Document   : Admin
    Created on : 24 jun 2026
    Author     : lucia
--%>
<%@ page language="java" import="java.util.List, DAO.PedidoDAO, DAO.ProductoDAO, Model.Pedido, Model.Producto" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Petalia - Panel Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <style>
        body { padding-top: 54px; padding-left: 230px; background: #f4f5f0; font-family: 'Segoe UI', Arial, sans-serif; color: #2c2c2a; min-height: 100vh; }
        .main-content { padding: 36px 40px; max-width: 1100px; }

        .page-title { font-family: 'Playfair Display', serif; font-size: 1.7rem; font-weight: 700; color: #3d4a26; margin-bottom: 6px; }
        .page-title::after { content: ''; display: block; width: 48px; height: 2px; background: #7a8c4e; margin-top: 8px; border-radius: 2px; }
        .page-sub { color: #888; font-size: 0.88rem; margin-top: 10px; margin-bottom: 28px; }

        /* Stats */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 16px; margin-bottom: 28px; }
        .stat-card { background: #fff; border: 1px solid #c8cdb8; border-radius: 10px; padding: 20px 22px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        .stat-label { font-size: 0.72rem; text-transform: uppercase; letter-spacing: 0.1em; color: #7a8c4e; font-weight: 700; margin-bottom: 8px; }
        .stat-value { font-size: 2rem; font-weight: 700; color: #3d4a26; line-height: 1; }
        .stat-sub { font-size: 0.76rem; color: #aaa; margin-top: 6px; }
        .stat-card.highlight { background: #3d4a26; border-color: #3d4a26; }
        .stat-card.highlight .stat-label { color: #b8c4a0; }
        .stat-card.highlight .stat-value { color: #fff; }
        .stat-card.highlight .stat-sub { color: #7a8c4e; }

        /* Accesos rapidos */
        .section-title { font-family: 'Playfair Display', serif; font-size: 1.1rem; font-weight: 600; color: #3d4a26; margin-bottom: 16px; }

        .quick-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 14px; margin-bottom: 28px; }
        .quick-card { background: #fff; border: 1px solid #c8cdb8; border-radius: 10px; padding: 20px; text-decoration: none; color: #2c2c2a; display: flex; align-items: center; gap: 14px; transition: box-shadow 0.2s, transform 0.2s; }
        .quick-card:hover { box-shadow: 0 6px 20px rgba(0,0,0,0.1); transform: translateY(-2px); }
        .quick-icon { width: 42px; height: 42px; border-radius: 8px; background: #eaf3de; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .quick-icon svg { width: 20px; height: 20px; stroke: #3d4a26; }
        .quick-label { font-size: 0.88rem; font-weight: 700; color: #3d4a26; }
        .quick-desc { font-size: 0.76rem; color: #888; margin-top: 2px; }

        /* Tabla pedidos recientes */
        .card { background: #fff; border: 1px solid #c8cdb8; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); overflow: hidden; }
        .card-header { padding: 16px 20px; border-bottom: 1px solid #f0f0ec; display: flex; justify-content: space-between; align-items: center; }
        table { width: 100%; border-collapse: collapse; font-size: 0.87rem; }
        thead tr { background: #3d4a26; color: #e8ead8; }
        thead th { padding: 11px 16px; text-align: left; font-size: 0.72rem; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; }
        tbody tr { border-bottom: 1px solid #f0f0ec; }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: #f7f8f4; }
        tbody td { padding: 11px 16px; vertical-align: middle; }

        .badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 0.68rem; font-weight: 700; text-transform: uppercase; }
        .badge-espera    { background: #fff3cd; color: #856404; }
        .badge-entregado { background: #eaf3de; color: #3d4a26; }
        .badge-cancelado { background: #fdecea; color: #c0392b; }

        .btn-link { font-size: 0.76rem; font-weight: 700; color: #5c6b3a; text-decoration: none; letter-spacing: 0.06em; text-transform: uppercase; }
        .btn-link:hover { color: #3d4a26; }

        @media (max-width: 768px) { body { padding-left: 0; } .main-content { padding: 24px 16px; } }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<%
    if (!rolNav.equals("admin")) { response.sendRedirect("Clientes.jsp"); return; }

    PedidoDAO pedidoDAO = new PedidoDAO();
    ProductoDAO productoDAO = new ProductoDAO();
    List<Pedido> todosLosPedidos = pedidoDAO.listarTodos();
    List<Producto> todosLosProductos = productoDAO.listarTodos();

    int totalPedidos = todosLosPedidos.size();
    int enEspera = 0;
    int entregados = 0;
    double totalVentas = 0;
    int stockBajo = 0;

    for (Pedido p : todosLosPedidos) {
        if ("en espera".equals(p.getEstado())) enEspera++;
        else if ("entregado".equals(p.getEstado())) { entregados++; totalVentas += p.getTotal(); }
    }
    for (Producto p : todosLosProductos) {
        if (p.getStock() <= 3) stockBajo++;
    }
%>

<div class="main-content">

    <div class="page-title">Panel de Administracion</div>
    <p class="page-sub">Bienvenido, <%= nombreNav %>. Aqui tienes el resumen del sistema.</p>

    <!-- STATS -->
    <div class="stats-grid">
        <div class="stat-card highlight">
            <div class="stat-label">Pedidos en espera</div>
            <div class="stat-value"><%= enEspera %></div>
            <div class="stat-sub">Requieren atencion</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Pedidos entregados</div>
            <div class="stat-value"><%= entregados %></div>
            <div class="stat-sub">Completados</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Total vendido</div>
            <div class="stat-value">&#8353;<%= String.format("%,.0f", totalVentas) %></div>
            <div class="stat-sub">En pedidos entregados</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Productos</div>
            <div class="stat-value"><%= todosLosProductos.size() %></div>
            <div class="stat-sub"><%= stockBajo %> con stock bajo</div>
        </div>
    </div>

    <!-- ACCESOS RAPIDOS -->
    <div class="section-title">Accesos rapidos</div>
    <div class="quick-grid">
        <a href="GestionCatalogo.jsp" class="quick-card">
            <div class="quick-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M12 2v20M2 12h20"/>
                </svg>
            </div>
            <div>
                <div class="quick-label">Gestion de catalogo</div>
                <div class="quick-desc">Agregar, editar y eliminar productos</div>
            </div>
        </a>
        <a href="PedidosAdmin.jsp" class="quick-card">
            <div class="quick-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="9 11 12 14 22 4"/>
                    <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/>
                </svg>
            </div>
            <div>
                <div class="quick-label">Gestion de pedidos</div>
                <div class="quick-desc"><%= enEspera %> pedidos pendientes</div>
            </div>
        </a>
        <a href="Empleados.jsp" class="quick-card">
            <div class="quick-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                    <circle cx="9" cy="7" r="4"/>
                </svg>
            </div>
            <div>
                <div class="quick-label">Empleados</div>
                <div class="quick-desc">Gestionar usuarios del sistema</div>
            </div>
        </a>
        <a href="Historial.jsp" class="quick-card">
            <div class="quick-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <line x1="18" y1="20" x2="18" y2="10"/>
                    <line x1="12" y1="20" x2="12" y2="4"/>
                    <line x1="6" y1="20" x2="6" y2="14"/>
                </svg>
            </div>
            <div>
                <div class="quick-label">Historial de ventas</div>
                <div class="quick-desc">Ver reportes y estadisticas</div>
            </div>
        </a>
    </div>

    <!-- PEDIDOS RECIENTES -->
    <div class="card">
        <div class="card-header">
            <div class="section-title" style="margin:0">Pedidos recientes</div>
            <a href="PedidosAdmin.jsp" class="btn-link">Ver todos</a>
        </div>
        <table>
            <thead>
                <tr>
                    <th>N Pedido</th>
                    <th>Cliente ID</th>
                    <th>Total</th>
                    <th>Estado</th>
                    <th>Fecha</th>
                </tr>
            </thead>
            <tbody>
                <%
                    int count = 0;
                    for (int i = todosLosPedidos.size() - 1; i >= 0 && count < 5; i--, count++) {
                        Pedido p = todosLosPedidos.get(i);
                        String badgeClass = "en espera".equals(p.getEstado()) ? "badge-espera" :
                                           "entregado".equals(p.getEstado()) ? "badge-entregado" : "badge-cancelado";
                %>
                <tr>
                    <td><strong>#<%= String.format("%03d", p.getId()) %></strong></td>
                    <td>Cliente #<%= p.getIdCliente() %></td>
                    <td>&#8353;<%= String.format("%,.0f", p.getTotal()) %></td>
                    <td><span class="badge <%= badgeClass %>"><%= p.getEstado() %></span></td>
                    <td><%= p.getFecha() != null ? p.getFecha().toString().substring(0,10) : "-" %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

</div>
</body>
</html>
