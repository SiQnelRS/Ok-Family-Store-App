import express, { Request, Response } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import proxy from 'express-http-proxy';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT_API_GATEWAY || 4000;

app.use(helmet());
app.use(cors());
app.use(morgan('dev'));

// Endpoints directos de Gateway
app.get('/health', (_req: Request, res: Response) => {
  res.json({
    status: 'ok',
    service: 'api-gateway',
    timestamp: new Date().toISOString(),
  });
});

// Enrutamiento hacia microservicios
const AUTH_SERVICE_URL = process.env.AUTH_SERVICE_URL || 'http://localhost:4001';
const CATALOG_SERVICE_URL = process.env.CATALOG_SERVICE_URL || 'http://localhost:4002';
const COMMERCE_SERVICE_URL = process.env.COMMERCE_SERVICE_URL || 'http://localhost:4003';

app.use('/api/auth', proxy(AUTH_SERVICE_URL));
app.use('/api/catalog', proxy(CATALOG_SERVICE_URL));
app.use('/api/commerce', proxy(COMMERCE_SERVICE_URL));

app.listen(PORT, () => {
  console.log(`[API Gateway] Escuchando en http://localhost:${PORT}`);
});
