import { EstadoPedido, EstadoPago, TipoProducto } from './enums';
import { AddressDTO } from './shipping';

export interface CartItemDTO {
  id: string;
  productoId: string;
  nombre: string;
  tipo: TipoProducto;
  precio: number;
  imagen?: string;
  cantidad: number;
  disponible: boolean;
}

export interface CartDTO {
  id: string;
  usuarioId: string;
  items: CartItemDTO[];
  subtotal: number;
}

export interface OrderItemDTO {
  id: string;
  productoId: string;
  nombreProducto: string;
  tipoProducto: TipoProducto;
  cantidad: number;
  precioUnitario: number;
  subtotal: number;
}

export interface OrderDTO {
  id: string;
  folio: string;
  usuarioId: string;
  direccionSnapshot: AddressDTO;
  subtotal: number;
  costoEnvio: number;
  total: number;
  moneda: string;
  estado: EstadoPedido;
  notasCliente?: string | null;
  detalles: OrderItemDTO[];
  createdAt: string;
  updatedAt: string;
}

export interface CreateOrderCheckoutDTO {
  direccionId: string;
  notasCliente?: string;
}

export interface CheckoutSessionResponse {
  pedidoId: string;
  folio: string;
  clientSecret: string;
  total: number;
  moneda: string;
  expiraEn: string;
}

export interface PaymentWebhookEventDTO {
  tipoEvento: string;
  stripePaymentIntentId: string;
  monto: number;
  pedidoId: string;
  estado: EstadoPago;
}
