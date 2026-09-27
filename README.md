# Ok Family Store — Plataforma Web Distribuida

Plataforma de comercio electrónico diseñada para **Ok Family Store** (liquidaciones y devoluciones de tiendas de EE. UU. en Durango, Dgo.).

A diferencia de un e-commerce tradicional, el sistema está optimizado para **mercancía de disponibilidad limitada, piezas únicas y lotes cerrados sin resurtimiento**, con control estricto de concurrencia y prevención de doble venta.

---

## 📁 Estructura del Monorepo

```text
Ok_family_store_project/
├── apps/
│   ├── frontend/             # Aplicación web Next.js / React (Catálogo, Checkout, Admin)
│   ├── api-gateway/          # Punto de entrada único (Routing, CORS, Auth Guard)
│   ├── auth-service/         # Microservicio de usuarios, JWT y OAuth
│   ├── catalog-service/      # Microservicio de productos, lotes e imágenes
│   └── commerce-service/     # Carrito, pedidos, reservas, Stripe y cálculo de envíos
│
├── packages/
│   ├── database/             # Prisma ORM, migraciones y cliente PostgreSQL singleton
│   └── shared-types/         # DTOs, interfaces y enums compartidos en TypeScript
│
├── docs/
│   └── modelo-datos-er-y-relacional.md  # Modelo ER y Lógico Relacional detallado
│
├── docker-compose.yml        # PostgreSQL 16 y pgAdmin para desarrollo
├── ok-family-plan-arquitectura.md  # Plan maestro y requerimientos
├── .env.example              # Plantilla de variables de entorno
└── package.json              # Configuración de npm workspaces
```

---

## 🚀 Inicio Rápido en Desarrollo

### 1. Requisitos Previos
- **Node.js**: v20+ o v24+
- **Docker & Docker Compose** (para PostgreSQL local, o en su defecto un servicio PostgreSQL como Supabase/Neon)

### 2. Variables de Entorno
Copia el archivo de ejemplo para configurar el entorno:
```bash
cp .env.example .env
```

### 3. Levantar la Base de Datos (Docker)
```bash
docker compose up -d
```
Esto iniciará:
- **PostgreSQL** en el puerto `5432`
- **pgAdmin** en el puerto `5050` (http://localhost:5050 con `admin@okfamily.mx` / `admin`)

### 4. Generar y Sincronizar Prisma
```bash
npm run db:generate
npm run db:push
```
Para explorar los datos en el navegador con Prisma Studio:
```bash
npm run db:studio
```

---

## 🛡️ Prevención de Doble Venta y Concurrencia
Para piezas únicas y lotes limitados:
1. Durante el checkout se genera una **reserva temporal** en la base de datos con tiempo de expiración (15 minutos).
2. Se utiliza **bloqueo pesimista** (`SELECT ... FOR UPDATE`) para evitar que dos usuarios reserven la misma pieza.
3. Si el pago en Stripe se aprueba, el webhook oficial confirma el pedido y marca el producto como `VENDIDO`.
4. Si la reserva expira o el pago falla, la mercancía se libera automáticamente a `DISPONIBLE`.
