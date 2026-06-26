<%--
    Document   : Catalogo
    Created on : 25 jun 2026
    Author     : lucia
--%>
<%@ page import="java.util.List, java.util.LinkedHashSet, Model.Producto" contentType="text/html;charset=UTF-8" language="java" %>
<%
    out.println("Productos recibidos: " + (request.getAttribute("productos") == null ? "NULL" : "OK"));
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catálogo de Flores</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --olive:        #5c6b3a;
            --olive-light:  #7a8c4e;
            --olive-dark:   #3d4a26;
            --olive-bg:     #f4f5f0;
            --olive-border: #c8cdb8;
            --sidebar-w:    230px;
            --topbar-h:     54px;
            --white:        #ffffff;
            --charcoal:     #2c2c2a;
            --gray-mid:     #666660;
            --gray-light:   #a8ad98;
            --gold:         #b8a840;
            --shadow-sm:    0 2px 8px rgba(0,0,0,0.08);
            --shadow-lg:    0 10px 32px rgba(0,0,0,0.14);
            --transition:   0.22s ease;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: var(--olive-bg);
            color: var(--charcoal);
            min-height: 100vh;
            padding-top: var(--topbar-h);
            padding-left: var(--sidebar-w);
        }

        /* ===== HEADER ===== */
        .catalog-header {
            text-align: center;
            padding: 48px 24px 28px;
        }
        .eyebrow {
            display: inline-block;
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 0.22em;
            text-transform: uppercase;
            color: var(--gold);
            margin-bottom: 10px;
        }
        .catalog-header h1 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(1.8rem, 3.5vw, 2.8rem);
            font-weight: 700;
            color: var(--olive-dark);
            letter-spacing: 0.04em;
        }
        .catalog-header p {
            margin-top: 10px;
            font-size: 0.9rem;
            color: var(--gray-mid);
            font-weight: 300;
        }
        .divider {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            margin: 22px auto 0;
            max-width: 200px;
        }
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--olive-border);
        }
        .divider span { color: var(--olive-light); font-size: 0.9rem; }

        /* ===== FILTROS ===== */
        .filter-section {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 8px;
            padding: 24px 24px 12px;
        }
        .filter-btn {
            font-family: 'Segoe UI', Arial, sans-serif;
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.14em;
            text-transform: uppercase;
            padding: 8px 20px;
            border: 1.5px solid var(--olive);
            background: transparent;
            color: var(--olive);
            cursor: pointer;
            border-radius: 6px;
            transition: background var(--transition), color var(--transition);
        }
        .filter-btn:hover,
        .filter-btn.active {
            background: var(--olive-dark);
            border-color: var(--olive-dark);
            color: var(--white);
        }

        /* ===== SECCIÓN CATEGORÍA ===== */
        .category-block { padding: 32px 32px 8px; }
        .category-block.hidden { display: none; }
        .category-title {
            font-family: 'Playfair Display', serif;
            font-size: clamp(1.3rem, 2.5vw, 1.8rem);
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            text-align: center;
            color: var(--olive-dark);
            margin-bottom: 24px;
        }
        .category-title::after {
            content: '';
            display: block;
            width: 48px;
            height: 2px;
            background: var(--olive-light);
            margin: 10px auto 0;
            border-radius: 2px;
        }

        /* ===== GRID ===== */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 22px;
            padding: 0 32px 48px;
        }

        /* ===== TARJETA ===== */
        .product-card {
            background: var(--white);
            border-radius: 8px;
            box-shadow: var(--shadow-sm);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            border: 1px solid var(--olive-border);
            transition: box-shadow var(--transition), transform var(--transition);
        }
        .product-card:hover {
            box-shadow: var(--shadow-lg);
            transform: translateY(-4px);
        }
        .card-img-wrap {
            position: relative;
            width: 100%;
            padding-top: 72%;
            overflow: hidden;
            background: var(--olive-bg);
        }
        .card-img-wrap img {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .product-card:hover .card-img-wrap img { transform: scale(1.06); }

        .badge-agotado {
            position: absolute;
            top: 10px;
            left: 10px;
            background: rgba(61,74,38,0.88);
            color: var(--white);
            font-size: 0.64rem;
            font-weight: 700;
            letter-spacing: 0.13em;
            text-transform: uppercase;
            padding: 3px 9px;
            border-radius: 4px;
        }

        .card-body {
            padding: 16px 16px 20px;
            display: flex;
            flex-direction: column;
            flex: 1;
            gap: 6px;
        }
        .card-name {
            font-family: 'Playfair Display', serif;
            font-size: 0.92rem;
            font-weight: 600;
            color: var(--olive-dark);
            letter-spacing: 0.04em;
            text-transform: uppercase;
            line-height: 1.3;
        }
        .card-desc {
            font-size: 0.78rem;
            color: var(--gray-mid);
            font-weight: 300;
            line-height: 1.5;
            flex: 1;
        }
        .card-price {
            font-size: 0.95rem;
            font-weight: 700;
            color: var(--olive-dark);
            margin-top: 4px;
        }
        .card-price .iva {
            font-size: 0.68rem;
            font-weight: 400;
            color: var(--gray-light);
            margin-left: 3px;
        }

        /* ===== CARRITO ===== */
        .card-cart-row {
            display: flex;
            align-items: stretch;
            gap: 8px;
            margin-top: 12px;
        }
        .qty-input {
            width: 50px;
            text-align: center;
            border: 1.5px solid var(--olive-border);
            border-radius: 6px;
            font-family: 'Segoe UI', Arial, sans-serif;
            font-size: 0.87rem;
            color: var(--charcoal);
            background: var(--olive-bg);
            padding: 7px 4px;
            outline: none;
            transition: border-color var(--transition);
        }
        .qty-input:focus { border-color: var(--olive); }
        .btn-cart {
            flex: 1;
            background: var(--olive-dark);
            color: var(--white);
            border: none;
            border-radius: 6px;
            font-family: 'Segoe UI', Arial, sans-serif;
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            cursor: pointer;
            padding: 8px 10px;
            transition: background var(--transition);
        }
        .btn-cart:hover { background: var(--olive); }
        .btn-cart:disabled { opacity: 0.4; cursor: not-allowed; }

        /* ===== EMPTY ===== */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--gray-mid);
        }
        .empty-state p {
            font-family: 'Playfair Display', serif;
            font-size: 1.05rem;
        }

        /* ===== TOAST ===== */
        #toast {
            position: fixed;
            bottom: 24px;
            right: 24px;
            background: var(--olive-dark);
            color: var(--white);
            font-size: 0.82rem;
            padding: 12px 18px;
            border-radius: 7px;
            box-shadow: var(--shadow-lg);
            opacity: 0;
            transform: translateY(10px);
            transition: opacity 0.3s ease, transform 0.3s ease;
            pointer-events: none;
            z-index: 999;
            max-width: 240px;
        }
        #toast.show { opacity: 1; transform: translateY(0); }

        /* ===== FOOTER ===== */
        .catalog-footer {
            text-align: center;
            padding: 18px;
            font-size: 0.72rem;
            color: var(--gray-light);
            letter-spacing: 0.08em;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            body { padding-left: 0; }
            .product-grid  { padding: 0 16px 40px; gap: 16px; }
            .category-block { padding: 24px 16px 8px; }
        }
        @media (max-width: 480px) {
            .product-grid { grid-template-columns: 1fr 1fr; gap: 12px; }
            .card-desc    { display: none; }
            .card-name    { font-size: 0.78rem; }
        }
        @media (max-width: 360px) {
            .product-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<%
    List<Producto> productos = (List<Producto>) request.getAttribute("productos");
    LinkedHashSet<String> categorias = new LinkedHashSet<>();
    if (productos != null) {
        for (Producto p : productos) {
            if (p.getCategoria() != null && !p.getCategoria().isEmpty()) {
                categorias.add(p.getCategoria());
            }
        }
    }
%>

<!-- HEADER -->
<header class="catalog-header">
    <span class="eyebrow">Colección</span>
    <h1>Catálogo de Flores</h1>
    <p>Diseños únicos para cada momento especial.</p>
    <div class="divider"><span>✦</span></div>
</header>

<!-- FILTROS -->
<div class="filter-section">
    <button class="filter-btn active" data-cat="all">Todos</button>
    <% for (String cat : categorias) { %>
        <button class="filter-btn" data-cat="<%= cat %>"><%= cat %></button>
    <% } %>
</div>

<!-- PRODUCTOS -->
<%
    if (productos == null || productos.isEmpty()) {
%>
    <div class="empty-state">
        <p>No hay productos disponibles en este momento.</p>
    </div>
<%
    } else {
        for (String cat : categorias) {
%>
<section class="category-block" data-section="<%= cat %>">
    <h2 class="category-title"><%= cat %></h2>
    <div class="product-grid">
        <%
            for (Producto p : productos) {
                if (!cat.equals(p.getCategoria())) continue;
                String imgSrc = (p.getImagenUrl() != null && !p.getImagenUrl().isEmpty())
                                ? p.getImagenUrl() : "img/placeholder.jpg";
                boolean inStock = p.getStock() > 0;
                String precio = String.format("%,.0f", p.getPrecio());
        %>
        <article class="product-card">
            <div class="card-img-wrap">
                <img src="<%= imgSrc %>"
                     alt="<%= p.getNombre() %>"
                     loading="lazy"
                     onerror="this.src='img/placeholder.jpg'">
                <% if (!inStock) { %>
                    <span class="badge-agotado">Agotado</span>
                <% } %>
            </div>
            <div class="card-body">
                <h3 class="card-name"><%= p.getNombre() %></h3>
                <p class="card-desc"><%= p.getDescripcion() != null ? p.getDescripcion() : "" %></p>
                <p class="card-price">
                    &#8353;<%= precio %>
                    <span class="iva">+ IVA</span>
                </p>
                <div class="card-cart-row">
                    <input class="qty-input" type="number" min="1"
                           max="<%= p.getStock() %>" value="1"
                           <%= !inStock ? "disabled" : "" %>>
                    <button class="btn-cart"
                            data-id="<%= p.getId() %>"
                            data-nombre="<%= p.getNombre() %>"
                            <%= !inStock ? "disabled" : "" %>>
                        Añadir al carrito
                    </button>
                </div>
            </div>
        </article>
        <% } %>
    </div>
</section>
<%
        }
    }
%>

<footer class="catalog-footer">✦ &nbsp; Petalia &nbsp;·&nbsp; Todos los derechos reservados</footer>
<div id="toast"></div>

<script>
(function () {
    // Filtros
    const btns     = document.querySelectorAll('.filter-btn');
    const sections = document.querySelectorAll('.category-block');

    btns.forEach(btn => {
        btn.addEventListener('click', function () {
            btns.forEach(b => b.classList.remove('active'));
            this.classList.add('active');
            const cat = this.dataset.cat;
            sections.forEach(sec => {
                sec.classList.toggle('hidden', cat !== 'all' && sec.dataset.section !== cat);
            });
        });
    });

    // Carrito
    document.querySelectorAll('.btn-cart').forEach(btn => {
        btn.addEventListener('click', function () {
            if (this.disabled) return;
            const qty    = this.closest('.product-card').querySelector('.qty-input').value;
            const id     = this.dataset.id;
            const nombre = this.dataset.nombre;

            fetch('PedidoServlet', {
                method : 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body   : 'accion=hacer_pedido&producto_id=' + id + '&cantidad=' + qty
            })
            .then(() => showToast('"' + nombre + '" añadido al carrito ✓'))
            .catch(() => showToast('"' + nombre + '" añadido al carrito ✓'));
        });
    });

    // Toast
    const toast = document.getElementById('toast');
    let timer;
    function showToast(msg) {
        toast.textContent = msg;
        toast.classList.add('show');
        clearTimeout(timer);
        timer = setTimeout(() => toast.classList.remove('show'), 2800);
    }
})();
</script>

</body>
</html>