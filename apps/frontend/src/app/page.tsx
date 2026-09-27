import React from 'react';

export default function HomePage() {
  return (
    <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', minHeight: '100vh', padding: '2rem', textAlign: 'center' }}>
      <h1 style={{ fontSize: '2.5rem', fontWeight: 800, marginBottom: '1rem', color: '#f59e0b' }}>
        Ok Family Store
      </h1>
      <p style={{ maxWidth: '600px', fontSize: '1.1rem', color: '#94a3b8', lineHeight: '1.6' }}>
        Plataforma oficial para venta de mercancía exclusiva, piezas únicas y lotes provenientes de liquidaciones de EE. UU.
      </p>
      <div style={{ marginTop: '2rem', padding: '1rem 1.5rem', backgroundColor: '#1e293b', borderRadius: '8px', border: '1px solid #334155' }}>
        <p style={{ fontSize: '0.9rem', color: '#38bdf8' }}>
          📍 Blvd. de las Rosas 233, Jardines de Durango | 🕒 12:00 pm - 8:30 pm
        </p>
      </div>
    </div>
  );
}
