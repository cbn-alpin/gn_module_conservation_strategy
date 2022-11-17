import { Injectable } from "@angular/core";

import { Observable } from 'rxjs';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';

interface Territory {
  id: number;
  label: string;
  code: string;
  surface?: number;
  meshesTotal?: number;
}

interface Organism {
  id: number;
  label: string;
}

@Injectable()
export class StoreService {
  private territory: Territory;
  private selectedTerritoryStatus = new BehaviorSubject(false);
  private taxon: number;
  private selectedTaxonStatus = new BehaviorSubject(false);
  private organism: Organism;
  private selectedOrganismStatus = new BehaviorSubject(false);

  get selectedTerritory(): Territory {
    return this.territory;
  }

  get selectedTaxon(): number {
    return this.taxon;
  }

  get selectedOrganism(): Organism {
    return this.organism;
  }

  set selectedTerritory(territory: Territory) {
    this.territory = territory;
    this.selectedTerritoryStatus.next(true);
  }

  set selectedTaxon(taxonNameCode: number) {
    this.taxon = taxonNameCode;
    this.selectedTaxonStatus.next
  }

  set selectedOrganism(organism: Organism) {
    this.organism = organism;
    this.selectedOrganismStatus.next(true);
  }

  getSelectedTerritoryStatus: Observable<Boolean> = this.selectedTerritoryStatus.asObservable();

  getSelectedTaxonStatus: Observable<Boolean> = this.selectedTaxonStatus.asObservable();

  getSelectedOrganismStatus: Observable<Boolean> = this.selectedOrganismStatus.asObservable();

}
