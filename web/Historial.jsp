<%-- 
    Document   : Historial
    Created on : 24 jun 2026, 1:12:55 a. m.
    Author     : lucia
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, DAO.PedidoDAO, Model.Pedido" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Petalia - Historial de Ventas</title>
    <style>
        .main-content { padding: 36px 40px; margin-left: 230px; }
        .page-title { font-size: 1.6rem; font-weight: 700; color: #3d4a26; margin-bottom: 24px; }
        
        /* Stats Grid */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 30px; }
        .stat-card { background: #fff; padding: 20px; border-radius: 10px; border: 1px solid #c8cdb8; }
        .stat-label { font-size: 0.75rem; color: #5c6b3a; text-transform: uppercase; font-weight: bold; }
        .stat-value { font-size: 1.5rem; font-weight: 700; color: #2c2c2a; }

        /* Tabla y Filtros */
        .search-bar { display: flex; gap: 10px; margin-bottom: 20px; }
        .search-bar input, .search-bar select { padding: 8px 12px; border: 1px solid #c8cdb8; border-radius: 6px; }
        
        table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        th { background: #f4f5f0; padding: 15px; text-align: left; font-size: 0.85rem; color: #3d4a26; }
        td { padding: 15px; border-top: 1px solid #eee; font-size: 0.9rem; }
        
        /* Badges */
        .badge { padding: 4px 8px; border-radius: 4px; font-size: 0.75rem; font-weight: bold; }
        .badge-entregado { background: #d4edda; color: #155724; }
        .badge-espera { background: #fff3cd; color: #856404; }
        .badge-cancelado { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<%
    if (!"admin".equals(rolNav)) { response.sendRedirect("index.jsp"); return; }
    PedidoDAO pedidoDAO = new PedidoDAO();
    List<Pedido> todos = pedidoDAO.listarTodos();
    double totalVentas = 0;
    int totalEntregados = 0, totalCancelados = 0;
    for (Pedido p : todos) {
        if ("entregado".equals(p.getEstado())) { totalVentas += p.getTotal(); totalEntregados++; }
        else if ("cancelado".equals(p.getEstado())) totalCancelados++;
    }
    double promedio = totalEntregados > 0 ? totalVentas / totalEntregados : 0;
%>
<div class="main-content">
  <div class="page-title">Historial de ventas</div>
  
  <div class="stats-grid">
    <div class="stat-card">
      <div class="stat-label">Total en ventas</div>
      <div class="stat-value">&#8353;<%= String.format("%,.0f", totalVentas) %></div>
    </div>
    <div class="stat-card">
      <div class="stat-label">Pedidos completados</div>
      <div class="stat-value"><%= totalEntregados %></div>
    </div>
    <div class="stat-card">
      <div class="stat-label">Promedio por pedido</div>
      <div class="stat-value">&#8353;<%= String.format("%,.0f", promedio) %></div>
    </div>
    <div class="stat-card">
      <div class="stat-label">Cancelados</div>
      <div class="stat-value"><%= totalCancelados %></div>
    </div>
  </div>

  <div class="search-bar">
    <input type="text" id="buscar-hist" placeholder="N° de pedido..." oninput="filtrarHist()">
    <select id="filtrar-hist-estado" onchange="filtrarHist()">
      <option value="">Todos los estados</option>
      <option value="entregado">Entregados</option>
      <option value="en espera">En espera</option>
      <option value="cancelado">Cancelados</option>
    </select>
  </div>

  <table>
    <thead>
      <tr><th>N pedido</th><th>Usuario</th><th>Total</th><th>Estado</th><th>Fecha</th></tr>
    </thead>
    <tbody id="tabla-historial">
      <% for (Pedido p : todos) {
             String badge = "en espera".equals(p.getEstado()) ? "badge-espera" :
                            "entregado".equals(p.getEstado()) ? "badge-entregado" : "badge-cancelado"; %>
      <tr data-id="<%= p.getId() %>" data-estado="<%= p.getEstado() %>">
        <td><strong>#<%= String.format("%03d", p.getId()) %></strong></td>
        <td>ID <%= p.getIdCliente() %></td>
        <td>&#8353;<%= String.format("%,.0f", p.getTotal()) %></td>
        <td><span class="badge <%= badge %>"><%= p.getEstado().toUpperCase() %></span></td>
        <td><%= p.getFecha() != null ? p.getFecha().toString().substring(0,10) : "-" %></td>
      </tr>
      <% } %>
    </tbody>
  </table>
</div>

<script>
function filtrarHist() {
  const q = document.getElementById('buscar-hist').value.toLowerCase();
  const estado = document.getElementById('filtrar-hist-estado').value;
  document.querySelectorAll('#tabla-historial tr').forEach(tr => {
    const matchQ = !q || tr.dataset.id.includes(q);
    const matchE = !estado || tr.dataset.estado === estado;
    tr.style.display = matchQ && matchE ? '' : 'none';
  });
}
</script>
</body>
</html>