import express, { Request, Response } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { prisma } from '@ok-family/database';

dotenv.config();

const app = express();
const PORT = process.env.PORT_COMMERCE_SERVICE || 4003;

app.use(cors());
// Nota: los webhooks de Stripe requieren el cuerpo sin procesar (raw body),
// por lo que express.json() se configurará en las rutas que no sean webhooks.
app.use(express.json());

app.get('/health', async (_req: Request, res: Response) => {
  try {
    await prisma.$queryRaw`SELECT 1`;
    res.json({ status: 'ok', service: 'commerce-service', db: 'connected' });
  } catch (error) {
    res.status(500).json({ status: 'error', service: 'commerce-service', db: 'disconnected' });
  }
});

app.listen(PORT, () => {
  console.log(`[Commerce Service] Escuchando en http://localhost:${PORT}`);
});
