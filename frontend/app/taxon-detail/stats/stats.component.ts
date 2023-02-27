import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

import { Observable } from '@librairies/rxjs';

import { DataService } from '../../shared/services/data.service';
import { StoreService } from '../../shared/services/store.service';
import { IStats } from '../../shared/models/stats.model';

@Component({
    selector: 'cs-stats',
    templateUrl: './stats.component.html',
    styleUrls: ['./stats.component.scss']
})
export class StatsComponent implements OnInit {

    stats: Observable<IStats>;

    constructor(
        private dataService: DataService,
        private storeService: StoreService,
        public route: ActivatedRoute,
    ) { }

    ngOnInit(): void {
        this.storeService.$selectedPriorityTaxonData.subscribe(data => {
            let taxonCode = data.taxonCode;
            let territoryId = data.territoryId;
            if (territoryId != null) {
                this.dataService.getTerritory(territoryId).subscribe(territory => {
                    let territoryCode = territory.areaCode;
                    let territoryType = territory.areaType;
                    this.stats = this.dataService.getStatsPriorityFlora({
                        'area-code': territoryCode,
                        'area-type': territoryType,
                        'taxon-code': taxonCode
                    })
                });
            }
        })
    }
}
