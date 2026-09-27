export interface AddressDTO {
  id: string;
  usuarioId: string;
  alias: string;
  nombreReceptor: string;
  telefono: string;
  calle: string;
  numExterior: string;
  numInterior?: string | null;
  colonia: string;
  codigoPostal: string;
  ciudad: string;
  estado: string;
  referencias?: string | null;
  esPredeterminada: boolean;
}

export interface CreateAddressDTO {
  alias: string;
  nombreReceptor: string;
  telefono: string;
  calle: string;
  numExterior: string;
  numInterior?: string;
  colonia: string;
  codigoPostal: string;
  ciudad?: string;
  estado?: string;
  referencias?: string;
  esPredeterminada?: boolean;
}

export interface CoverageCheckResponse {
  disponible: boolean;
  costoEnvio: number;
  tiempoEstimado: string;
  zona?: string;
}
