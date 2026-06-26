<%--
    Document   : index
    Created on : 23 jun 2026, 3:01:54 p. m.
    Author     : lucia
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Petalia - Iniciar sesion</title>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
<style>
* { box-sizing: border-box; margin: 0; padding: 0; }
body {
    font-family: 'Segoe UI', Arial, sans-serif;
    background: #f4f5f0;
    min-height: 100vh;
    display: grid;
    grid-template-columns: 1fr 1fr;
}

/* LADO IZQUIERDO */
.hero {
    background: linear-gradient(160deg, #3d4a26 0%, #5c6b3a 50%, #7a8c4e 100%);
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 3rem 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
}

/* Circulos decorativos */
.hero::before {
    content: '';
    position: absolute;
    width: 400px; height: 400px;
    border-radius: 50%;
    border: 1px solid rgba(255,255,255,0.06);
    top: -100px; left: -100px;
}
.hero::after {
    content: '';
    position: absolute;
    width: 300px; height: 300px;
    border-radius: 50%;
    border: 1px solid rgba(255,255,255,0.06);
    bottom: -80px; right: -80px;
}

/* Logo SVG floral */
.logo-wrap {
    position: relative;
    z-index: 1;
    margin-bottom: 28px;
}

.logo-wrap svg {
    width: 120px;
    height: 120px;
    filter: drop-shadow(0 4px 16px rgba(0,0,0,0.2));
}

.hero-brand {
    font-family: 'Playfair Display', serif;
    font-size: 52px;
    font-weight: 700;
    color: #fff;
    letter-spacing: 4px;
    position: relative;
    z-index: 1;
    line-height: 1;
}
.hero-brand span { color: #c8dd90; }
.hero-sub {
    font-size: 13px;
    color: #b8c4a0;
    margin-top: 10px;
    letter-spacing: 3px;
    text-transform: uppercase;
    position: relative;
    z-index: 1;
}

.hero-divider {
    width: 48px; height: 1px;
    background: rgba(255,255,255,0.2);
    margin: 20px auto;
    position: relative;
    z-index: 1;
}

.hero-tagline {
    font-size: 13px;
    color: #8fa870;
    font-style: italic;
    position: relative;
    z-index: 1;
    max-width: 240px;
}

/* LADO DERECHO */
.login-side {
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 2rem;
    background: #f4f5f0;
}

.login-box { width: 100%; max-width: 380px; }

.login-title {
    font-family: 'Playfair Display', serif;
    font-size: 24px;
    font-weight: 700;
    color: #3d4a26;
    margin-bottom: 4px;
}
.login-sub { font-size: 13px; color: #888; margin-bottom: 28px; }

.form-group { margin-bottom: 14px; }
.form-group label {
    display: block;
    font-size: 11px;
    font-weight: 700;
    color: #5c6b3a;
    letter-spacing: 0.1em;
    text-transform: uppercase;
    margin-bottom: 6px;
}
.form-group input {
    width: 100%;
    padding: 11px 14px;
    border: 1.5px solid #c8cdb8;
    border-radius: 8px;
    font-size: 14px;
    background: #fff;
    color: #2c2c2a;
    transition: border-color 0.15s, box-shadow 0.15s;
}
.form-group input:focus {
    outline: none;
    border-color: #7a8c4e;
    box-shadow: 0 0 0 3px rgba(122,140,78,0.15);
}

.btn-login {
    width: 100%;
    padding: 12px;
    background: #3d4a26;
    color: #fff;
    border: none;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 700;
    letter-spacing: 0.1em;
    text-transform: uppercase;
    cursor: pointer;
    transition: background 0.2s;
    margin-top: 6px;
}
.btn-login:hover { background: #5c6b3a; }

.divider {
    text-align: center;
    margin: 20px 0;
    font-size: 12px;
    color: #aaa;
    position: relative;
}
.divider::before, .divider::after {
    content: '';
    position: absolute;
    top: 50%;
    width: 42%;
    height: 0.5px;
    background: #ddd;
}
.divider::before { left: 0; }
.divider::after  { right: 0; }

.btn-register {
    width: 100%;
    padding: 11px;
    background: #fff;
    color: #5c6b3a;
    border: 1.5px solid #c8cdb8;
    border-radius: 8px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    text-align: center;
    display: block;
    text-decoration: none;
    transition: background 0.15s;
}
.btn-register:hover { background: #f4f5f0; }

.alert {
    padding: 11px 14px;
    border-radius: 8px;
    font-size: 13px;
    margin-bottom: 16px;
}
.alert-error   { background: #fcebeb; color: #a32d2d; border: 1px solid #f09595; }
.alert-success { background: #eaf3de; color: #3b6d11; border: 1px solid #c0dd97; }

@media (max-width: 700px) {
    body { grid-template-columns: 1fr; }
    .hero { height: 260px; padding: 2rem; }
    .hero-brand { font-size: 36px; }
    .logo-wrap svg { width: 80px; height: 80px; }
}
</style>
</head>
<body>

<!-- LADO IZQUIERDO -->
<div class="hero">
    <div class="logo-wrap">
        <!-- Logo floral SVG -->
        <svg viewBox="0 0 120 120" xmlns="http://www.w3.org/2000/svg">
            <!-- Petalo arriba -->
            <ellipse cx="60" cy="32" rx="10" ry="22" fill="rgba(255,255,255,0.18)" transform="rotate(0,60,60)"/>
            <!-- Petalo arriba-derecha -->
            <ellipse cx="60" cy="32" rx="10" ry="22" fill="rgba(255,255,255,0.15)" transform="rotate(45,60,60)"/>
            <!-- Petalo derecha -->
            <ellipse cx="60" cy="32" rx="10" ry="22" fill="rgba(255,255,255,0.18)" transform="rotate(90,60,60)"/>
            <!-- Petalo abajo-derecha -->
            <ellipse cx="60" cy="32" rx="10" ry="22" fill="rgba(255,255,255,0.15)" transform="rotate(135,60,60)"/>
            <!-- Petalo abajo -->
            <ellipse cx="60" cy="32" rx="10" ry="22" fill="rgba(255,255,255,0.18)" transform="rotate(180,60,60)"/>
            <!-- Petalo abajo-izquierda -->
            <ellipse cx="60" cy="32" rx="10" ry="22" fill="rgba(255,255,255,0.15)" transform="rotate(225,60,60)"/>
            <!-- Petalo izquierda -->
            <ellipse cx="60" cy="32" rx="10" ry="22" fill="rgba(255,255,255,0.18)" transform="rotate(270,60,60)"/>
            <!-- Petalo arriba-izquierda -->
            <ellipse cx="60" cy="32" rx="10" ry="22" fill="rgba(255,255,255,0.15)" transform="rotate(315,60,60)"/>
            <!-- Centro -->
            <circle cx="60" cy="60" r="14" fill="rgba(200,221,144,0.9)"/>
            <circle cx="60" cy="60" r="8"  fill="rgba(61,74,38,0.8)"/>
        </svg>
    </div>

    <div class="hero-brand">Pet<span>a</span>lia</div>
    <div class="hero-sub">Floristeria artesanal</div>
    <div class="hero-divider"></div>
    <div class="hero-tagline">Flores para cada momento especial de tu vida</div>
</div>

<!-- LADO DERECHO -->
<div class="login-side">
    <div class="login-box">
        <div class="login-title">Bienvenida de vuelta</div>
        <div class="login-sub">Ingresa a tu cuenta para continuar</div>

        <% String error = request.getParameter("error");
           String mensaje = request.getParameter("mensaje");
           if ("1".equals(error)) { %>
            <div class="alert alert-error">Correo o contrasena incorrectos.</div>
        <% } else if ("sesion_cerrada".equals(mensaje)) { %>
            <div class="alert alert-success">Sesion cerrada correctamente.</div>
        <% } else if ("exito".equals(mensaje)) { %>
            <div class="alert alert-success">Cuenta creada. Ya puedes ingresar.</div>
        <% } %>

        <form action="UsuarioServlet" method="post">
            <div class="form-group">
                <label>Correo electronico</label>
                <input type="email" name="email" placeholder="tu@correo.com" required>
            </div>
            <div class="form-group">
                <label>Contrasena</label>
                <input type="password" name="password" placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn-login">Ingresar</button>
        </form>

        <div class="divider">o</div>
        <a href="Registro.jsp" class="btn-register">Crear una cuenta</a>
    </div>
</div>

</body>
</html>