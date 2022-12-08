import { Injectable } from "@angular/core";

import { Observable } from 'rxjs';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';
import { Assessment } from "../models/assessment.model";

interface Territory {
  id: number;
  label: string;
  code: string;
  surface?: number;
  meshesTotal?: number;
}

@Injectable()
export class StoreService {
  private territory: Territory;
  private selectedTerritoryStatus = new BehaviorSubject(false);
  private taxon: number;
  private selectedTaxonStatus = new BehaviorSubject(false);

  get selectedTerritory(): Territory {
    return this.territory;
  }

  get selectedTaxon(): number {
    return this.taxon;
  }

  set selectedTerritory(territory: Territory) {
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
