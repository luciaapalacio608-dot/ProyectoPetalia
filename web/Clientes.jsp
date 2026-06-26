<%--
    Document   : Clientes
    Created on : 24 jun 2026
    Author     : lucia
--%>
<%@ page language="java" import="java.util.List, DAO.PedidoDAO, Model.Pedido" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Petalia - Bienvenido</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <style>
        body { padding-top: 54px; padding-left: 230px; background: #f4f5f0; font-family: 'Segoe UI', Arial, sans-serif; color: #2c2c2a; min-height: 100vh; }
        .main-content { padding: 36px 40px; max-width: 900px; }

        /* Hero */
        .hero { background: #3d4a26; border-radius: 12px; padding: 36px 40px; color: #e8ead8; margin-bottom: 28px; position: relative; overflow: hidden; }
        .hero::after { content: ''; position: absolute; right: -30px; top: -30px; width: 180px; height: 180px; border-radius: 50%; background: rgba(255,255,255,0.04); }
        .hero-eyebrow { font-size: 0.72rem; font-weight: 700; letter-spacing: 0.2em; text-transform: uppercase; color: #b8c4a0; margin-bottom: 10px; }
        .hero-title { font-family: 'Playfair Display', serif; font-size: clamp(1.4rem, 3vw, 2rem); font-weight: 700; margin-bottom: 10px; }
        .hero-sub { font-size: 0.88rem; color: #b8c4a0; margin-bottom: 22px; }
        .btn-hero { display: inline-block; background: #fff; color: #3d4a26; font-family: 'Segoe UI', Arial, sans-serif; font-size: 0.78rem; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; padding: 10px 22px; border-radius: 6px; text-decoration: none; transition: background 0.2s; }
        .btn-hero:hover { background: #eaf3de; }

        /* Stats cliente */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 14px; margin-bottom: 28px; }
        .stat-card { background: #fff; border: 1px solid #c8cdb8; border-radius: 10px; padding: 18px 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
        .stat-label { font-size: 0.72rem; text-transform: uppercase; letter-spacing: 0.1em; color: #7a8c4e; font-weight: 700; margin-bottom: 8px; }
        .stat-value { font-size: 1.8rem; font-weight: 700; color: #3d4a26; }
        .stat-sub { font-size: 0.74rem; color: #aaa; margin-top: 4px; }

        /* Accesos rapidos */
        .section-title { font-family: 'Playfair Display', serif; font-size: 1.1rem; font-weight: 600; color: #3d4a26; margin-bottom: 16px; }
        .quick-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 14px; margin-bottom: 28px; }
        .quick-card { background: #fff; border: 1px solid #c8cdb8; border-radius: 10px; padding: 20px; text-decoration: none; color: #2c2c2a; display: flex; align-items: center; gap: 14px; transition: box-shadow 0.2s, transform 0.2s; }
        .quick-card:hover { box-shadow: 0 6px 20px rgba(0,0,0,0.1); transform: translateY(-2px); }
        .quick-icon { width: 42px; height: 42px; border-radius: 8px; background: #eaf3de; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .quick-icon svg { width: 20px; height: 20px; stroke: #3d4a26; }
        .quick-label { font-size: 0.88rem; font-weight: 700; color: #3d4a26; }
        .quick-desc { font-size: 0.76rem; color: #888; margin-top: 2px; }

        /* Pedidos recientes */
        .card { background: #fff; border: 1px solid #c8cdb8; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
        .card-header { padding: 16px 20px; border-bottom: 1px solid #f0f0ec; display: flex; justify-content: space-between; align-items: center; }
        table { width: 100%; border-collapse: collapse; font-size: 0.87rem; }
        thead tr { background: #3d4a26; color: #e8ead8; }
        thead th { padding: 11px 16px; text-align: left; font-size: 0.72rem; font-weight: 700; letter-spacing: 0.1em; text-transform: uppercase; }
        tbody tr { border-bottom: 1px solid #f0f0ec; }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: #f7f8f4; }
        tbody td { padding: 11px 16px; }
        .badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 0.68rem; font-weight: 700; text-transform: uppercase; }
        .badge-espera    { background: #fff3cd; color: #856404; }
        .badge-entregado { background: #eaf3de; color: #3d4a26; }
        .badge-cancelado { background: #fdecea; color: #c0392b; }
        .btn-link { font-size: 0.76rem; font-weight: 700; color: #5c6b3a; text-decoration: none; letter-spacing: 0.06em; text-transform: uppercase; }
        .btn-link:hover { color: #3d4a26; }
        .empty-msg { text-align: center; padding: 32px; color: #aaa; font-size: 0.88rem; }

        @media (max-width: 768px) { body { padding-left: 0; } .main-content { padding: 24px 16px; } .hero { padding: 24px; } }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<%
    PedidoDAO pedidoDAO = new PedidoDAO();
    List<Pedido> misPedidos = pedidoDAO.listarPorUsuario(usuarioNav.getId());

    int totalPedidos  = misPedidos.size();
    int enEspera      = 0;
    int entregados    = 0;

    for (Pedido p : misPedidos) {
        if ("en espera".equals(p.getEstado())) enEspera++;
        else if ("entregado".equals(p.getEstado())) entregados++;
    }
%>

<div class="main-content">

    <!-- HERO -->
    <div class="hero">
        <div class="hero-eyebrow">Bienvenido a Petalia</div>
        <div class="hero-title">Hola, <%= nombreNav %></div>
        <div class="hero-sub">Explora nuestra coleccion de arreglos florales para cada momento especial.</div>
        <a href="CatalogoServlet" class="btn-hero">Ver catalogo de flores</a>
    </div>

    <!-- STATS -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-label">Mis pedidos</div>
            <div class="stat-value"><%= totalPedidos %></div>
            <div class="stat-sub">En total</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">En espera</div>
            <div class="stat-value"><%= enEspera %></div>
            <div class="stat-sub">Pendientes</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Entregados</div>
            <div class="stat-value"><%= entregados %></div>
            <div class="stat-sub">Completados</div>
        </div>
    </div>

    <!-- ACCESOS RAPIDOS -->
    <div class="section-title">Accesos rapidos</div>
    <div class="quick-grid">
        <a href="CatalogoServlet" class="quick-card">
            <div class="quick-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M12 22s-8-4.5-8-11.8A8 8 0 0 1 12 2a8 8 0 0 1 8 8.2c0 7.3-8 11.8-8 11.8z"/>
                    <circle cx="12" cy="10" r="3"/>
                </svg>
            </div>
            <div>
                <div class="quick-label">Catalogo de flores</div>
                <div class="quick-desc">Explorar y hacer pedidos</div>
            </div>
        </a>
        <a href="MisPedidos.jsp" class="quick-card">
            <div class="quick-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                    <line x1="3" y1="6" x2="21" y2="6"/>
                    <path d="M16 10a4 4 0 0 1-8 0"/>
                </svg>
            </div>
            <div>
                <div class="quick-label">Mis pedidos</div>
                <div class="quick-desc"><%= enEspera %> pendientes</div>
            </div>
        </a>
    </div>

    <!-- PEDIDOS RECIENTES -->
    <div class="card">
        <div class="card-header">
            <div class="section-title" style="margin:0">Mis pedidos recientes</div>
            <a href="MisPedidos.jsp" class="btn-link">Ver todos</a>
        </div>
        <% if (misPedidos.isEmpty()) { %>
            <div class="empty-msg">
                No tienes pedidos aun. Explora el catalogo y haz tu primer pedido.
            </div>
        <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>N Pedido</th>
                    <th>Total</th>
                    <th>Estado</th>
                    <th>Fecha</th>
                </tr>
            </thead>
            <tbody>
                <%
                    int count = 0;
                    for (int i = misPedidos.size() - 1; i >= 0 && count < 4; i--, count++) {
                        Pedido p = misPedidos.get(i);
                        String badgeClass = "en espera".equals(p.getEstado()) ? "badge-espera" :
                                           "entregado".equals(p.getEstado()) ? "badge-entregado" : "badge-cancelado";
                %>
                <tr>
                    <td><strong>#<%= String.format("%03d", p.getId()) %></strong></td>
                    <td>&#8353;<%= String.format("%,.0f", p.getTotal()) %></td>
                    <td><span class="badge <%= badgeClass %>"><%= p.getEstado() %></span></td>
                    <td><%= p.getFecha() != null ? p.getFecha().toString().substring(0,10) : "-" %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } %>
    </div>

</div>
</body>
</html>