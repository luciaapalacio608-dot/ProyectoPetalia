<%--
    Document   : navbar
    Created on : 24 jun 2026, 12:53:38 a. m.
    Author     : lucia
--%>
<%
    Model.Usuario usuarioNav = (Model.Usuario) session.getAttribute("usuario");
    if (usuarioNav == null) { response.sendRedirect("index.jsp"); return; }
    String rolNav = usuarioNav.getRol();
    String nombreNav = usuarioNav.getNombre();
    String inicialNav = nombreNav.substring(0, 1).toUpperCase();
    String paginaActual = request.getRequestURI();
%>
<style>
*{box-sizing:border-box;margin:0;padding:0}
:root{--olive:#5c6b3a;--olive-light:#7a8c4e;--olive-dark:#3d4a26;--olive-bg:#f4f5f0;--olive-border:#c8cdb8;--sidebar-w:230px;--topbar-h:54px}
body{font-family:'Segoe UI',Arial,sans-serif;background:var(--olive-bg);color:#2c2c2a;min-height:100vh;display:flex;flex-direction:column}
.topbar{position:fixed;top:0;left:0;right:0;z-index:100;background:var(--olive-dark);height:var(--topbar-h);display:flex;align-items:center;justify-content:space-between;padding:0 1.5rem}
.topbar-brand{font-size:20px;font-weight:600;color:#e8ead8;letter-spacing:1px}
.topbar-brand span{color:var(--olive-light)}
.topbar-right{display:flex;align-items:center;gap:12px}
.topbar-user{font-size:13px;color:#c8cdb8}
.topbar-avatar{width:32px;height:32px;border-radius:50%;background:var(--olive-light);display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:600;color:#fff}
.btn-logout{font-size:12px;padding:5px 12px;border:0.5px solid #8a9470;border-radius:6px;background:transparent;color:#c8cdb8;cursor:pointer;text-decoration:none;transition:background 0.15s}
.btn-logout:hover{background:rgba(255,255,255,0.08);color:#fff}
.sidebar{position:fixed;top:var(--topbar-h);left:0;bottom:0;width:var(--sidebar-w);background:var(--olive-dark);padding:1.25rem 0;overflow-y:auto;z-index:90}
.sidebar-label{font-size:10px;text-transform:uppercase;letter-spacing:1.2px;color:#6b7a52;padding:0 1rem;margin:1rem 0 0.4rem}
.nav-item{display:flex;align-items:center;gap:10px;padding:10px 1rem;margin:2px 0.5rem;border-radius:7px;font-size:13px;color:#b8c4a0;text-decoration:none;transition:background 0.15s,color 0.15s}
.nav-item:hover{background:rgba(255,255,255,0.07);color:#e8ead8}
.nav-item.active{background:var(--olive-light);color:#fff}
.nav-item svg{width:17px;height:17px;flex-shrink:0}
</style>

<div class="topbar">
  <span class="topbar-brand">Pet<span>a</span>lia</span>
  <div class="topbar-right">
    <span class="topbar-user"><%= nombreNav %></span>
    <div class="topbar-avatar"><%= inicialNav %></div>
    <a href="LogoutServlet" class="btn-logout">Cerrar sesion</a>
  </div>
</div>

<div class="sidebar">
  <div class="sidebar-label">Principal</div>

  <a href="<%= rolNav.equals("admin") ? "Admin.jsp" : "Clientes.jsp" %>"
     class="nav-item <%= paginaActual.contains("Admin") || paginaActual.contains("Clientes") ? "active" : "" %>">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/>
      <rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/>
    </svg>
    Inicio
  </a>

  <a href="CatalogoServlet"
     class="nav-item <%= paginaActual.contains("Catalogo") ? "active" : "" %>">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <path d="M12 22s-8-4.5-8-11.8A8 8 0 0 1 12 2a8 8 0 0 1 8 8.2c0 7.3-8 11.8-8 11.8z"/>
      <circle cx="12" cy="10" r="3"/>
    </svg>
    Catalogo de ramos
  </a>

  <a href="MisPedidos.jsp"
     class="nav-item <%= paginaActual.contains("MisPedidos") ? "active" : "" %>">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
      <line x1="3" y1="6" x2="21" y2="6"/>
      <path d="M16 10a4 4 0 0 1-8 0"/>
    </svg>
    Mis pedidos
  </a>

  <% if (rolNav.equals("admin")) { %>
  <div class="sidebar-label">Administracion</div>

  <a href="GestionCatalogo.jsp"
     class="nav-item <%= paginaActual.contains("GestionCatalogo") ? "active" : "" %>">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <path d="M12 2v20M2 12h20"/>
    </svg>
    Gestion catalogo
  </a>

  <a href="Empleados.jsp"
     class="nav-item <%= paginaActual.contains("Empleados") ? "active" : "" %>">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
      <circle cx="9" cy="7" r="4"/>
      <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
      <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
    </svg>
    Empleados
  </a>

  <a href="PedidosAdmin.jsp"
     class="nav-item <%= paginaActual.contains("PedidosAdmin") ? "active" : "" %>">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <polyline points="9 11 12 14 22 4"/>
      <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/>
    </svg>
    Gestion pedidos
  </a>

  <a href="Historial.jsp"
     class="nav-item <%= paginaActual.contains("Historial") ? "active" : "" %>">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <line x1="18" y1="20" x2="18" y2="10"/>
      <line x1="12" y1="20" x2="12" y2="4"/>
      <line x1="6" y1="20" x2="6" y2="14"/>
    </svg>
    Historial ventas
  </a>
  <% } %>
</div>