import { Injectable } from "@angular/core";

import { Observable } from 'rxjs';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';
import { ITerritory } from "../models/assessment.model";


@Injectable()
export class StoreService {
  private taxon: number;
  private selectedTaxonStatus = new BehaviorSubject(false);

  get selectedTaxon(): number {
    return this.taxon;
  }

  set selectedTaxon(taxonNameCode: number) {
    this.taxon = taxonNameCode;
    this.selectedTaxonStatus.next
  }

  getSelectedTaxonStatus: Observable<Boolean> = this.selectedTaxonStatus.asObservable();
}
