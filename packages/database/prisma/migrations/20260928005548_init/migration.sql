-- CreateEnum
CREATE TYPE "RolUsuario" AS ENUM ('CUSTOMER', 'ADMIN');

-- CreateEnum
CREATE TYPE "ProveedorAuth" AS ENUM ('LOCAL', 'GOOGLE', 'FACEBOOK');

-- CreateEnum
CREATE TYPE "TipoProducto" AS ENUM ('PRODUCTO', 'LOTE');

-- CreateEnum
CREATE TYPE "EstadoProducto" AS ENUM ('DISPONIBLE', 'RESERVADO', 'VENDIDO', 'OCULTO');

-- CreateEnum
CREATE TYPE "EstadoReserva" AS ENUM ('ACTIVA', 'CONFIRMADA_PAGADA', 'EXPIRADA', 'CANCELADA');

-- CreateEnum
CREATE TYPE "EstadoPedido" AS ENUM ('PENDIENTE_PAGO', 'PAGADO', 'PREPARANDO', 'LISTO_PARA_ENVIO', 'ENVIADO', 'ENTREGADO', 'CANCELADO', 'REEMBOLSADO');

-- CreateEnum
CREATE TYPE "EstadoPago" AS ENUM ('REQUIERE_ACCION', 'PROCESANDO', 'APROBADO', 'FALLIDO', 'CANCELADO');

-- CreateTable
CREATE TABLE "usuarios" (
    "id" UUID NOT NULL,
    "nombre" VARCHAR(150) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "password_hash" VARCHAR(255),
    "telefono" VARCHAR(20),
    "proveedor_auth" "ProveedorAuth" NOT NULL DEFAULT 'LOCAL',
    "proveedor_id" VARCHAR(255),
    "rol" "RolUsuario" NOT NULL DEFAULT 'CUSTOMER',
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "usuarios_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "direcciones" (
    "id" UUID NOT NULL,
    "usuario_id" UUID NOT NULL,
    "alias" VARCHAR(50) NOT NULL DEFAULT 'Casa',
    "nombre_receptor" VARCHAR(150) NOT NULL,
    "telefono" VARCHAR(20) NOT NULL,
    "calle" VARCHAR(200) NOT NULL,
    "num_exterior" VARCHAR(20) NOT NULL,
    "num_interior" VARCHAR(20),
    "colonia" VARCHAR(100) NOT NULL,
    "codigo_postal" VARCHAR(10) NOT NULL,
    "ciudad" VARCHAR(100) NOT NULL DEFAULT 'Durango',
    "estado" VARCHAR(100) NOT NULL DEFAULT 'Durango',
    "referencias" TEXT,
    "es_predeterminada" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "direcciones_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "zonas_cobertura" (
    "id" UUID NOT NULL,
    "codigo_postal" VARCHAR(10) NOT NULL,
    "nombre_zona" VARCHAR(100) NOT NULL,
    "costo_envio" DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    "tiempo_estimado" VARCHAR(50) NOT NULL DEFAULT '1 a 2 días hábiles',
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "zonas_cobertura_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categorias" (
    "id" UUID NOT NULL,
    "nombre" VARCHAR(100) NOT NULL,
    "slug" VARCHAR(120) NOT NULL,
    "descripcion" TEXT,
    "activo" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "categorias_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "productos" (
    "id" UUID NOT NULL,
    "categoria_id" UUID NOT NULL,
    "sku" VARCHAR(50),
    "nombre" VARCHAR(200) NOT NULL,
    "descripcion" TEXT NOT NULL,
    "tipo" "TipoProducto" NOT NULL DEFAULT 'PRODUCTO',
    "precio" DECIMAL(10,2) NOT NULL,
    "cantidad_stock" INTEGER NOT NULL DEFAULT 1,
    "cantidad_disponible" INTEGER NOT NULL DEFAULT 1,
    "estado" "EstadoProducto" NOT NULL DEFAULT 'DISPONIBLE',
    "version" INTEGER NOT NULL DEFAULT 0,
    "fecha_publicacion" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "productos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "imagenes_producto" (
    "id" UUID NOT NULL,
    "producto_id" UUID NOT NULL,
    "url" VARCHAR(500) NOT NULL,
    "public_id" VARCHAR(255),
    "orden" INTEGER NOT NULL DEFAULT 0,
    "es_portada" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "imagenes_producto_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "carritos" (
    "id" UUID NOT NULL,
    "usuario_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "carritos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "items_carrito" (
    "id" UUID NOT NULL,
    "carrito_id" UUID NOT NULL,
    "producto_id" UUID NOT NULL,
    "cantidad" INTEGER NOT NULL DEFAULT 1,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "items_carrito_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reservas_temporales" (
    "id" UUID NOT NULL,
    "producto_id" UUID NOT NULL,
    "usuario_id" UUID NOT NULL,
    "pedido_id" UUID,
    "cantidad" INTEGER NOT NULL DEFAULT 1,
    "estado" "EstadoReserva" NOT NULL DEFAULT 'ACTIVA',
    "expira_en" TIMESTAMPTZ NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "reservas_temporales_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pedidos" (
    "id" UUID NOT NULL,
    "folio" VARCHAR(30) NOT NULL,
    "usuario_id" UUID NOT NULL,
    "direccion_id" UUID,
    "direccion_snapshot" JSONB NOT NULL,
    "subtotal" DECIMAL(10,2) NOT NULL,
    "costo_envio" DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    "total" DECIMAL(10,2) NOT NULL,
    "moneda" VARCHAR(3) NOT NULL DEFAULT 'MXN',
    "estado" "EstadoPedido" NOT NULL DEFAULT 'PENDIENTE_PAGO',
    "notas_cliente" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "pedidos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "detalles_pedido" (
    "id" UUID NOT NULL,
    "pedido_id" UUID NOT NULL,
    "producto_id" UUID NOT NULL,
    "nombre_producto" VARCHAR(200) NOT NULL,
    "tipo_producto" "TipoProducto" NOT NULL,
    "cantidad" INTEGER NOT NULL DEFAULT 1,
    "precio_unitario" DECIMAL(10,2) NOT NULL,
    "subtotal" DECIMAL(10,2) NOT NULL,

    CONSTRAINT "detalles_pedido_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pagos" (
    "id" UUID NOT NULL,
    "pedido_id" UUID NOT NULL,
    "stripe_payment_intent_id" VARCHAR(255) NOT NULL,
    "stripe_client_secret" VARCHAR(255),
    "metodo_pago" VARCHAR(50) NOT NULL DEFAULT 'card',
    "monto" DECIMAL(10,2) NOT NULL,
    "moneda" VARCHAR(3) NOT NULL DEFAULT 'MXN',
    "estado" "EstadoPago" NOT NULL DEFAULT 'PROCESANDO',
    "ultimo_error" TEXT,
    "stripe_event_id" VARCHAR(255),
    "fecha_pago" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL,

    CONSTRAINT "pagos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "historial_pedidos" (
    "id" UUID NOT NULL,
    "pedido_id" UUID NOT NULL,
    "estado_anterior" VARCHAR(25),
    "estado_nuevo" VARCHAR(25) NOT NULL,
    "usuario_id" UUID,
    "nota" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "historial_pedidos_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "usuarios_email_key" ON "usuarios"("email");

-- CreateIndex
CREATE INDEX "direcciones_usuario_id_idx" ON "direcciones"("usuario_id");

-- CreateIndex
CREATE INDEX "direcciones_codigo_postal_idx" ON "direcciones"("codigo_postal");

-- CreateIndex
CREATE UNIQUE INDEX "zonas_cobertura_codigo_postal_key" ON "zonas_cobertura"("codigo_postal");

-- CreateIndex
CREATE UNIQUE INDEX "categorias_nombre_key" ON "categorias"("nombre");

-- CreateIndex
CREATE UNIQUE INDEX "categorias_slug_key" ON "categorias"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "productos_sku_key" ON "productos"("sku");

-- CreateIndex
CREATE INDEX "productos_categoria_id_idx" ON "productos"("categoria_id");

-- CreateIndex
CREATE INDEX "productos_estado_idx" ON "productos"("estado");

-- CreateIndex
CREATE INDEX "productos_tipo_idx" ON "productos"("tipo");

-- CreateIndex
CREATE INDEX "imagenes_producto_producto_id_idx" ON "imagenes_producto"("producto_id");

-- CreateIndex
CREATE UNIQUE INDEX "carritos_usuario_id_key" ON "carritos"("usuario_id");

-- CreateIndex
CREATE UNIQUE INDEX "items_carrito_carrito_id_producto_id_key" ON "items_carrito"("carrito_id", "producto_id");

-- CreateIndex
CREATE INDEX "reservas_temporales_producto_id_idx" ON "reservas_temporales"("producto_id");

-- CreateIndex
CREATE INDEX "reservas_temporales_estado_expira_en_idx" ON "reservas_temporales"("estado", "expira_en");

-- CreateIndex
CREATE UNIQUE INDEX "pedidos_folio_key" ON "pedidos"("folio");

-- CreateIndex
CREATE INDEX "pedidos_usuario_id_idx" ON "pedidos"("usuario_id");

-- CreateIndex
CREATE INDEX "pedidos_estado_idx" ON "pedidos"("estado");

-- CreateIndex
CREATE INDEX "pedidos_folio_idx" ON "pedidos"("folio");

-- CreateIndex
CREATE INDEX "detalles_pedido_pedido_id_idx" ON "detalles_pedido"("pedido_id");

-- CreateIndex
CREATE UNIQUE INDEX "pagos_stripe_payment_intent_id_key" ON "pagos"("stripe_payment_intent_id");

-- CreateIndex
CREATE INDEX "pagos_pedido_id_idx" ON "pagos"("pedido_id");

-- CreateIndex
CREATE INDEX "pagos_stripe_payment_intent_id_idx" ON "pagos"("stripe_payment_intent_id");

-- CreateIndex
CREATE INDEX "historial_pedidos_pedido_id_idx" ON "historial_pedidos"("pedido_id");

-- AddForeignKey
ALTER TABLE "direcciones" ADD CONSTRAINT "direcciones_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "productos" ADD CONSTRAINT "productos_categoria_id_fkey" FOREIGN KEY ("categoria_id") REFERENCES "categorias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "imagenes_producto" ADD CONSTRAINT "imagenes_producto_producto_id_fkey" FOREIGN KEY ("producto_id") REFERENCES "productos"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "carritos" ADD CONSTRAINT "carritos_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "items_carrito" ADD CONSTRAINT "items_carrito_carrito_id_fkey" FOREIGN KEY ("carrito_id") REFERENCES "carritos"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "items_carrito" ADD CONSTRAINT "items_carrito_producto_id_fkey" FOREIGN KEY ("producto_id") REFERENCES "productos"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reservas_temporales" ADD CONSTRAINT "reservas_temporales_producto_id_fkey" FOREIGN KEY ("producto_id") REFERENCES "productos"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reservas_temporales" ADD CONSTRAINT "reservas_temporales_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reservas_temporales" ADD CONSTRAINT "reservas_temporales_pedido_id_fkey" FOREIGN KEY ("pedido_id") REFERENCES "pedidos"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pedidos" ADD CONSTRAINT "pedidos_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pedidos" ADD CONSTRAINT "pedidos_direccion_id_fkey" FOREIGN KEY ("direccion_id") REFERENCES "direcciones"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "detalles_pedido" ADD CONSTRAINT "detalles_pedido_pedido_id_fkey" FOREIGN KEY ("pedido_id") REFERENCES "pedidos"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "detalles_pedido" ADD CONSTRAINT "detalles_pedido_producto_id_fkey" FOREIGN KEY ("producto_id") REFERENCES "productos"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pagos" ADD CONSTRAINT "pagos_pedido_id_fkey" FOREIGN KEY ("pedido_id") REFERENCES "pedidos"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "historial_pedidos" ADD CONSTRAINT "historial_pedidos_pedido_id_fkey" FOREIGN KEY ("pedido_id") REFERENCES "pedidos"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "historial_pedidos" ADD CONSTRAINT "historial_pedidos_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE SET NULL ON UPDATE CASCADE;
