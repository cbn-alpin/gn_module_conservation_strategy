export interface IProspections {
    id: number;
    date: string;
    departement: string;
    municipality: string;
    presenceAreaNb: number;
}

export interface IPopulations {
    idAp: number;
    idZp: number;
    areaAp: string;
    occurrenceFrequency?: number;
    count: number;
    municipality: string;
    estimateMethod?: string;
    countingType?: string;
}

export interface IHabitats {
    idAp: number;
    idZp: number;
    conservationStatus?: string;
    habitatType?: string;
    perturbationType?: string;
    threatLevel?: string;
}

export interface ICalculations {
    nbStations: number;
    areaPresence: number;
    threatLevel: number;
    habitatFavorable: number;
}

export interface IStats {
    prospections: IProspections[];
    populations: IPopulations[];
    habitats: IHabitats[];
    calculations: ICalculations[];
}

export interface IStatParams {
    'area-code': string;
    'area-type': string;
    'date-start'?: string;
    nbr?: number;
    'taxon-code': number;
}

export interface ITaxonData {
    taxonCode: number;
    territoryId: number;
}
