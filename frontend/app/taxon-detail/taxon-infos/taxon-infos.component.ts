import { Component, OnDestroy, OnInit } from '@angular/core';

//import { CarouselConfig } from '@librairies/ngx-bootstrap/carousel/carousel.config';
import { CarouselConfig } from '@librairies/ngx-bootstrap/carousel';

import { Observable, Subscription } from '@librairies/rxjs';

import { ConfigService } from '../../shared/services/config.service';
import { DataService } from '../../shared/services/data.service';
import { StoreService } from '../../shared/services/store.service';

interface ITaxon {
  taxhubRecordId: number;
  refNameCode: number;
}

@Component({
  selector: 'cs-taxon-infos',
  templateUrl: './taxon-infos.component.html',
  styleUrls: ['./taxon-infos.component.scss'],
  providers: [
    { provide: CarouselConfig, useValue: { interval: 5000, noPause: false, showIndicators: true } }
  ]
})
export class TaxonInfosComponent implements OnInit, OnDestroy {

  taxhubBaseUrl: string;
  taxhubEditFormUrl: string;
  taxonInfos: Observable<Partial<ITaxon>>;
  territorySubcription: Subscription;

  constructor(
    private cfg: ConfigService,
    private dataService: DataService,
    private store: StoreService,
  ) {
    this.taxhubBaseUrl = this.cfg.getTaxHubFrontendUrl();
  }

  ngOnInit() {
    this.territorySubcription = this.store.getSelectedTerritoryStatus.subscribe((status) => {
      if (status) {
        this.loadTaxonInfos();
      }
    });
  }

  ngOnDestroy(): void {
    this.territorySubcription.unsubscribe();
  }

  private loadTaxonInfos() {
    const territoryCode = this.store.selectedTerritory.code.toLowerCase();
    const taxonNameCode = this.store.selectedTaxon;
    const params = {
      "with-taxhub-attributs": true,
      "with-medias": true,
    }
    this.taxonInfos = this.dataService.getTaxonInfos(territoryCode, taxonNameCode, params);
    this.taxonInfos.subscribe((data) => {
      this.taxhubEditFormUrl = this.taxhubBaseUrl;
      if (data.taxhubRecordId) {
        this.taxhubEditFormUrl += `/#!/taxonform/edit/${data.taxhubRecordId}`;
      } else {
        this.taxhubEditFormUrl += `/#!/taxonform/new/${this.store.selectedTaxon}`;
      }
    });
  }
}
