import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

import { DataService } from '../shared/services/data.service';
import { StoreService } from '../shared/services/store.service';
@Component({
  selector: 'cs-taxon-detail',
  templateUrl: './taxon-detail.component.html',
  styleUrls: ['./taxon-detail.component.scss']
})
export class CsTaxonDetailComponent implements OnInit {
  territoryCode: string;
  nameCode: number;
  displayFullName: string = '...';
  taxon: any;

  constructor(
    public route: ActivatedRoute,
    private dataService: DataService,
    public store: StoreService,
  ) {}

  ngOnInit() {
    this.extractRouteParams();
  }

  private extractRouteParams() {
    this.route.paramMap.subscribe(urlParams => {
      if (urlParams.has('territoryCode')) {
        this.territoryCode = urlParams.get('territoryCode');
        this.dataService.getTerritory(this.territoryCode).subscribe(territory => {
          this.store.selectedTerritory = territory;
        });
      }

      if (urlParams.has('shortName')) {
        this.displayFullName = urlParams.get('shortName');
      }

      if (urlParams.has('nameCode')) {
        let nameCode = parseInt(urlParams.get('nameCode'));
        this.nameCode = nameCode;
        this.store.selectedTaxon = nameCode;
      }

      this.loadTaxon();
    });
  }

  private loadTaxon() {
    this.dataService.getTaxon(this.territoryCode, this.nameCode).subscribe(data => {
      this.taxon = data;
    });
  }

}
