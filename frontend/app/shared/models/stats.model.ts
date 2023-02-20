export interface IProspections {
    id: number;
    date: string;
    departement: string;
    municipality: string;
    presenceAreaNb: number;
}

export interface IStats {
    prospections: IProspections[];
}

export interface IStatParams {
    'area-code': string;
    'area-type': string;
    'date-start'?: string;
    'nbr'?: number;
    'taxon-code': number;
}

export interface ITaxonData {
    taxonCode: number;
    territoryId: number;
}
