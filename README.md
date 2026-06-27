Proyecto Petalia
1. Descripción del Proyecto
Proyecto desarrollado para el curso Desarrollo de Software III. El sistema "Petalia"
 es una solución web diseñada para la gestión integral de una floristería, permitiendo
 la administración de inventario, el registro de clientes y el control de pedidos en tiempo real.

3. Integrantes
   Lucia Palacio Ayerdis  C5I154

4. Tecnologías Utilizadas
Lenguaje: Java (JDK 17+)

Arquitectura: Patrón MVC (Modelo-Vista-Controlador) con capa de acceso a datos DAO.

Interfaz: JSP, HTML5, CSS3, JavaScript.

Base de Datos: MySQL.

Servidor: Apache Tomcat.

IDE: NetBeans.

4. Arquitectura del Sistema
El proyecto sigue una arquitectura de capas para asegurar la separación de responsabilidades:

Model: Clases que representan las entidades del negocio.

DAO (Data Access Object): Clases encargadas de la comunicación exclusiva con MySQL mediante JDBC.
5. Instrucciones de Instalación y Ejecución (Actualizado)
Clonar el repositorio: git clone https://github.com/luciaapalacio608-dot/ProyectoPetalia.git

Base de Datos: * Cree una base de datos en MySQL llamada floristeria_petalia.

Importe el archivo database/schema.sql dentro de esa base de datos.

Configuración: Abra el proyecto en NetBeans y localice el archivo Conexion.java dentro del paquete DAO.
Asegúrese de que la cadena de conexión apunte a jdbc:mysql://localhost:3306/floristeria_petalia.

Ejecución: Limpie, construya el proyecto y despliéguelo en Apache Tomcat.

6. Base de Datos
Script de creación: database/schema.sql

Datos iniciales: database/data.sql


7. Usuarios de Prueba
Administrador: admin / admin123

Cliente: cliente1 / 12345

8. Capturas del Sistema
Login:
<img width="1882" height="912" alt="image" src="https://github.com/user-attachments/assets/67ce51e3-81b4-49c2-bc5f-944c8bc91445" />

Entramos como Administrador 
<img width="1853" height="900" alt="image" src="https://github.com/user-attachments/assets/e9be2a1b-f179-47ef-b836-475a3d0edfe3" />

Catalogo: 
<img width="1827" height="907" alt="image" src="https://github.com/user-attachments/assets/b0e15d05-08b3-4945-aee5-e8d38fe2f4ea" />
 peidos desde administrador :
 <img width="1732" height="888" alt="image" src="https://github.com/user-attachments/assets/c072c483-8af8-4fae-b26a-13e729c905c4" />

gestion de Catalogo 

<img width="1902" height="870" alt="image" src="https://github.com/user-attachments/assets/6585525a-06d7-4742-872d-e2110f62458e" />
Gestion de empelado y clientes: 

<img width="1866" height="856" alt="image" src="https://github.com/user-attachments/assets/c2585bdc-290c-4a9b-9c7f-852689125fc5" />

Gestion de Pedidos: 
<img width="1847" height="852" alt="image" src="https://github.com/user-attachments/assets/e2cbfa69-71a4-4815-97fe-661499b6f196" />

Historial de ventas 

<img width="1857" height="870" alt="image" src="https://github.com/user-attachments/assets/43bd17ce-55ab-4b44-a551-628622c33a86" />



Controller (Servlets): Gestionan la lógica de negocio y el flujo de navegación.

View (JSP): Interfaz de usuario final.
