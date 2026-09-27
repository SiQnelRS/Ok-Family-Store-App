import { RolUsuario, ProveedorAuth } from './enums';

export interface UserPayload {
  id: string;
  email: string;
  nombre: string;
  rol: RolUsuario;
}

export interface RegisterDTO {
  nombre: string;
  email: string;
  password?: string;
  telefono?: string;
}

export interface LoginDTO {
  email: string;
  password: string;
}

export interface AuthResponse {
  token: string;
  user: {
    id: string;
    nombre: string;
    email: string;
    rol: RolUsuario;
    proveedorAuth: ProveedorAuth;
  };
}
