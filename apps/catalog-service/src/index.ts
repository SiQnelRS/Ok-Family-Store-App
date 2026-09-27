import express, { Request, Response } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { prisma } from '@ok-family/database';

dotenv.config();

const app = express();
const PORT = process.env.PORT_CATALOG_SERVICE || 4002;

app.use(cors());
app.use(express.json());

app.get('/health', async (_req: Request, res: Response) => {
  try {
    await prisma.$queryRaw`SELECT 1`;
    res.json({ status: 'ok', service: 'catalog-service', db: 'connected' });
  } catch (error) {
    res.status(500).json({ status: 'error', service: 'catalog-service', db: 'disconnected' });
  }
});

app.listen(PORT, () => {
  console.log(`[Catalog Service] Escuchando en http://localhost:${PORT}`);
});
