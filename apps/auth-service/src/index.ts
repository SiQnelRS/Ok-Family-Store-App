import express, { Request, Response } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { prisma } from '@ok-family/database';

dotenv.config();

const app = express();
const PORT = process.env.PORT_AUTH_SERVICE || 4001;

app.use(cors());
app.use(express.json());

app.get('/health', async (_req: Request, res: Response) => {
  try {
    // Verificación rápida de conexión a base de datos
    await prisma.$queryRaw`SELECT 1`;
    res.json({ status: 'ok', service: 'auth-service', db: 'connected' });
  } catch (error) {
    res.status(500).json({ status: 'error', service: 'auth-service', db: 'disconnected' });
  }
});

app.listen(PORT, () => {
  console.log(`[Auth Service] Escuchando en http://localhost:${PORT}`);
});
