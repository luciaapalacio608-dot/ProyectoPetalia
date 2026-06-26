<%-- 
    Document   : Empleados
    Created on : 24 jun 2026, 1:12:16 a. m.
    Author     : lucia
--%>
<%@ page language="java" import="java.util.List, DAO.UsuarioDAO, Model.Usuario" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Petalia - Empleados</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <style>
        body {
            padding-top: 54px;
            padding-left: 230px;
            background: #f4f5f0;
            font-family: 'Segoe UI', Arial, sans-serif;
            color: #2c2c2a;
            min-height: 100vh;
        }

        .main-content {
            padding: 36px 40px;
            max-width: 1100px;
        }

        .page-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.7rem;
            font-weight: 700;
            color: #3d4a26;
            letter-spacing: 0.03em;
            margin-bottom: 6px;
        }

        .page-title::after {
            content: '';
            display: block;
            width: 48px;
            height: 2px;
            background: #7a8c4e;
            margin-top: 8px;
            border-radius: 2px;
        }

        .alert-success {
            margin-top: 16px;
            background: #eaf3de;
            color: #3d4a26;
            border: 1px solid #c8cdb8;
            border-left: 4px solid #7a8c4e;
            border-radius: 6px;
            padding: 12px 16px;
            font-size: 0.88rem;
            font-weight: 600;
        }

        .search-bar {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 24px 0 18px;
            flex-wrap: wrap;
        }

        .search-bar input[type="text"] {
            flex: 1;
            min-width: 200px;
            padding: 9px 14px;
            border: 1.5px solid #c8cdb8;
            border-radius: 6px;
            font-size: 0.87rem;
            background: #fff;
            color: #2c2c2a;
            outline: none;
        }

        .search-bar select {
            padding: 9px 14px;
            border: 1.5px solid #c8cdb8;
            border-radius: 6px;
            font-size: 0.87rem;
            background: #fff;
            color: #2c2c2a;
            cursor: pointer;
        }

        .btn {
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            padding: 9px 18px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: background 0.2s;
        }

        .btn-primary { background: #3d4a26; color: #fff; }
        .btn-sm { font-size: 0.72rem; padding: 6px 12px; background: #eaf3de; color: #3d4a26; border: 1px solid #c8cdb8; }
        .btn-danger { background: #fdecea; color: #c0392b; border: 1px solid #f5c6c2; }

        .card {
            background: #fff;
            border: 1px solid #c8cdb8;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
            overflow: hidden;
        }

        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #3d4a26; color: #e8ead8; }
        thead th { padding: 13px 16px; text-align: left; font-size: 0.75rem; text-transform: uppercase; }
        tbody tr { border-bottom: 1px solid #f0f0ec; }
        tbody td { padding: 12px 16px; }

        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.45); z-index: 200; align-items: center; justify-content: center; }
        .modal-overlay.open { display: flex; }
        .modal { background: #fff; border-radius: 10px; padding: 32px; width: 100%; max-width: 480px; }
        
        @media (max-width: 768px) { body { padding-left: 0; } }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<%
    if (!rolNav.equals("admin")) { response.sendRedirect("Clientes.jsp"); return; }
    UsuarioDAO usuarioDAO2 = new UsuarioDAO();
    List<Usuario> usuarios = usuarioDAO2.listarTodos();
    String msg = request.getParameter("msg");
%>

<div class="main-content">
    <div class="page-title">Empleados y Clientes</div>

    <% if ("eliminado".equals(msg)) { %>
        <div class="alert-success">Usuario eliminado correctamente.</div>
    <% } else if ("editado".equals(msg)) { %>
        <div class="alert-success">Usuario actualizado correctamente.</div>
    <% } %>

    <div class="search-bar">
        <input type="text" id="buscar-usuario" placeholder="Filtrar por nombre o correo..." oninput="filtrarUsuarios()">
        <select id="filtrar-rol" onchange="filtrarUsuarios()">
            <option value="">Todos los roles</option>
            <option value="admin">Administradores</option>
            <option value="cliente">Clientes</option>
        </select>
        <a href="Registro.jsp" class="btn btn-primary">+ Agregar usuario</a>
    </div>

    <div class="card">
        <table id="tabla-usuarios">
            <thead>
                <tr>
                    <th>Nombre</th>
                    <th>Correo</th>
                    <th>Rol</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% for (Usuario u : usuarios) { %>
                <tr data-nombre="<%= u.getNombre().toLowerCase() %>" data-email="<%= u.getEmail().toLowerCase() %>" data-rol="<%= u.getRol() %>">
                    <td><%= u.getNombre() %></td>
                    <td><%= u.getEmail() %></td>
                    <td><%= u.getRol() %></td>
                    <td>
                        <button class="btn btn-sm" onclick="editarUsuario(<%= u.getId() %>, '<%= u.getNombre() %>', '<%= u.getEmail() %>', '<%= u.getRol() %>')">Editar</button>
                        <% if (u.getId() != usuarioNav.getId()) { %>
                        <form action="UsuarioServlet" method="post" onsubmit="return confirm('Eliminar usuario?')" style="display:inline;">
                            <input type="hidden" name="accion" value="eliminar">
                            <input type="hidden" name="id" value="<%= u.getId() %>">
                            <button type="submit" class="btn btn-sm btn-danger">Eliminar</button>
                        </form>
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<script>
function editarUsuario(id, nombre, email, rol) {
    document.getElementById('edit-id').value = id;
    document.getElementById('edit-nombre').value = nombre;
    document.getElementById('edit-email').value = email;
    document.getElementById('edit-rol').value = rol;
    document.getElementById('modal-editar').classList.add('open');
}
function cerrarModal() { document.getElementById('modal-editar').classList.remove('open'); }
function filtrarUsuarios() {
    const q = document.getElementById('buscar-usuario').value.toLowerCase();
    const rol = document.getElementById('filtrar-rol').value;
    document.querySelectorAll('#tabla-usuarios tbody tr').forEach(tr => {
        const matchQ = tr.dataset.nombre.includes(q) || tr.dataset.email.includes(q);
        const matchRol = !rol || tr.dataset.rol === rol;
        tr.style.display = matchQ && matchRol ? '' : 'none';
    });
}
</script>
</body>
</html>