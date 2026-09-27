import { TipoProducto, EstadoProducto } from './enums';

export interface ProductImageDTO {
  id?: string;
  url: string;
  publicId?: string | null;
  orden: number;
  esPortada: boolean;
}

export interface ProductDTO {
  id: string;
  categoriaId: string;
  categoriaNombre?: string;
  sku?: string | null;
  nombre: string;
  descripcion: string;
  tipo: TipoProducto;
  precio: number;
  cantidadStock: number;
  cantidadDisponible: number;
  estado: EstadoProducto;
  version: number;
  fechaPublicacion: string;
  imagenes: ProductImageDTO[];
}

export interface CreateProductDTO {
  categoriaId: string;
  sku?: string;
  nombre: string;
  descripcion: string;
  tipo: TipoProducto;
  precio: number;
  cantidadStock: number;
  imagenes: {
    url: string;
    publicId?: string;
    orden?: number;
    esPortada?: boolean;
  }[];
}

export interface UpdateProductDTO extends Partial<CreateProductDTO> {
  estado?: EstadoProducto;
}

export interface CatalogFilterDTO {
  categoriaId?: string;
  tipo?: TipoProducto;
  estado?: EstadoProducto;
  precioMin?: number;
  precioMax?: number;
  busqueda?: string;
  limite?: number;
  pagina?: number;
}
