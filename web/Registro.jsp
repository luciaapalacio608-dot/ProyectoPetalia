<%-- 
    Document   : Registro
    Created on : 23 jun 2026, 2:48:47 p. m.
    Author     : lucia
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Petalia - Crear cuenta</title>
<style>
* { box-sizing: border-box; margin: 0; padding: 0; }
body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f5f0; min-height: 100vh; display: grid; grid-template-columns: 1fr 1fr; }
.hero { position: relative; overflow: hidden; }
.hero img { width: 100%; height: 100%; object-fit: cover; }
.hero-overlay { position: absolute; inset: 0; background: linear-gradient(135deg, rgba(61,74,38,0.75) 0%, rgba(90,110,58,0.5) 100%); display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 2rem; text-align: center; }
.hero-brand { font-size: 48px; font-weight: 700; color: #fff; letter-spacing: 3px; }
.hero-brand span { color: #c8dd90; }
.hero-sub { font-size: 15px; color: #d8e4b8; margin-top: 0.5rem; }
.form-side { display: flex; align-items: center; justify-content: center; padding: 2rem; overflow-y: auto; }
.form-box { width: 100%; max-width: 400px; }
.form-title { font-size: 22px; font-weight: 700; color: #3d4a26; margin-bottom: 0.3rem; }
.form-sub { font-size: 13px; color: #888; margin-bottom: 1.75rem; }
.form-group { margin-bottom: 1rem; }
.form-group label { display: block; font-size: 12px; font-weight: 600; color: #555; margin-bottom: 5px; }
.form-group input, .form-group select { width: 100%; padding: 10px 14px; border: 0.5px solid #c8cdb8; border-radius: 8px; font-size: 14px; background: #fff; transition: border-color 0.15s, box-shadow 0.15s; }
.form-group input:focus, .form-group select:focus { outline: none; border-color: #7a8c4e; box-shadow: 0 0 0 3px rgba(122,140,78,0.15); }
#clave-admin-grupo { display: none; }
.btn-submit { width: 100%; padding: 11px; background: #5c6b3a; color: #fff; border: none; border-radius: 8px; font-size: 15px; font-weight: 600; cursor: pointer; transition: background 0.15s; margin-top: 0.5rem; }
.btn-submit:hover { background: #3d4a26; }
.link-login { display: block; text-align: center; margin-top: 1.25rem; font-size: 13px; color: #888; }
.link-login a { color: #5c6b3a; font-weight: 600; text-decoration: none; }
.alert { padding: 10px 14px; border-radius: 8px; font-size: 13px; margin-bottom: 1rem; }
.alert-error { background: #fcebeb; color: #a32d2d; border: 0.5px solid #f09595; }
@media (max-width: 700px) { body { grid-template-columns: 1fr; } .hero { height: 200px; } }
</style>
</head>
<body>
<div class="hero">
  <img src="https://images.unsplash.com/photo-1487530811015-780f0f29edcc?w=800&q=80" alt="Flores Petalia">
  <div class="hero-overlay">
    <div class="hero-brand">Pet<span>a</span>lia</div>
    <div class="hero-sub">Floristeria artesanal</div>
  </div>
</div>
<div class="form-side">
  <div class="form-box">
    <div class="form-title">Crear una cuenta</div>
    <div class="form-sub">Completa los datos para registrarte</div>
    <% String error = request.getParameter("error");
       if ("ClaveInvalida".equals(error)) { %>
      <div class="alert alert-error">La clave de administrador es incorrecta.</div>
    <% } else if ("fallo".equals(error)) { %>
      <div class="alert alert-error">No se pudo crear la cuenta. Intenta de nuevo.</div>
    <% } %>
    <form action="RegistroServlet" method="post">
      <div class="form-group">
        <label>Nombre completo</label>
        <input type="text" name="nombre" placeholder="Tu nombre" required>
      </div>
      <div class="form-group">
        <label>Correo electronico</label>
        <input type="email" name="email" placeholder="tu@correo.com" required>
      </div>
      <div class="form-group">
        <label>Contrasena</label>
        <input type="password" name="password" placeholder="••••••••" required minlength="4">
      </div>
      <div class="form-group">
        <label>Tipo de cuenta</label>
        <select name="rol" id="rol-select" onchange="toggleClaveAdmin()">
          <option value="cliente">Cliente</option>
          <option value="admin">Administrador</option>
        </select>
      </div>
      <div class="form-group" id="clave-admin-grupo">
        <label>Clave de administrador</label>
        <input type="password" name="claveAdmin" placeholder="Clave requerida">
      </div>
      <button type="submit" class="btn-submit">Crear cuenta</button>
    </form>
    <div class="link-login">Ya tienes cuenta? <a href="index.jsp">Iniciar sesion</a></div>
  </div>
</div>
<script>
function toggleClaveAdmin() {
  const rol = document.getElementById('rol-select').value;
  document.getElementById('clave-admin-grupo').style.display = rol === 'admin' ? 'block' : 'none';
}
</script>
</body>
</html>