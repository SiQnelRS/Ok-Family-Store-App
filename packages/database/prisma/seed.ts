import { PrismaClient, RolUsuario, ProveedorAuth } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Iniciando carga de datos semilla (Seed)...');

  // 1. Zonas de Cobertura en Durango
  const zonas = [
    { codigoPostal: '34200', nombreZona: 'Jardines de Durango y alrededores', costoEnvio: 60.0, tiempoEstimado: 'Mismo día o 24 hrs' },
    { codigoPostal: '34000', nombreZona: 'Zona Centro Durango', costoEnvio: 70.0, tiempoEstimado: '1 a 2 días hábiles' },
    { codigoPostal: '34100', nombreZona: 'Fraccionamientos Oriente', costoEnvio: 80.0, tiempoEstimado: '1 a 2 días hábiles' },
    { codigoPostal: '34220', nombreZona: 'Zona Sur Durango', costoEnvio: 80.0, tiempoEstimado: '1 a 2 días hábiles' },
  ];

  for (const zona of zonas) {
    await prisma.zonaCobertura.upsert({
      where: { codigoPostal: zona.codigoPostal },
      update: {},
      create: zona,
    });
  }
  console.log('✅ Zonas de cobertura verificadas.');

  // 2. Categorías Principales
  const categorias = [
    { nombre: 'Calzado y Tenis', slug: 'calzado-y-tenis', descripcion: 'Tenis y calzado de liquidación de marcas reconocidas.' },
    { nombre: 'Ropa Dama', slug: 'ropa-dama', descripcion: 'Prendas de liquidación para mujer.' },
    { nombre: 'Ropa Caballero', slug: 'ropa-caballero', descripcion: 'Prendas de liquidación para hombre.' },
    { nombre: 'Hogar y Decoración', slug: 'hogar-y-decoracion', descripcion: 'Artículos para casa, blancos y cocina.' },
    { nombre: 'Electrónica y Accesorios', slug: 'electronica-y-accesorios', descripcion: 'Gadgets, audio y periféricos.' },
    { nombre: 'Lotes Especiales', slug: 'lotes-especiales', descripcion: 'Lotes cerrados de varias piezas a precio de mayoreo.' },
  ];

  for (const cat of categorias) {
    await prisma.categoria.upsert({
      where: { slug: cat.slug },
      update: {},
      create: cat,
    });
  }
  console.log('✅ Categorías creadas exitosamente.');

  // 3. Usuario Administrador Inicial
  // Nota: Contraseña hasheada temporal de demostración para 'admin123456'
  // $2a$10$wN1FvMfvV3N7v29L9zUaG.h1VqU5Z4Wk7B.2n9x2u6h4f1e5m0o9a
  const adminEmail = 'admin@okfamily.mx';
  await prisma.usuario.upsert({
    where: { email: adminEmail },
    update: {},
    create: {
      nombre: 'Administrador Ok Family',
      email: adminEmail,
      passwordHash: '$2a$10$rQ0jN7oE8uPZgA5tW2aL0.9vVjYk6Pz9w0l7K4jM1oP2e4m6n8p1q', // Hash de 'admin123456'
      telefono: '6181234567',
      proveedorAuth: ProveedorAuth.LOCAL,
      rol: RolUsuario.ADMIN,
      activo: true,
    },
  });
  console.log(`✅ Usuario Administrador listo: ${adminEmail}`);

  console.log('✨ Seed completado con éxito.');
}

main()
  .catch((e) => {
    console.error('❌ Error en el seed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
