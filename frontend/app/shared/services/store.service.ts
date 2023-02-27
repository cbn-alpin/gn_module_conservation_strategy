import { Injectable } from "@angular/core";
import { Observable } from 'rxjs';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';

import { ITaxonData } from "../models/stats.model";

@Injectable()
export class StoreService {
  private selectedPriorityTaxon: BehaviorSubject<number> = new BehaviorSubject(null);
  private selectedPriorityTaxonData:
    BehaviorSubject<ITaxonData> = new BehaviorSubject<ITaxonData>({
      taxonCode: null,
      territoryId: null
    });

  get priorityTaxon(): number {
    return this.selectedPriorityTaxon.getValue();
  }

  set priorityTaxon(priorityTaxonId: number) {
    this.selectedPriorityTaxon.next(priorityTaxonId)
  }
  
  get $selectedPriorityTaxon(): Observable<number>{
    return this.selectedPriorityTaxon.asObservable();
  }

  get priorityTaxonData(): ITaxonData {
    return this.selectedPriorityTaxonData.getValue();
  }

  set priorityTaxonData(taxonData: ITaxonData) {
    this.selectedPriorityTaxonData.next(taxonData)
  }

  get $selectedPriorityTaxonData(): Observable<ITaxonData> {
    return this.selectedPriorityTaxonData.asObservable();
  }

}
