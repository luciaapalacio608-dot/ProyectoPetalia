<%--
    Document   : GestionCatalogo
    Created on : 25 jun 2026
    Author     : lucia
--%>
<%@ page language="java" import="java.util.List, DAO.ProductoDAO, Model.Producto" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Petalia - Gestion de Catalogo</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <style>
        body { padding-top: 54px; padding-left: 230px; background: #f4f5f0; font-family: 'Segoe UI', Arial, sans-serif; color: #2c2c2a; min-height: 100vh; }
        .main-content { padding: 36px 40px; max-width: 1100px; }
        .page-header { display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 24px; flex-wrap: wrap; gap: 12px; }
        .page-title { font-family: 'Playfair Display', serif; font-size: 1.7rem; font-weight: 700; color: #3d4a26; }
        .page-title::after { content: ''; display: block; width: 48px; height: 2px; background: #7a8c4e; margin-top: 8px; border-radius: 2px; }
        .alert { padding: 12px 16px; border-radius: 6px; font-size: 0.88rem; font-weight: 600; margin-bottom: 20px; }
        .alert-success { background: #eaf3de; color: #3d4a26; border-left: 4px solid #7a8c4e; }
        .alert-danger  { background: #fdecea; color: #c0392b; border-left: 4px solid #e74c3c; }
        .search-bar { display: flex; gap: 12px; margin-bottom: 18px; flex-wrap: wrap; align-items: center; }
        .search-bar input, .search-bar select { padding: 9px 14px; border: 1.5px solid #c8cdb8; border-radius: 6px; font-family: 'Segoe UI', Arial, sans-serif; font-size: 0.87rem; background: #fff; color: #2c2c2a; outline: none; }
        .search-bar input { flex: 1; min-width: 180px; }
        .search-bar input:focus, .search-bar select:focus { border-color: #5c6b3a; }
        .btn { font-family: 'Segoe UI', Arial, sans-serif; font-size: 0.75rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; padding: 9px 18px; border-radius: 6px; border: none; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; transition: background 0.2s, transform 0.15s; }
        .btn:hover { transform: translateY(-1px); }
        .btn-primary { background: #3d4a26; color: #fff; }
        .btn-primary:hover { background: #5c6b3a; }
        .btn-sm { font-size: 0.7rem; padding: 6px 11px; }
        .btn-edit { background: #eaf3de; color: #3d4a26; border: 1px solid #c8cdb8; }
        .btn-edit:hover { background: #d4e6c0; }
        .btn-danger { background: #fdecea; color: #c0392b; border: 1px solid #f5c6c2; }
        .btn-danger:hover { background: #f5c6c2; }
        .btn-secondary { background: #f4f5f0; color: #5c6b3a; border: 1px solid #c8cdb8; }
        .btn-secondary:hover { background: #e8ead8; }
        .card { background: #fff; border: 1px solid #c8cdb8; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.07); overflow: hidden; }
        table { width: 100%; border-collapse: collapse; font-size: 0.88rem; }
        thead tr { background: #3d4a26; color: #e8ead8; }
        thead th { padding: 13px 16px; text-align: left; font-size: 0.74rem; font-weight: 700; letter-spacing: 0.12em; text-transform: uppercase; }
        tbody tr { border-bottom: 1px solid #f0f0ec; transition: background 0.15s; }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: #f7f8f4; }
        tbody tr:nth-child(even) { background: #fafaf7; }
        tbody tr:nth-child(even):hover { background: #f2f4ee; }
        tbody td { padding: 12px 16px; vertical-align: middle; }
        .product-img { width: 52px; height: 52px; object-fit: cover; border-radius: 6px; border: 1px solid #c8cdb8; }
        .img-placeholder { width: 52px; height: 52px; border-radius: 6px; border: 1px solid #c8cdb8; background: #eaf3de; display: flex; align-items: center; justify-content: center; font-size: 0.7rem; color: #5c6b3a; font-weight: 700; }
        .badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 0.68rem; font-weight: 700; text-transform: uppercase; background: #eaf3de; color: #3d4a26; border: 1px solid #c8cdb8; }
        .stock-low { color: #c0392b; font-weight: 700; }
        .actions-cell { display: flex; gap: 6px; align-items: center; }

        /* MODAL */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center; }
        .modal-overlay.open { display: flex; }
        .modal { background: #fff; border-radius: 10px; box-shadow: 0 12px 40px rgba(0,0,0,0.2); padding: 32px; width: 100%; max-width: 520px; max-height: 90vh; overflow-y: auto; animation: slideUp 0.25s ease; position: relative; }
        @keyframes slideUp { from { opacity:0; transform:translateY(20px); } to { opacity:1; transform:translateY(0); } }
        .modal-title { font-family: 'Playfair Display', serif; font-size: 1.2rem; font-weight: 700; color: #3d4a26; margin-bottom: 22px; padding-bottom: 12px; border-bottom: 1px solid #e8ead8; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; margin-bottom: 14px; }
        .form-group label { font-size: 0.76rem; font-weight: 700; color: #5c6b3a; letter-spacing: 0.06em; text-transform: uppercase; }
        .form-group input, .form-group select, .form-group textarea { padding: 9px 12px; border: 1.5px solid #c8cdb8; border-radius: 6px; font-family: 'Segoe UI', Arial, sans-serif; font-size: 0.88rem; color: #2c2c2a; background: #fafaf7; outline: none; transition: border-color 0.2s; width: 100%; }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { border-color: #5c6b3a; background: #fff; }
        .form-group textarea { resize: vertical; min-height: 72px; }
        .modal-footer { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; padding-top: 16px; border-top: 1px solid #f0f0ec; }
        .img-preview { width: 100%; max-height: 150px; object-fit: cover; border-radius: 6px; border: 1px solid #c8cdb8; display: none; margin-top: 8px; }
        .img-preview.visible { display: block; }
        .file-input-label { display: inline-flex; align-items: center; gap: 8px; padding: 8px 14px; background: #eaf3de; color: #3d4a26; border: 1.5px dashed #7a8c4e; border-radius: 6px; cursor: pointer; font-size: 0.82rem; font-weight: 600; transition: background 0.2s; }
        .file-input-label:hover { background: #d4e6c0; }
        input[type="file"] { display: none; }

        @media (max-width: 768px) { body { padding-left: 0; } .main-content { padding: 24px 16px; } .form-row { grid-template-columns: 1fr; } }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<%
    if (!rolNav.equals("admin")) { response.sendRedirect("Clientes.jsp"); return; }
    ProductoDAO productoDAO = new ProductoDAO();
    List<Producto> productos = productoDAO.listarTodos();
    String msg = request.getParameter("msg");
%>

<div class="main-content">

    <div class="page-header">
        <div class="page-title">Gestion de Catalogo</div>
        <button class="btn btn-primary" id="btnNuevoProducto">+ Nuevo producto</button>
    </div>

    <% if ("agregado".equals(msg)) { %>
        <div class="alert alert-success">Producto agregado correctamente.</div>
    <% } else if ("editado".equals(msg)) { %>
        <div class="alert alert-success">Producto actualizado correctamente.</div>
    <% } else if ("eliminado".equals(msg)) { %>
        <div class="alert alert-danger">Producto eliminado.</div>
    <% } %>

    <div class="search-bar">
        <input type="text" id="buscar-producto" placeholder="Buscar por nombre..." oninput="filtrarProductos()">
        <select id="filtrar-categoria" onchange="filtrarProductos()">
            <option value="">Todas las categorias</option>
            <%
                java.util.LinkedHashSet<String> cats = new java.util.LinkedHashSet<>();
                for (Producto p : productos) { if (p.getCategoria() != null) cats.add(p.getCategoria()); }
                for (String cat : cats) {
            %>
                <option value="<%= cat.toLowerCase() %>"><%= cat %></option>
            <% } %>
        </select>
    </div>

    <div class="card">
        <table>
            <thead>
                <tr>
                    <th>Imagen</th>
                    <th>Nombre</th>
                    <th>Categoria</th>
                    <th>Precio</th>
                    <th>Stock</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody id="tabla-productos">
                <% for (Producto p : productos) { %>
                <tr data-nombre="<%= p.getNombre().toLowerCase() %>"
                    data-cat="<%= p.getCategoria() != null ? p.getCategoria().toLowerCase() : "" %>">
                    <td>
                        <% if (p.getImagenUrl() != null && !p.getImagenUrl().isEmpty()) { %>
                            <img src="<%= p.getImagenUrl() %>" class="product-img"
                                 alt="<%= p.getNombre() %>"
                                 onerror="this.style.display='none'">
                        <% } else { %>
                            <div class="img-placeholder">SIN IMG</div>
                        <% } %>
                    </td>
                    <td>
                        <strong><%= p.getNombre() %></strong><br>
                        <span style="color:#888;font-size:0.8rem;">
                            <%= p.getDescripcion() != null ? p.getDescripcion() : "" %>
                        </span>
                    </td>
                    <td><span class="badge"><%= p.getCategoria() != null ? p.getCategoria() : "-" %></span></td>
                    <td>&#8353;<%= String.format("%,.0f", p.getPrecio()) %></td>
                    <td class="<%= p.getStock() <= 3 ? "stock-low" : "" %>"><%= p.getStock() %></td>
                    <td>
                        <div class="actions-cell">
                            <button class="btn btn-sm btn-edit" type="button"
                                onclick="abrirModalEditar(
                                    '<%= p.getId() %>',
                                    '<%= p.getNombre().replace("'", "\\'") %>',
                                    '<%= p.getDescripcion() != null ? p.getDescripcion().replace("'", "\\'") : "" %>',
                                    '<%= p.getPrecio() %>',
                                    '<%= p.getImagenUrl() != null ? p.getImagenUrl().replace("'", "\\'") : "" %>',
                                    '<%= p.getCategoria() != null ? p.getCategoria().replace("'", "\\'") : "" %>',
                                    '<%= p.getStock() %>'
                                )">
                                Editar
                            </button>
                            <form action="ProductoServlet" method="post"
                                  onsubmit="return confirm('Eliminar este producto?')"
                                  style="margin:0">
                                <input type="hidden" name="accion" value="eliminar">
                                <input type="hidden" name="id" value="<%= p.getId() %>">
                                <button type="submit" class="btn btn-sm btn-danger">Eliminar</button>
                            </form>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- MODAL AGREGAR -->
<div class="modal-overlay" id="modal-agregar">
    <div class="modal">
        <div class="modal-title">Nuevo producto</div>
        <form action="ProductoServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="accion" value="agregar">
            <div class="form-row">
                <div class="form-group">
                    <label>Nombre</label>
                    <input type="text" name="nombre" required placeholder="Ej: Ramo de Rosas">
                </div>
                <div class="form-group">
                    <label>Categoria</label>
                    <input type="text" name="categoria" required placeholder="Ej: Boda">
                </div>
            </div>
            <div class="form-group">
                <label>Descripcion</label>
                <textarea name="descripcion" placeholder="Descripcion del arreglo..."></textarea>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Precio</label>
                    <input type="number" name="precio" required min="0" step="100" placeholder="25000">
                </div>
                <div class="form-group">
                    <label>Stock</label>
                    <input type="number" name="stock" required min="0" placeholder="10">
                </div>
            </div>
            <div class="form-group">
                <label>Imagen</label>
                <label class="file-input-label" for="img-agregar">
                    Seleccionar imagen
                </label>
                <input type="file" id="img-agregar" name="imagen_file"
                       accept="image/*" onchange="previewImagen(this, 'preview-agregar')">
                <img id="preview-agregar" class="img-preview" src="" alt="Preview">
                <input type="text" name="imagen_url"
                       placeholder="O pega una URL de imagen"
                       style="margin-top:8px;">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="cerrarModales()">Cancelar</button>
                <button type="submit" class="btn btn-primary">Guardar producto</button>
            </div>
        </form>
    </div>
</div>

<!-- MODAL EDITAR -->
<div class="modal-overlay" id="modal-editar">
    <div class="modal">
        <div class="modal-title">Editar producto</div>
        <form action="ProductoServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="accion" value="editar">
            <input type="hidden" name="id" id="edit-id">
            <input type="hidden" name="imagen_url_actual" id="edit-imagen-actual">
            <div class="form-row">
                <div class="form-group">
                    <label>Nombre</label>
                    <input type="text" name="nombre" id="edit-nombre" required>
                </div>
                <div class="form-group">
                    <label>Categoria</label>
                    <input type="text" name="categoria" id="edit-categoria" required>
                </div>
            </div>
            <div class="form-group">
                <label>Descripcion</label>
                <textarea name="descripcion" id="edit-descripcion"></textarea>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Precio</label>
                    <input type="number" name="precio" id="edit-precio" required min="0" step="100">
                </div>
                <div class="form-group">
                    <label>Stock</label>
                    <input type="number" name="stock" id="edit-stock" required min="0">
                </div>
            </div>
            <div class="form-group">
                <label>Imagen actual</label>
                <img id="edit-preview-actual" class="img-preview visible"
                     src="" alt="Imagen actual"
                     style="max-height:100px;margin-bottom:8px;">
                <label class="file-input-label" for="img-editar">
                    Cambiar imagen
                </label>
                <input type="file" id="img-editar" name="imagen_file"
                       accept="image/*" onchange="previewImagen(this, 'preview-editar')">
                <img id="preview-editar" class="img-preview" src="" alt="Nueva imagen">
                <input type="text" name="imagen_url" id="edit-imagen-url"
                       placeholder="O pega una URL de imagen"
                       style="margin-top:8px;">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="cerrarModales()">Cancelar</button>
                <button type="submit" class="btn btn-primary">Guardar cambios</button>
            </div>
        </form>
    </div>
</div>

<script>
    document.getElementById('btnNuevoProducto').addEventListener('click', function() {
        document.getElementById('modal-agregar').classList.add('open');
    });

    function abrirModalEditar(id, nombre, desc, precio, img, cat, stock) {
        document.getElementById('edit-id').value            = id;
        document.getElementById('edit-nombre').value        = nombre;
        document.getElementById('edit-descripcion').value   = desc;
        document.getElementById('edit-precio').value        = precio;
        document.getElementById('edit-stock').value         = stock;
        document.getElementById('edit-categoria').value     = cat;
        document.getElementById('edit-imagen-actual').value = img;
        document.getElementById('edit-imagen-url').value    = img;

        var prevActual = document.getElementById('edit-preview-actual');
        if (img) {
            prevActual.src = img;
            prevActual.style.display = 'block';
        } else {
            prevActual.style.display = 'none';
        }
        document.getElementById('modal-editar').classList.add('open');
    }

    function cerrarModales() {
        document.getElementById('modal-agregar').classList.remove('open');
        document.getElementById('modal-editar').classList.remove('open');
    }

    document.querySelectorAll('.modal-overlay').forEach(function(overlay) {
        overlay.addEventListener('click', function(e) {
            if (e.target === this) cerrarModales();
        });
    });

    function previewImagen(input, previewId) {
        var preview = document.getElementById(previewId);
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                preview.classList.add('visible');
            };
            reader.readAsDataURL(input.files[0]);
        }
    }

    function filtrarProductos() {
        var q   = document.getElementById('buscar-producto').value.toLowerCase();
        var cat = document.getElementById('filtrar-categoria').value.toLowerCase();
        document.querySelectorAll('#tabla-productos tr').forEach(function(tr) {
            var matchNombre = tr.dataset.nombre && tr.dataset.nombre.includes(q);
            var matchCat    = !cat || tr.dataset.cat === cat;
            tr.style.display = matchNombre && matchCat ? '' : 'none';
        });
    }
</script>

</body>
</html>