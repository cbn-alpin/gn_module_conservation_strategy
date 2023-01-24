import { Component, OnInit } from '@angular/core';

import { CarouselConfig } from '@librairies/ngx-bootstrap/carousel';
import { Observable } from '@librairies/rxjs';

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
export class TaxonInfosComponent implements OnInit {

  taxhubBaseUrl: string;
  taxhubEditFormUrl: string;
  taxonInfos: Observable<Partial<ITaxon>>;

  constructor(
    private cfg: ConfigService,
    private dataService: DataService,
    private store: StoreService,
  ) {
    this.taxhubBaseUrl = this.cfg.getTaxHubFrontendUrl();
  }

  ngOnInit() {
    this.loadTaxonInfos();
  }

  private loadTaxonInfos() {
    const priorityTaxonId = this.store.selectedTaxon;
    const params = {
      "with-taxhub-attributs": true,
      "with-medias": true,
    }
    this.taxonInfos = this.dataService.getTaxonInfos(priorityTaxonId, params);
    this.taxonInfos.subscribe((data) => {
      this.taxhubEditFormUrl = this.taxhubBaseUrl;
      if (data.taxhubRecordId) {
        this.taxhubEditFormUrl += `/#!/taxonform/edit/${data.taxhubRecordId}`;
      } else {
        this.taxhubEditFormUrl += `/#!/taxonform/new/${data.refNameCode}`;
      }
    });
  }
}
