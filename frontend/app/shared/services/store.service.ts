import { Injectable } from "@angular/core";

import { Observable } from 'rxjs';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';
import { ITerritory } from "../models/assessment.model";


@Injectable()
export class StoreService {
  private territory: ITerritory;
  private selectedTerritoryStatus = new BehaviorSubject(false);
  private taxon: number;
  private selectedTaxonStatus = new BehaviorSubject(false);

  get selectedTerritory(): ITerritory {
    return this.territory;
  }

  get selectedTaxon(): number {
    return this.taxon;
  }

  set selectedTerritory(territory: ITerritory) {
    this.territory = territory;
    this.selectedTerritoryStatus.next(true);
  }

  set selectedTaxon(taxonNameCode: number) {
    this.taxon = taxonNameCode;
    this.selectedTaxonStatus.next
  }

  getSelectedTerritoryStatus: Observable<Boolean> = this.selectedTerritoryStatus.asObservable();

  getSelectedTaxonStatus: Observable<Boolean> = this.selectedTaxonStatus.asObservable();
}
