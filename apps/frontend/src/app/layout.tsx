import './globals.css';
import React from 'react';

export const metadata = {
  title: 'Ok Family Store — Liquidaciones y Devoluciones',
  description: 'Tienda exclusiva de liquidaciones, devoluciones y lotes de tiendas de EE. UU. en Durango.',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="es">
      <body>
        <main>{children}</main>
      </body>
    </html>
  );
}
